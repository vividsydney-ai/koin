import { NextResponse, type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";

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

export async function proxy(request: NextRequest) {
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
