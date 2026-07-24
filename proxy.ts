import { NextResponse, type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";
import { checkRateLimit } from "@/lib/rate-limit";

const PRIVATE_PREFIXES = [
  "/",
  "/learn",
  "/trade",
  "/friends",
  "/library",
  "/profile",
  "/certificate",
  "/brokerage",
  "/onboarding",
];

const PUBLIC_PREFIXES = [
  "/login",
  "/signup",
  "/forgot-password",
  "/reset-password",
  "/auth/callback",
  "/privacy",
  "/terms",
  "/api",
  "/native-test",
];

function isPublicPath(pathname: string): boolean {
  return PUBLIC_PREFIXES.some((prefix) => pathname === prefix || pathname.startsWith(`${prefix}/`));
}

function isPrivatePath(pathname: string): boolean {
  if (isPublicPath(pathname)) return false;
  return PRIVATE_PREFIXES.some((prefix) => {
    if (prefix === "/") return pathname === "/";
    return pathname === prefix || pathname.startsWith(`${prefix}/`);
  });
}

function redirectToLogin(request: NextRequest, response: NextResponse): NextResponse {
  const loginUrl = request.nextUrl.clone();
  loginUrl.pathname = "/login";
  loginUrl.searchParams.set("next", `${request.nextUrl.pathname}${request.nextUrl.search}`);

  const redirectResponse = NextResponse.redirect(loginUrl);
  response.cookies.getAll().forEach((cookie) => {
    redirectResponse.cookies.set(cookie);
  });
  response.headers.forEach((value, key) => {
    redirectResponse.headers.set(key, value);
  });
  return redirectResponse;
}

function tooManyRequests(response: NextResponse, resetAt: number): NextResponse {
  response.headers.set("X-RateLimit-Limit", String(response.headers.get("X-RateLimit-Limit") ?? "0"));
  response.headers.set("X-RateLimit-Remaining", "0");
  response.headers.set("X-RateLimit-Reset", String(resetAt));
  return new NextResponse("Too many requests. Please try again later.", {
    status: 429,
    statusText: "Too Many Requests",
    headers: response.headers,
  });
}

const RATE_LIMITED_AUTH_PATHS = ["/login", "/signup", "/forgot-password", "/reset-password"];
const AUTH_RATE_LIMIT = { windowMs: 60_000, maxRequests: 10 };
const CRON_RATE_LIMIT = { windowMs: 60_000, maxRequests: 30 };

function getRateLimitRule(pathname: string): { rule: { windowMs: number; maxRequests: number }; suffix: string } | null {
  if (RATE_LIMITED_AUTH_PATHS.some((p) => pathname === p || pathname.startsWith(`${p}/`))) {
    return { rule: AUTH_RATE_LIMIT, suffix: "auth" };
  }
  if (pathname.startsWith("/api/cron/")) {
    return { rule: CRON_RATE_LIMIT, suffix: "cron" };
  }
  return null;
}

export async function proxy(request: NextRequest) {
  const rateLimit = getRateLimitRule(request.nextUrl.pathname);
  if (rateLimit) {
    const result = checkRateLimit(request, rateLimit.rule, rateLimit.suffix);
    if (!result.allowed) {
      const response = NextResponse.next({ request });
      return tooManyRequests(response, result.resetAt);
    }
  }

  const { response, user } = await updateSession(request);

  if (isPrivatePath(request.nextUrl.pathname) && !user) {
    return redirectToLogin(request, response);
  }

  return response;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|manifest.json|icons/|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ico)$).*)",
  ],
};
