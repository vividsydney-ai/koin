import { LegalPage } from "@/components/LegalPage";
import { TermsOfService } from "@/components/legal/TermsOfService";

export const metadata = {
  title: "Ketentuan Layanan — Koinaku",
};

export default function TermsIdPage() {
  return (
    <LegalPage
      title="Ketentuan Layanan"
      effectiveDate="20 Juli 2026"
      lastUpdated="20 Juli 2026"
      alternateHref="/terms"
      alternateLabel="Read English version"
    >
      <TermsOfService locale="id" />
    </LegalPage>
  );
}
