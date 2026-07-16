import { z } from "zod";

export const emailSchema = z
  .string({ message: "Email is required" })
  .min(1, "Email is required")
  .email("Please enter a valid email address");

export const passwordSchema = z
  .string({ message: "Password is required" })
  .min(6, "Password must be at least 6 characters");

export const displayNameSchema = z
  .string({ message: "Full name is required" })
  .min(1, "Full name is required")
  .max(100, "Full name must be 100 characters or less");

export const signInSchema = z.object({
  email: emailSchema,
  password: passwordSchema,
});

export const signUpSchema = z
  .object({
    email: emailSchema,
    password: passwordSchema,
    confirmPassword: passwordSchema,
    displayName: displayNameSchema,
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords do not match",
    path: ["confirmPassword"],
  });

export const resendEmailSchema = z.object({
  email: emailSchema,
});

export type SignInInput = z.infer<typeof signInSchema>;
export type SignUpInput = z.infer<typeof signUpSchema>;
