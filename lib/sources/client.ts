import { supabase } from "@/lib/auth/client";

export interface Source {
  id: string;
  sourceCode: string;
  title: string;
  localTitle: string | null;
  sourceTier: 1 | 2 | 3;
  sourceType: string;
  organization: string;
  url: string | null;
  isbn: string | null;
  language: string;
  publicationYear: number | null;
  status: "verified" | "needs_review" | "use_carefully" | "deprecated";
  synopsis: string | null;
  synopsisId: string | null;
  relevanceBlurb: string | null;
  relevanceBlurbId: string | null;
}

export async function getSources(): Promise<Source[]> {
  const { data, error } = await supabase
    .from("sources")
    .select(
      "id, source_code, title, local_title, source_tier, source_type, organization, url, isbn, language, publication_year, status, synopsis, synopsis_id, relevance_blurb, relevance_blurb_id"
    )
    .order("source_tier", { ascending: true })
    .order("title", { ascending: true });

  if (error) {
    console.error("getSources error:", error.message);
    return [];
  }

  return (
    data?.map((row) => ({
      id: row.id,
      sourceCode: row.source_code,
      title: row.title,
      localTitle: row.local_title ?? null,
      sourceTier: Number(row.source_tier) as Source["sourceTier"],
      sourceType: row.source_type,
      organization: row.organization,
      url: row.url ?? null,
      isbn: row.isbn ?? null,
      language: row.language ?? "id",
      publicationYear: row.publication_year ?? null,
      status: row.status as Source["status"],
      synopsis: row.synopsis ?? null,
      synopsisId: row.synopsis_id ?? null,
      relevanceBlurb: row.relevance_blurb ?? null,
      relevanceBlurbId: row.relevance_blurb_id ?? null,
    })) ?? []
  );
}
