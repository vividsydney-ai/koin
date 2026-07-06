"use client";

import { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { getUserSettings, updateProfile } from "@/lib/profile/client";

const editProfileSchema = z.object({
  displayName: z.string().min(1, "Display name is required").max(50, "Max 50 characters"),
  notificationsEnabled: z.boolean(),
});

type EditProfileForm = z.infer<typeof editProfileSchema>;

interface EditProfileModalProps {
  userId: string;
  currentDisplayName: string;
  onClose: () => void;
  onSaved: (displayName: string, notificationsEnabled: boolean) => void;
}

export default function EditProfileModal({
  userId,
  currentDisplayName,
  onClose,
  onSaved,
}: EditProfileModalProps) {
  const [serverError, setServerError] = useState<string | null>(null);
  const [loadingSettings, setLoadingSettings] = useState(true);

  const {
    register,
    handleSubmit,
    setValue,
    formState: { errors, isSubmitting },
  } = useForm<EditProfileForm>({
    defaultValues: {
      displayName: currentDisplayName,
      notificationsEnabled: true,
    },
  });

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      const settings = await getUserSettings(userId);
      if (!mounted) return;
      setValue("notificationsEnabled", settings?.notifications_enabled ?? true);
      setLoadingSettings(false);
    };
    load();
    return () => {
      mounted = false;
    };
  }, [userId, setValue]);

  const onSubmit = async (data: EditProfileForm) => {
    setServerError(null);

    const parsed = editProfileSchema.safeParse(data);
    if (!parsed.success) {
      setServerError(parsed.error.issues.map((issue) => issue.message).join(" "));
      return;
    }

    const result = await updateProfile({
      userId,
      displayName: parsed.data.displayName,
      notificationsEnabled: parsed.data.notificationsEnabled,
    });

    if (result.error) {
      setServerError(result.error);
      return;
    }

    onSaved(parsed.data.displayName, parsed.data.notificationsEnabled);
  };

  return (
    <div
      className="fixed inset-0 z-50 flex items-end justify-center bg-background/90 p-4 backdrop-blur-sm sm:items-center"
      role="dialog"
      aria-modal="true"
      aria-label="Edit profile"
    >
      <div className="w-full max-w-md overflow-hidden rounded-radius-lg bg-surface shadow-xl">
        <div className="border-b border-muted px-5 py-4">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-bold text-foreground">Edit profile</h2>
            <button
              onClick={onClose}
              className="text-sm font-semibold text-muted-foreground hover:text-foreground"
              aria-label="Close edit profile"
            >
              Close
            </button>
          </div>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="px-5 py-6">
          {serverError && (
            <p className="mb-4 rounded-radius-md bg-danger/10 p-3 text-sm text-danger">{serverError}</p>
          )}

          <div className="space-y-4">
            <div>
              <label htmlFor="displayName" className="block text-sm font-medium text-foreground">
                Display name
              </label>
              <input
                id="displayName"
                type="text"
                {...register("displayName")}
                className="mt-1.5 w-full rounded-radius-md border border-muted bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
                disabled={isSubmitting || loadingSettings}
              />
              {errors.displayName && (
                <p className="mt-1 text-xs text-danger">{errors.displayName.message}</p>
              )}
            </div>

            <label className="flex items-center gap-3 rounded-radius-md border border-muted bg-background p-3">
              <input
                type="checkbox"
                {...register("notificationsEnabled")}
                className="h-5 w-5 accent-primary"
                disabled={isSubmitting || loadingSettings}
              />
              <span className="text-sm text-foreground">Send streak reminder notifications</span>
            </label>
          </div>

          <div className="mt-6 flex gap-3">
            <button
              type="button"
              onClick={onClose}
              disabled={isSubmitting}
              className="flex-1 rounded-radius-md border border-muted bg-surface px-4 py-3 text-sm font-semibold text-foreground transition-colors hover:bg-muted/10 disabled:opacity-50"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSubmitting || loadingSettings}
              className="flex-1 rounded-radius-md bg-primary px-4 py-3 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
            >
              {isSubmitting ? "Saving..." : "Save"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
