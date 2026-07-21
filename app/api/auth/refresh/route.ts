import { createClient } from "@/lib/supabase/server";
import { apiError, apiSuccess, ErrorCode } from "@/lib/utils/api";

export async function POST() {
  const supabase = await createClient();
  const { data, error } = await supabase.auth.refreshSession();

  if (error || !data.session) {
    return apiError(
      ErrorCode.UNAUTHORIZED,
      error?.message ?? "Unable to refresh session",
    );
  }

  return apiSuccess({
    user: data.user
      ? { id: data.user.id, email: data.user.email }
      : null,
    session: {
      access_token: data.session.access_token,
      expires_at: data.session.expires_at,
    },
  });
}
