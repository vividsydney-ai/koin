import { LegalPage, LegalSection } from "@/components/LegalPage";

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
      <LegalSection title="1. Who we are">
        <p>
          Koinaku is a financial education platform operated by{" "}
          <strong>Vivid Savitri-Hampton trading as Koinaku</strong>, 38 Sandstone Crescent, Tascott,
          NSW 2250, Australia, for users primarily in Indonesia. Contact us at{" "}
          <a href="mailto:hello@koinaku.com" className="text-primary hover:underline">
            hello@koinaku.com
          </a>
          .
        </p>
        <p>
          This Privacy Policy explains what personal data we collect, why we collect it, who we
          share it with, and the rights you have.
        </p>
      </LegalSection>

      <LegalSection title="2. Who this policy applies to">
        <p>
          Anyone who visits or uses the Service. The Service is for people 16 and older. If you are
          under 18, a parent or guardian must consent to your use. We do not knowingly collect
          personal data from children under 16; if we learn we have, we will delete it.
        </p>
      </LegalSection>

      <LegalSection title="3. What we collect">
        <ul className="list-disc space-y-2 pl-5">
          <li>
            <strong>Account data:</strong> email address, password (stored only as a cryptographic
            hash by our auth provider), username, display name, avatar.
          </li>
          <li>
            <strong>Profile data:</strong> age range, financial goals (up to 3), preferred language.
          </li>
          <li>
            <strong>Learning data:</strong> assessment answers and scores, lesson attempts,
            progress, quiz answers, recommendations shown.
          </li>
          <li>
            <strong>Gamification data:</strong> XP events, levels, streaks, badges, Koin Points.
          </li>
          <li>
            <strong>Simulated trading data:</strong> virtual portfolio, holdings, trades, watchlist,
            risk profile.
          </li>
          <li>
            <strong>Social data:</strong> friend connections, invite codes, cohort memberships,
            leaderboard rankings.
          </li>
          <li>
            <strong>Settings:</strong> notification preferences, streak reminder time, weekly report
            opt-in, leaderboard visibility.
          </li>
          <li>
            <strong>Usage and analytics events:</strong> in-app events, event properties, session
            identifiers, timestamps.
          </li>
          <li>
            <strong>Communications:</strong> support requests, feedback, content flags.
          </li>
          <li>
            <strong>Technical data:</strong> IP address, device and browser type, approximate region
            derived from IP (collected transiently by hosting providers).
          </li>
        </ul>
        <p>
          <strong>What we do not collect:</strong> real-money payment or bank details, government ID
          numbers, precise location, phone contacts, or data from real brokerage accounts.
        </p>
      </LegalSection>

      <LegalSection title="4. How we collect it">
        <ul className="list-disc space-y-2 pl-5">
          <li>Directly from you: signup, onboarding, settings, support emails.</li>
          <li>Automatically: gameplay, learning and analytics events as you use the Service.</li>
          <li>Not from third parties: we do not buy data or receive data from data brokers.</li>
        </ul>
      </LegalSection>

      <LegalSection title="5. Why we use it">
        <ul className="list-disc space-y-2 pl-5">
          <li>To create and manage your account and authenticate you.</li>
          <li>To deliver lessons, quizzes, streaks, XP, badges and Koin Points.</li>
          <li>To operate the paper-trading sandbox and graduation.</li>
          <li>To personalise your learning path and recommendations.</li>
          <li>To run leaderboards, friends and cohorts.</li>
          <li>To send streak reminders, weekly reports and service emails.</li>
          <li>To understand and improve the Service.</li>
          <li>To keep the Service secure and prevent abuse.</li>
          <li>To meet legal obligations and enforce our Terms.</li>
        </ul>
        <p>
          Automated decision-making: your risk profile and lesson recommendations are generated
          automatically from your activity, but they only affect which educational content you see.
        </p>
      </LegalSection>

      <LegalSection title="6. Cookies and similar technologies">
        <p>
          We use only strictly necessary cookies: secure, httpOnly session cookies that keep you
          signed in. We do not use advertising cookies, cross-site trackers or third-party analytics
          cookies.
        </p>
      </LegalSection>

      <LegalSection title="7. Who we share data with">
        <p>We share personal data only with the service providers that run the Service:</p>
        <ul className="list-disc space-y-2 pl-5">
          <li>
            <strong>Supabase</strong> — database, authentication, file storage (Japan/Singapore).
          </li>
          <li>
            <strong>Netlify</strong> — web hosting and content delivery (United States and CDN edge
            locations).
          </li>
          <li>
            <strong>Google Workspace</strong> — transactional email from hello@koinaku.com (United
            States).
          </li>
          <li>
            <strong>Fontshare (CDN)</strong> — delivery of brand fonts (CDN edge locations).
          </li>
        </ul>
        <p>
          We also disclose data if the law requires it, to protect rights and safety, or as part of a
          merger or asset sale with notice to you. We do not sell your personal data.
        </p>
      </LegalSection>

      <LegalSection title="8. International data transfers">
        <p>
          We operate from Australia and our providers process data in the locations listed above. For
          Indonesian users, cross-border transfers are made in line with UU PDP requirements. For
          EU/UK users, we rely on adequacy decisions where available and otherwise on Standard
          Contractual Clauses.
        </p>
      </LegalSection>

      <LegalSection title="9. How long we keep data">
        <ul className="list-disc space-y-2 pl-5">
          <li>Account and learning data: kept while your account is active.</li>
          <li>Analytics events: up to 24 months, then deleted or aggregated.</li>
          <li>Email and support records: up to 24 months after the conversation closes.</li>
          <li>Logs and security records: up to 12 months.</li>
          <li>Backups: deleted data may persist in encrypted backups for up to 30 days.</li>
        </ul>
        <p>
          When you delete your account, we delete or de-identify your personal data within 30 days,
          except what we must keep by law.
        </p>
      </LegalSection>

      <LegalSection title="10. How we protect data">
        <ul className="list-disc space-y-2 pl-5">
          <li>Encryption in transit (HTTPS everywhere) and at rest (provider-managed).</li>
          <li>Row Level Security on all user tables.</li>
          <li>Passwords handled by Supabase Auth and stored only as cryptographic hashes.</li>
          <li>Input validation and least-privilege access; secrets never committed to code.</li>
        </ul>
        <p>
          If a data breach occurs that is likely to harm you, we will notify you and the relevant
          regulator within the timeframes required by law.
        </p>
      </LegalSection>

      <LegalSection title="11. Your rights">
        <p>Everyone can exercise these rights by emailing hello@koinaku.com from their account email:</p>
        <ul className="list-disc space-y-2 pl-5">
          <li>Access, correct or delete your personal data.</li>
          <li>Object to or restrict certain processing.</li>
          <li>Withdraw consent where processing is based on consent.</li>
          <li>Receive your data in a structured, machine-readable format.</li>
        </ul>
        <p>
          Indonesian users have additional rights under UU PDP. Australian users may request access
          and correction under the Privacy Act. EU/UK users have GDPR rights. California users have
          CCPA/CPRA rights. We will not discriminate against you for exercising your rights.
        </p>
      </LegalSection>

      <LegalSection title="12. Children and age">
        <p>
          The Service is for people 16 and older. Users aged 16–17 may use the Service only with a
          parent or guardian&apos;s consent. If you believe a child under 16 has created an account, email
          us and we will delete the account and its data.
        </p>
      </LegalSection>

      <LegalSection title="13. Third-party links">
        <p>
          Lessons cite external sources, and graduation may list OJK-registered brokerages. We are
          not responsible for the privacy practices of third-party sites.
        </p>
      </LegalSection>

      <LegalSection title="14. Changes to this policy">
        <p>
          We will post changes here with a new “last updated” date. For material changes, we will
          notify you by email or prominent in-app notice at least 14 days before they take effect.
        </p>
      </LegalSection>

      <LegalSection title="15. Contact and complaints">
        <p>
          <strong>Data controller:</strong> Vivid Savitri-Hampton trading as Koinaku, 38 Sandstone
          Crescent, Tascott, NSW 2250, Australia
          <br />
          <strong>Privacy contact:</strong>{" "}
          <a href="mailto:hello@koinaku.com" className="text-primary hover:underline">
            hello@koinaku.com
          </a>
        </p>
      </LegalSection>
    </LegalPage>
  );
}
