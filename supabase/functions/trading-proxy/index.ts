// Edge Function: trading-proxy
//
// Forwards QuantumPips admin-panel requests to the tradecopy.online
// trading API, injecting the X-API-KEY header server-side so the key
// never ships in the Flutter bundle. Requires an authenticated
// Supabase session — anon callers are rejected with 401.
//
// Path scheme:
//   Client  →  https://<proj>.supabase.co/functions/v1/trading-proxy/api/v1/<endpoint>
//   Forwarded → http://us-2-server.tradecopy.online:3310/api/v1/<endpoint>
//
// Special case: /api/v1/getAPIInfo additionally requires the key as a
// query parameter (server-side spec bug — header alone returns HTTP 400).
// We inject it transparently so the Flutter client doesn't need to know.

import "@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const TRADING_API_BASE = "http://us-2-server.tradecopy.online:3310";
const TRADING_API_KEY = Deno.env.get("TRADING_API_KEY") ?? "";

const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  // Flutter client sends X-API-KEY (legacy ApiKeyInterceptor still adds it
  // even though the proxy injects its own server-side key); accept and
  // ignore it. apikey/x-client-info are added by supabase-js calls.
  "Access-Control-Allow-Headers":
    "authorization, content-type, accept, x-api-key, x-client-info, apikey",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });

Deno.serve(async (req) => {
  // CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (!TRADING_API_KEY) {
    return json(
      { error: "Server misconfigured: TRADING_API_KEY env var is not set" },
      500,
    );
  }

  // Require an authenticated Supabase user. Edge Functions accept any
  // valid JWT (including the public anon key) by default; we explicitly
  // check for a real user session here.
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    {
      global: {
        headers: { Authorization: req.headers.get("Authorization") ?? "" },
      },
    },
  );
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return json(
      { error: "Unauthorized: requires authenticated Supabase session" },
      401,
    );
  }

  // Extract the trading-API path. The function URL may arrive as
  // /functions/v1/trading-proxy/api/v1/foo  (local dev)
  // or /trading-proxy/api/v1/foo            (production routing)
  // — anchor on /api/v1/ to be robust to both.
  const url = new URL(req.url);
  const apiIdx = url.pathname.indexOf("/api/v1/");
  if (apiIdx < 0) {
    return json(
      { error: `Invalid path '${url.pathname}': must contain /api/v1/<endpoint>` },
      400,
    );
  }
  const proxyPath = url.pathname.slice(apiIdx);

  // Build upstream URL
  let upstreamUrl = `${TRADING_API_BASE}${proxyPath}${url.search}`;

  // Server-side spec quirk: getAPIInfo demands the key as a query
  // parameter in addition to the header. Inject transparently.
  if (proxyPath === "/api/v1/getAPIInfo") {
    const sep = url.search ? "&" : "?";
    upstreamUrl += `${sep}key=${encodeURIComponent(TRADING_API_KEY)}`;
  }

  // Forward body for non-GET/HEAD methods
  let body: BodyInit | null = null;
  if (!["GET", "HEAD"].includes(req.method)) {
    const txt = await req.text();
    if (txt) body = txt;
  }

  // Forward to trading server
  let upstream: Response;
  try {
    upstream = await fetch(upstreamUrl, {
      method: req.method,
      headers: {
        "X-API-KEY": TRADING_API_KEY,
        "Accept": "application/json",
        ...(body
          ? {
              "Content-Type":
                req.headers.get("Content-Type") ?? "application/json",
            }
          : {}),
      },
      body,
    });
  } catch (e) {
    console.error("Upstream fetch failed:", e);
    return json(
      { error: `Upstream unreachable: ${(e as Error).message}` },
      502,
    );
  }

  // Pass through upstream response, layering CORS headers on top.
  // Strip hop-by-hop and content-encoding/length (Deno's fetch already
  // decompressed the body, so passing those would mislead the browser).
  const responseHeaders = new Headers();
  upstream.headers.forEach((value, key) => {
    const k = key.toLowerCase();
    if (
      [
        "transfer-encoding",
        "connection",
        "keep-alive",
        "content-encoding",
        "content-length",
      ].includes(k)
    ) {
      return;
    }
    responseHeaders.set(key, value);
  });
  Object.entries(corsHeaders).forEach(([k, v]) => responseHeaders.set(k, v));

  return new Response(upstream.body, {
    status: upstream.status,
    headers: responseHeaders,
  });
});
