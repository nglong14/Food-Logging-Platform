import { createClient } from "@/lib/supabase/server";
import { apiError, apiSuccess, ErrorCode } from "@/lib/utils/api";
import { credentialsSchema } from "@/lib/auth/schemas";

export async function POST(request: Request) {
  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return apiError(ErrorCode.VALIDATION_ERROR, "Invalid JSON body");
  }

  const parsed = credentialsSchema.safeParse(body);
  if (!parsed.success) {
    return apiError(
      ErrorCode.VALIDATION_ERROR,
      parsed.error.issues[0]?.message ?? "Invalid credentials",
    );
  }

  const { email, password } = parsed.data;
  const supabase = await createClient();
  const { data, error } = await supabase.auth.signUp({ email, password });

  if (error) {
    return apiError(ErrorCode.VALIDATION_ERROR, error.message);
  }

  return apiSuccess(
    {
      user: data.user
        ? { id: data.user.id, email: data.user.email }
        : null,
      session: data.session
        ? {
            access_token: data.session.access_token,
            expires_at: data.session.expires_at,
          }
        : null,
    },
    201,
  );
}
