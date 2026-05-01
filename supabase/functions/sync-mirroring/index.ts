// Edge Function: sync-mirroring
//
// Reconciles account_ownership.mirroring_disabled (DB state) with the
// trading API's server-side mirroring state. Triggered by pg_cron once
// a minute via pg_net (see migration 20260503160000_mirroring_sync_cron).
//
// Pending rows are those where mirroring_synced_at IS NULL — set by a
// BEFORE UPDATE trigger whenever mirroring_disabled changes from any
// path other than the trading-proxy Edge Function itself (which writes
// synced_at in the same UPDATE so we skip its own work).
//
// Auth: requires the project's service-role key in the Authorization
// header. The cron job pulls it from vault.decrypted_secrets so it
// never appears in pg_dump or schema migrations.

import "@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const TRADING_API_BASE = "http://us-2-server.tradecopy.online:3310";
const TRADING_API_KEY = Deno.env.get("TRADING_API_KEY") ?? "";
const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_ROLE_KEY =
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

// Per-tick batch ceiling so we can't DOS the trading API if a renewal
// pass dumps thousands of rows at once. With a 1-minute cron, 100/min
// drains 6000 rows/hour — well above realistic load.
const BATCH_LIMIT = 100;

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

type Pending = {
  trading_account_id: number;
  platform: string;
  account_type: string;
  mirroring_disabled: boolean;
};

// Returns the trading API path for an activate/deactivate call. Today
// only MT4 + MT5 are supported; other platforms get an empty string and
// are skipped by the loop below (their rows stay unsync'd until manually
// reconciled, which is fine — the manual toggle button is gated to
// MT4/MT5 too, so they shouldn't drift in the first place).
function activatePath(platform: string, accountType: string): string {
  const role = accountType === "master" ? "master" : "slave";
  switch (platform.toLowerCase()) {
    case "mt5":
      return `/api/v1/active_${role}/MT5`;
    case "mt4":
      return `/api/v1/active_${role}/MT4`;
    default:
      return "";
  }
}

Deno.serve(async (req) => {
  if (!TRADING_API_KEY) {
    return json({ error: "TRADING_API_KEY not set" }, 500);
  }
  if (!SUPABASE_SERVICE_ROLE_KEY) {
    return json({ error: "SUPABASE_SERVICE_ROLE_KEY not set" }, 500);
  }

  // Auth: only accept the service-role key. Edge Functions normally
  // accept anon callers; we override that here because this function
  // touches account_ownership rows it doesn't own.
  const auth = req.headers.get("Authorization") ?? "";
  if (auth !== `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`) {
    return json({ error: "Unauthorized" }, 401);
  }

  const adminClient = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  // Pull pending rows. Order by trading_account_id (the PK) for
  // deterministic batch coverage — long-stuck rows still drain even
  // if newer rows keep appearing.
  const { data: pending, error: selErr } = await adminClient
    .from("account_ownership")
    .select(
      "trading_account_id, platform, account_type, mirroring_disabled",
    )
    .is("mirroring_synced_at", null)
    .order("trading_account_id", { ascending: true })
    .limit(BATCH_LIMIT);
  if (selErr) {
    console.error("sync-mirroring select failed:", selErr);
    return json({ error: selErr.message }, 500);
  }

  const rows = (pending ?? []) as Pending[];
  if (rows.length === 0) {
    return json({ processed: 0, succeeded: 0, failed: 0 });
  }

  let succeeded = 0;
  let failed = 0;

  for (const row of rows) {
    const path = activatePath(row.platform, row.account_type);
    if (path === "") {
      // Unsupported platform — skip, leave synced_at null so the row
      // stays visible. Operator can clear it by hand once the platform
      // gets activate-endpoint support.
      continue;
    }
    // status=true means "active" → mirroring_disabled=false on the DB.
    // We send the inverse of the DB flag.
    const status = !row.mirroring_disabled;
    const url =
      `${TRADING_API_BASE}${path}` +
      `?id=${row.trading_account_id}&status=${status}`;
    try {
      const upstream = await fetch(url, {
        method: "POST",
        headers: {
          "X-API-KEY": TRADING_API_KEY,
          Accept: "application/json",
        },
      });
      if (!upstream.ok) {
        failed += 1;
        console.error(
          `sync-mirroring upstream ${upstream.status} for ` +
            `serverId=${row.trading_account_id} (${row.platform})`,
        );
        continue;
      }
      // Trading API sometimes returns 200 with success:false in the body.
      // For activate the body is informational; we trust HTTP status here.
      // (If we ever see legitimate 200/false-success activates, revisit.)
      const { error: updErr } = await adminClient
        .from("account_ownership")
        .update({ mirroring_synced_at: new Date().toISOString() })
        .eq("trading_account_id", row.trading_account_id);
      if (updErr) {
        failed += 1;
        console.error(
          `sync-mirroring update failed for ` +
            `serverId=${row.trading_account_id}:`,
          updErr,
        );
        continue;
      }
      succeeded += 1;
    } catch (e) {
      failed += 1;
      console.error(
        `sync-mirroring network error for ` +
          `serverId=${row.trading_account_id}:`,
        e,
      );
    }
  }

  return json({ processed: rows.length, succeeded, failed });
});
