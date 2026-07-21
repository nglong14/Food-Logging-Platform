import { NextResponse } from "next/server";

/** Error codes from docs/API.md §7 */
export const ErrorCode = {
  UNAUTHORIZED: "UNAUTHORIZED",
  PROFILE_REQUIRED: "PROFILE_REQUIRED",
  ANALYSIS_FAILED: "ANALYSIS_FAILED",
  UNSUPPORTED_CONDITION: "UNSUPPORTED_CONDITION",
  VALIDATION_ERROR: "VALIDATION_ERROR",
  INTERNAL_ERROR: "INTERNAL_ERROR",
} as const;

export type ErrorCode = (typeof ErrorCode)[keyof typeof ErrorCode];

const DEFAULT_STATUS: Record<ErrorCode, number> = {
  UNAUTHORIZED: 401,
  PROFILE_REQUIRED: 422,
  ANALYSIS_FAILED: 502,
  UNSUPPORTED_CONDITION: 400,
  VALIDATION_ERROR: 400,
  INTERNAL_ERROR: 500,
};

const DEFAULT_MESSAGE: Record<ErrorCode, string> = {
  UNAUTHORIZED: "Missing or invalid token",
  PROFILE_REQUIRED: "Health profile not set",
  ANALYSIS_FAILED: "AI pipeline error",
  UNSUPPORTED_CONDITION: "Unknown health condition",
  VALIDATION_ERROR: "Invalid request",
  INTERNAL_ERROR: "Internal server error",
};

export type ApiErrorBody = {
  error: {
    code: ErrorCode | string;
    message: string;
  };
};

export function apiError(
  code: ErrorCode,
  message?: string,
  status?: number,
): NextResponse<ApiErrorBody> {
  return NextResponse.json(
    {
      error: {
        code,
        message: message ?? DEFAULT_MESSAGE[code],
      },
    },
    { status: status ?? DEFAULT_STATUS[code] },
  );
}

export function apiSuccess<T>(data: T, status = 200): NextResponse<T> {
  return NextResponse.json(data, { status });
}
