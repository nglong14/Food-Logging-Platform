import { createClient } from "@/lib/supabase/server";
import { apiError, apiSuccess, ErrorCode } from "@/lib/utils/api";

export async function POST() {
  const supabase = await createClient();
  const { error } = await supabase.auth.signOut();

  if (error) {
    return apiError(ErrorCode.INTERNAL_ERROR, error.message);
  }

  return apiSuccess({ ok: true });
}
