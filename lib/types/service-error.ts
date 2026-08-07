/**
 * A domain-agnostic service error.
 *
 * Used by the service layer so callers never receive raw database
 * or third-party SDK errors.
 */
export type ServiceErrorCode =
  | "validation_error"
  | "not_found"
  | "unauthorized"
  | "conflict"
  | "rpc_error"
  | "network_error"
  | "unknown";

export interface ServiceError {
  code: ServiceErrorCode;
  message: string;
}

export function serviceError(code: ServiceErrorCode, message: string): ServiceError {
  return { code, message };
}
