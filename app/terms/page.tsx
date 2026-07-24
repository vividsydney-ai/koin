import { LegalPage } from "@/components/LegalPage";
import { TermsOfService } from "@/components/legal/TermsOfService";

export const metadata = {
  title: "Terms of Service — Koinaku",
};

export default function TermsPage() {
  return (
    <LegalPage
      title="Terms of Service"
      effectiveDate="20 July 2026"
      lastUpdated="20 July 2026"
      alternateHref="/terms/id"
      alternateLabel="Baca versi Bahasa Indonesia"
    >
      <TermsOfService locale="en" />
    </LegalPage>
  );
}
