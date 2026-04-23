import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type RequestBody = {
  target_profile_id?: string;
  target_email?: string;
  new_password?: string;
  reason?: string;
};

const json = (status: number, body: Record<string, unknown>) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return json(405, { error: "Method not allowed" });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  if (!supabaseUrl || !serviceRoleKey || !anonKey) {
    return json(500, { error: "Missing function secrets" });
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader) {
    return json(401, { error: "Missing Authorization header" });
  }

  const callerClient = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: authHeader } },
  });
  const adminClient = createClient(supabaseUrl, serviceRoleKey);

  const {
    data: { user: caller },
    error: callerErr,
  } = await callerClient.auth.getUser();
  if (callerErr || !caller) {
    return json(401, { error: "Invalid auth session" });
  }

  let callerProfile: { id: string; email: string | null; profile_type: string | null } | null = null;

  const byId = await adminClient
    .from("profiles")
    .select("id, email, profile_type")
    .eq("id", caller.id)
    .maybeSingle();
  if (!byId.error && byId.data) {
    callerProfile = byId.data;
  } else {
    const callerEmail = caller.email?.trim().toLowerCase();
    if (callerEmail) {
      const byEmail = await adminClient
        .from("profiles")
        .select("id, email, profile_type")
        .ilike("email", callerEmail)
        .maybeSingle();
      if (!byEmail.error && byEmail.data) {
        callerProfile = byEmail.data;
      }
    }
  }

  if (!callerProfile) {
    return json(403, { error: "Profile not found for caller" });
  }

  const role = String(callerProfile.profile_type ?? "").toLowerCase();
  const isAdmin = role === "administrator" || role === "elivated";
  if (!isAdmin) {
    return json(403, { error: "Only admin/elevated can reset passwords" });
  }

  const body = (await req.json().catch(() => ({}))) as RequestBody;
  const targetProfileId = body.target_profile_id?.trim();
  const targetEmail = body.target_email?.trim().toLowerCase();
  const newPassword = body.new_password?.trim();
  const reason = body.reason?.trim() || "admin_support";

  if (!newPassword || newPassword.length < 8) {
    return json(400, { error: "new_password is required and must be at least 8 characters" });
  }
  if (!targetProfileId && !targetEmail) {
    return json(400, { error: "Provide target_profile_id or target_email" });
  }

  const windowStart = new Date(Date.now() - 60 * 60 * 1000).toISOString();
  const { count: recentCount, error: rateErr } = await adminClient
    .from("admin_password_resets_audit")
    .select("*", { count: "exact", head: true })
    .eq("requested_by_profile_id", callerProfile.id)
    .gte("created_at", windowStart);
  if (!rateErr && (recentCount ?? 0) >= 20) {
    return json(429, { error: "Rate limit reached. Try again later." });
  }

  let targetProfileIdResolved = targetProfileId ?? "";
  let targetEmailResolved = targetEmail ?? "";

  if (!targetProfileIdResolved) {
    const { data, error } = await adminClient
      .from("profiles")
      .select("id, email")
      .ilike("email", targetEmailResolved)
      .maybeSingle();
    if (error || !data) {
      return json(404, { error: "Target profile not found" });
    }
    targetProfileIdResolved = data.id;
    targetEmailResolved = String(data.email ?? targetEmailResolved);
  }

  let authUserId = "";
  let authUserEmail = "";
  {
    const { data: userById, error: authLookupErr } = await adminClient.auth.admin.getUserById(
      targetProfileIdResolved,
    );
    if (!authLookupErr && userById?.user) {
      authUserId = userById.user.id;
      authUserEmail = (userById.user.email ?? "").trim().toLowerCase();
    }
  }

  // Legacy fallback: profile id may not equal auth.users.id, so find auth user by email.
  if (!authUserId) {
    if (!targetEmailResolved) {
      const byProfile = await adminClient
        .from("profiles")
        .select("email")
        .eq("id", targetProfileIdResolved)
        .maybeSingle();
      if (!byProfile.error && byProfile.data?.email) {
        targetEmailResolved = String(byProfile.data.email).trim().toLowerCase();
      }
    }

    if (!targetEmailResolved) {
      return json(404, { error: "Target auth user not found (missing email fallback)" });
    }

    let page = 1;
    let found = false;
    while (!found && page <= 20) {
      const { data: listed, error: listErr } = await adminClient.auth.admin.listUsers({
        page,
        perPage: 1000,
      });
      if (listErr) {
        break;
      }
      const users = listed?.users ?? [];
      if (users.isEmpty) {
        break;
      }
      for (const u of users) {
        const em = (u.email ?? "").trim().toLowerCase();
        if (em === targetEmailResolved) {
          authUserId = u.id;
          authUserEmail = em;
          found = true;
          break;
        }
      }
      page += 1;
    }
  }

  if (!authUserId) {
    return json(404, { error: "Target auth user not found" });
  }
  if (!targetEmailResolved) {
    targetEmailResolved = authUserEmail;
  }

  const { error: updateErr } = await adminClient.auth.admin.updateUserById(authUserId, {
    password: newPassword,
  });
  if (updateErr) {
    return json(500, { error: updateErr.message });
  }

  const { error: auditErr } = await adminClient.from("admin_password_resets_audit").insert({
    requested_by_profile_id: callerProfile.id,
    requested_by_email: caller.email?.trim().toLowerCase(),
    target_profile_id: targetProfileIdResolved,
    target_email: targetEmailResolved,
    reason,
  });
  if (auditErr) {
    console.error("Audit insert failed", auditErr);
  }

  return json(200, {
    ok: true,
    target_profile_id: targetProfileIdResolved,
    target_email: targetEmailResolved,
    changed_at: new Date().toISOString(),
  });
});
