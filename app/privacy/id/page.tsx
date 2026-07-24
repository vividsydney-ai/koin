import { LegalPage } from "@/components/LegalPage";
import { PrivacyPolicy } from "@/components/legal/PrivacyPolicy";

export const metadata = {
  title: "Kebijakan Privasi — Koinaku",
};

export default function PrivacyIdPage() {
  return (
    <LegalPage
      title="Kebijakan Privasi"
      effectiveDate="20 Juli 2026"
      lastUpdated="20 Juli 2026"
      alternateHref="/privacy"
      alternateLabel="Read English version"
    >
      <PrivacyPolicy locale="id" />
    </LegalPage>
  );
}
