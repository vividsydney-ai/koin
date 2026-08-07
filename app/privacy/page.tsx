import { LegalPage } from "@/components/LegalPage";
import { PrivacyPolicy } from "@/components/legal/PrivacyPolicy";

export const metadata = {
  title: "Privacy Policy — Koinaku",
};

export default function PrivacyPage() {
  return (
    <LegalPage
      title="Privacy Policy"
      effectiveDate="20 July 2026"
      lastUpdated="20 July 2026"
      alternateHref="/privacy/id"
      alternateLabel="Baca versi Bahasa Indonesia"
    >
      <PrivacyPolicy locale="en" />
    </LegalPage>
  );
}
