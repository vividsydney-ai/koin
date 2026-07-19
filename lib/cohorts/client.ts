import { supabase } from "@/lib/auth/client";

export interface CohortMembership {
  membershipId: string;
  cohortId: string;
  cohortName: string;
  alreadyMember: boolean;
}

export async function joinCohortByCode(userId: string, code: string): Promise<CohortMembership | null> {
  const { data, error } = await supabase.rpc("join_cohort_by_code", {
    p_user_id: userId,
    p_invite_code: code,
  });

  if (error || !data) {
    console.error("joinCohortByCode error:", error?.message);
    return null;
  }

  const raw = data as Record<string, unknown>;
  return {
    membershipId: String(raw.membership_id),
    cohortId: String(raw.cohort_id),
    cohortName: String(raw.cohort_name),
    alreadyMember: Boolean(raw.already_member),
  };
}

export interface Cohort {
  id: string;
  name: string;
  inviteCode: string | null;
  joinedAt: string;
  isCreator: boolean;
}

export async function getCohorts(userId: string): Promise<Cohort[]> {
  const { data, error } = await supabase
    .from("cohort_memberships")
    .select("id, joined_at, cohort:cohorts(id, name, invite_code, created_by)")
    .eq("user_id", userId)
    .order("joined_at", { ascending: false });

  if (error) {
    console.error("getCohorts error:", error.message);
    return [];
  }

  return (data ?? []).map((row: Record<string, unknown>) => {
    const cohort = (row.cohort as Record<string, unknown>) ?? {};
    return {
      id: String(cohort.id ?? ""),
      name: String(cohort.name ?? "Unknown"),
      inviteCode: cohort.invite_code === null || cohort.invite_code === undefined ? null : String(cohort.invite_code),
      joinedAt: String(row.joined_at ?? new Date().toISOString()),
      isCreator: cohort.created_by === userId,
    };
  });
}

export interface CreatedCohort {
  cohortId: string;
  name: string;
  inviteCode: string;
}

export interface CohortInviteResult {
  membershipId: string;
  cohortId: string;
  alreadyMember: boolean;
}

export async function inviteFriendToCohort(
  userId: string,
  friendId: string,
  cohortId: string
): Promise<CohortInviteResult | null> {
  const { data, error } = await supabase.rpc("invite_friend_to_cohort", {
    p_user_id: userId,
    p_friend_id: friendId,
    p_cohort_id: cohortId,
  });

  if (error || !data) {
    console.error("inviteFriendToCohort error:", error?.message);
    return null;
  }

  const raw = data as Record<string, unknown>;
  return {
    membershipId: String(raw.membership_id ?? ""),
    cohortId: String(raw.cohort_id ?? ""),
    alreadyMember: Boolean(raw.already_member),
  };
}

export async function createCohort(userId: string, name: string): Promise<CreatedCohort | null> {
  const { data, error } = await supabase.rpc("create_cohort", {
    p_user_id: userId,
    p_name: name,
  });

  if (error || !data) {
    console.error("createCohort error:", error?.message);
    return null;
  }

  const raw = data as Record<string, unknown>;
  return {
    cohortId: String(raw.cohort_id ?? ""),
    name: String(raw.name ?? ""),
    inviteCode: String(raw.invite_code ?? ""),
  };
}
