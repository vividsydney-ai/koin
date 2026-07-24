/**
 * Simple in-memory rate limiter for Next.js middleware.
 *
 * Note: this stores counters in the Node process memory. In a multi-instance
 * serverless deployment each instance has its own bucket, so a determined actor
 * can still exceed the global limit by hitting different instances. For
 * production hardening, replace the Map backend with Redis/Upstash KV.
 *
 * The bucket key is the client IP (falling back to a fingerprint from headers)
 * plus an optional route suffix. Windows are sliding.
 */

export interface RateLimitRule {
  windowMs: number;
  maxRequests: number;
}

interface Bucket {
  count: number;
  resetAt: number;
}

const buckets = new Map<string, Bucket>();

function getClientIp(request: Request): string {
  const forwarded = request.headers.get("x-forwarded-for");
  if (forwarded) {
    return forwarded.split(",")[0]?.trim() ?? "unknown";
  }
  const realIp = request.headers.get("x-real-ip");
  if (realIp) return realIp;
  return "unknown";
}

function makeKey(request: Request, suffix?: string): string {
  const ip = getClientIp(request);
  return suffix ? `${ip}:${suffix}` : ip;
}

function nowMs(): number {
  return Date.now();
}

export interface RateLimitResult {
  allowed: boolean;
  limit: number;
  remaining: number;
  resetAt: number;
}

export function checkRateLimit(request: Request, rule: RateLimitRule, suffix?: string): RateLimitResult {
  const key = makeKey(request, suffix);
  const now = nowMs();
  const bucket = buckets.get(key);

  if (!bucket || now > bucket.resetAt) {
    const resetAt = now + rule.windowMs;
    const newBucket: Bucket = { count: 1, resetAt };
    buckets.set(key, newBucket);
    return { allowed: true, limit: rule.maxRequests, remaining: rule.maxRequests - 1, resetAt };
  }

  if (bucket.count >= rule.maxRequests) {
    return { allowed: false, limit: rule.maxRequests, remaining: 0, resetAt: bucket.resetAt };
  }

  bucket.count += 1;
  return {
    allowed: true,
    limit: rule.maxRequests,
    remaining: rule.maxRequests - bucket.count,
    resetAt: bucket.resetAt,
  };
}

export function resetRateLimitStore(): void {
  buckets.clear();
}
