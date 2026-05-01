// Edge Function: trading-proxy
//
// Forwards QuantumPips requests to the tradecopy.online trading API,
// injecting the X-API-KEY header server-side so the key never ships in
// the Flutter bundle. Requires an authenticated Supabase session — anon
// callers are rejected with 401.
//
// Slice B.1 additions:
//   * Slot-quota gate on register endpoints — refuses 403 if the
//     trader's subscription quota is exhausted before the upstream
//     fetch fires.
//   * Ownership write on successful register response (POST 2xx).
//   * Ownership delete on successful delete response (DELETE 2xx).
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
const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
const SUPABASE_SERVICE_ROLE_KEY =
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

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

// Maps a register-endpoint path → (platform, account_type). Returns null
// for non-register paths. Path matching is case-sensitive to mirror the
// trading-API team's quirky naming (mt5 endpoints are PascalCase, mt4
// snake_case, etc).
type RegisterMatch = {
  platform:
    | "mt4"
    | "mt5"
    | "ctrader"
    | "dxtrade"
    | "tradelocker"
    | "matchtrade";
  accountType: "master" | "slave";
};

function matchRegister(path: string): RegisterMatch | null {
  // MT4
  if (path === "/api/v1/register_master_mt4") {
    return { platform: "mt4", accountType: "master" };
  }
  if (path === "/api/v1/register_slave_mt4") {
    return { platform: "mt4", accountType: "slave" };
  }
  // MT5
  if (path === "/api/v1/RegisterMasterForMT5") {
    return { platform: "mt5", accountType: "master" };
  }
  if (path === "/api/v1/RegisterSlaveForMT5") {
    return { platform: "mt5", accountType: "slave" };
  }
  // Other platforms — not in B.1 scope but we recognise the paths so
  // the gate engages once the trader app supports them.
  if (path === "/api/v1/register_master_ctrader") {
    return { platform: "ctrader", accountType: "master" };
  }
  if (path === "/api/v1/register_slave_ctrader") {
    return { platform: "ctrader", accountType: "slave" };
  }
  if (path === "/api/v1/register_master_DxTrade") {
    return { platform: "dxtrade", accountType: "master" };
  }
  if (path === "/api/v1/register_slave_dxTrade") {
    return { platform: "dxtrade", accountType: "slave" };
  }
  if (path === "/api/v1/register_master_tradeLocker") {
    return { platform: "tradelocker", accountType: "master" };
  }
  if (path === "/api/v1/register_slave_tradeLocker") {
    return { platform: "tradelocker", accountType: "slave" };
  }
  if (path === "/api/v1/register_master_matchTrade") {
    return { platform: "matchtrade", accountType: "master" };
  }
  if (path === "/api/v1/register_slave_matchTrade") {
    return { platform: "matchtrade", accountType: "slave" };
  }
  return null;
}

// /api/v1/follow/{X}  (slave delete)  → returns X
// /api/v1/source/{X}  (master delete) → returns X
// Otherwise null.
function matchDeleteId(path: string): bigint | null {
  const m = path.match(/^\/api\/v1\/(?:follow|source)\/(\d+)$/);
  if (!m) return null;
  try {
    return BigInt(m[1]);
  } catch {
    return null;
  }
}

// Matches the trading API's activate/deactivate endpoints. Today only
// MT4 + MT5 are supported in the trader UI; other platforms 404 the
// activate path on the API side anyway.
function matchActivate(path: string): boolean {
  return (
    path === "/api/v1/active_master/MT4" ||
    path === "/api/v1/active_slave/MT4" ||
    path === "/api/v1/active_master/MT5" ||
    path === "/api/v1/active_slave/MT5"
  );
}

// Matches the trading API's update_* endpoints. Today only MT4 + MT5
// are wired in the trader UI. The path casing on the trading API is
// inconsistent (update_Master_mt4 vs update_slave_mt4), so we match
// both shapes verbatim.
function matchUpdate(path: string): boolean {
  return (
    path === "/api/v1/update_Master_mt4" ||
    path === "/api/v1/update_slave_mt4" ||
    path === "/api/v1/update_Master_mt5" ||
    path === "/api/v1/update_slave_mt5"
  );
}

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
  const userClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    global: {
      headers: { Authorization: req.headers.get("Authorization") ?? "" },
    },
  });
  const { data: { user } } = await userClient.auth.getUser();
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

  // ---------------------------------------------------------------
  // Slot-quota gate — only on POST /register* endpoints.
  // ---------------------------------------------------------------
  const registerMatch = req.method === "POST" ? matchRegister(proxyPath) : null;
  if (registerMatch) {
    const { data: usage, error: usageErr } = await userClient.rpc(
      "get_my_slot_usage",
    );
    if (usageErr) {
      console.error("get_my_slot_usage failed:", usageErr);
      return json(
        { error: `Slot quota lookup failed: ${usageErr.message}` },
        500,
      );
    }
    const row = Array.isArray(usage) ? usage[0] : usage;
    const used = row?.used ?? 0;
    const quota = row?.quota ?? 0;
    if (used >= quota) {
      return json(
        {
          error:
            `Insufficient slot capacity (${used}/${quota} used). ` +
            `Buy more slots from the Plans tab to register additional accounts.`,
        },
        403,
      );
    }
  }

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

  // ---------------------------------------------------------------
  // Build response headers up front.
  // ---------------------------------------------------------------
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

  // ---------------------------------------------------------------
  // Register: read response body to extract the trading API's
  // serverId, write ownership row with both serverId + login_number,
  // then re-stream the buffered body to the client. We MUST buffer
  // here because reading consumes the body and we still need to
  // forward it.
  // ---------------------------------------------------------------
  if (registerMatch) {
    const bodyText = await upstream.text();
    if (upstream.ok) {
      const loginParam = url.searchParams.get("userId") ?? "";
      let serverId: number | null = null;
      try {
        const parsed = JSON.parse(bodyText) as Record<string, unknown>;
        // Trading API returns one of two shapes on HTTP 200:
        //   master: { data: <id>, success: true, ... }
        //   slave:  { value: { data: <id>, success: false, ... } }
        // The slave wrapper's `success: false` lies — registration
        // genuinely succeeded, the account is queryable on their side,
        // and `data` carries a valid numeric id. So we unwrap `value`
        // when present and trust the numeric `data` field over the
        // `success` flag.
        const inner =
          typeof parsed.value === "object" && parsed.value !== null
            ? (parsed.value as Record<string, unknown>)
            : parsed;
        const dataField = inner.data;
        if (
          typeof dataField === "number" &&
          Number.isFinite(dataField) &&
          dataField > 0
        ) {
          serverId = dataField;
        } else if (typeof dataField === "string") {
          const n = Number(dataField);
          if (Number.isFinite(n) && n > 0) serverId = n;
        }
      } catch (e) {
        console.error(
          "Could not parse register response body:",
          bodyText,
          e,
        );
      }

      if (serverId !== null && loginParam !== "") {
        const adminClient = createClient(
          SUPABASE_URL,
          SUPABASE_SERVICE_ROLE_KEY,
        );
        const displayName = url.searchParams.get("comment") || null;
        const { error: insertErr } = await adminClient
          .from("account_ownership")
          .insert({
            trading_account_id: serverId,
            login_number: loginParam,
            user_id: user.id,
            platform: registerMatch.platform,
            account_type: registerMatch.accountType,
            display_name: displayName,
          });
        if (insertErr) {
          console.error(
            `account_ownership insert failed (serverId=${serverId}, ` +
              `login=${loginParam}):`,
            insertErr,
          );
        }
      } else if (loginParam !== "" && serverId === null) {
        console.error(
          `Register HTTP ok but couldn't extract serverId from response. ` +
            `login=${loginParam}, body=${bodyText}`,
        );
      }
    }
    return new Response(bodyText, {
      status: upstream.status,
      headers: responseHeaders,
    });
  }

  // ---------------------------------------------------------------
  // Activate / deactivate: trading API toggles mirroring on its side,
  // we mirror the new state into account_ownership.mirroring_disabled
  // so the UI's STATUS pill stays in sync. Query params: id, status.
  // (status=true → active → mirroring_disabled=false, and vice versa.)
  // ---------------------------------------------------------------
  if (req.method === "POST" && upstream.ok && matchActivate(proxyPath)) {
    const idParam = url.searchParams.get("id") ?? "";
    const statusParam = url.searchParams.get("status") ?? "";
    if (idParam !== "" && (statusParam === "true" || statusParam === "false")) {
      const adminClient = createClient(
        SUPABASE_URL,
        SUPABASE_SERVICE_ROLE_KEY,
      );
      // mirroring_synced_at = now() in the same UPDATE so the
      // sync-mirroring cron skips this row — we already pinged the
      // trading API ourselves a few lines above.
      const { error: updErr } = await adminClient
        .from("account_ownership")
        .update({
          mirroring_disabled: statusParam !== "true",
          mirroring_synced_at: new Date().toISOString(),
        })
        .eq("trading_account_id", idParam)
        .eq("user_id", user.id);
      if (updErr) {
        console.error(
          `account_ownership mirroring update failed (id=${idParam}, ` +
            `status=${statusParam}):`,
          updErr,
        );
      }
    }
  }

  // ---------------------------------------------------------------
  // Update: trading API rotates password/server/comment for an
  // existing master or slave. We never persist password or server,
  // but `comment` is the trader-facing label so we mirror it into
  // account_ownership.display_name. The API's `userId` query param
  // here is the internal serverId (different semantics from register),
  // so we match the row on trading_account_id AND user_id — a trader
  // can't relabel someone else's row by guessing a serverId.
  // ---------------------------------------------------------------
  if (req.method === "POST" && upstream.ok && matchUpdate(proxyPath)) {
    const serverIdParam = url.searchParams.get("userId") ?? "";
    const commentParam = url.searchParams.get("comment");
    if (serverIdParam !== "" && commentParam !== null) {
      const adminClient = createClient(
        SUPABASE_URL,
        SUPABASE_SERVICE_ROLE_KEY,
      );
      const trimmed = commentParam.trim();
      const { error: updErr } = await adminClient
        .from("account_ownership")
        .update({ display_name: trimmed === "" ? null : trimmed })
        .eq("trading_account_id", serverIdParam)
        .eq("user_id", user.id);
      if (updErr) {
        console.error(
          `account_ownership display_name update failed ` +
            `(serverId=${serverIdParam}):`,
          updErr,
        );
      }
    }
  }

  // ---------------------------------------------------------------
  // Delete: ownership row is keyed on trading_account_id (= serverId),
  // which is the same X the trading API takes in the path. Stream the
  // body through; do the DB delete in parallel.
  // ---------------------------------------------------------------
  if (req.method === "DELETE" && upstream.ok) {
    const deleteId = matchDeleteId(proxyPath);
    if (deleteId !== null) {
      const adminClient = createClient(
        SUPABASE_URL,
        SUPABASE_SERVICE_ROLE_KEY,
      );
      const { error: delErr } = await adminClient
        .from("account_ownership")
        .delete()
        .eq("trading_account_id", deleteId.toString());
      if (delErr) {
        console.error(
          `account_ownership delete failed for serverId=${deleteId}:`,
          delErr,
        );
      }
    }
  }

  return new Response(upstream.body, {
    status: upstream.status,
    headers: responseHeaders,
  });
});
