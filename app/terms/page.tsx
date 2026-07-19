import { LegalPage, LegalSection } from "@/components/LegalPage";

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
      <LegalSection title="1. About these Terms">
        <p>
          These Terms of Service are a legal agreement between you and{" "}
          <strong>Vivid Savitri-Hampton trading as Koinaku</strong> (“Koinaku”, “we”, “us”), the
          operator of the Koinaku web application at web.koinaku.com and the Koinaku website at
          koinaku.com (together, the “Service”). By creating an account or using the Service, you
          agree to these Terms and our Privacy Policy. If you do not agree, do not use the Service.
        </p>
        <p>
          Koinaku is operated from Australia for users primarily in Indonesia. Contact us at{" "}
          <a href="mailto:hello@koinaku.com" className="text-primary hover:underline">
            hello@koinaku.com
          </a>
          .
        </p>
      </LegalSection>

      <LegalSection title="2. What Koinaku is (and is not)">
        <p>
          Koinaku is a financial <strong>education</strong> platform. It offers bite-sized lessons
          about money and investing, plus a paper-trading sandbox where you practise with simulated
          portfolios.
        </p>
        <p>
          <strong>Koinaku is not:</strong> a bank, broker, securities company, investment manager or
          financial adviser; a provider of financial product advice; a real-money trading platform;
          or a cryptocurrency product. No real money is ever deposited, invested, withdrawn or at
          risk on the Service.
        </p>
        <p>
          Nothing on the Service is a recommendation to buy, sell or hold any security or financial
          product. Before making real investment decisions, do your own research and consider advice
          from a licensed professional.
        </p>
      </LegalSection>

      <LegalSection title="3. Who can use the Service">
        <ul className="list-disc space-y-2 pl-5">
          <li>You must be at least 16 years old.</li>
          <li>
            If you are under 18, a parent or legal guardian must read and agree to these Terms on
            your behalf.
          </li>
          <li>
            The Service is not directed at children under 16. If we learn an account belongs to
            someone under 16, we will delete it and the associated personal data.
          </li>
          <li>You must provide accurate registration information and keep it up to date.</li>
          <li>One person, one account. Do not create accounts on behalf of others.</li>
        </ul>
      </LegalSection>

      <LegalSection title="4. Your account">
        <p>
          You are responsible for everything that happens under your account and for keeping your
          password confidential. Tell us immediately at hello@koinaku.com if you suspect unauthorised
          access. We may suspend or terminate accounts that breach these Terms or compromise the
          integrity of the Service.
        </p>
      </LegalSection>

      <LegalSection title="5. Virtual items">
        <p>
          XP, levels, streaks, badges, Koin Points, simulated portfolios and graduation certificates
          are virtual items with no monetary value. They cannot be bought, sold, redeemed, exchanged,
          refunded, transferred or converted into money or anything of value. Paper trading uses
          simulated Rupiah balances only. We may adjust or void virtual items where they were granted
          in error or through manipulation.
        </p>
      </LegalSection>

      <LegalSection title="6. Graduation and brokerage pointers">
        <p>
          When a simulated portfolio reaches the graduation threshold, we may show you a list of
          investing apps registered with OJK. This list is informational only — it is not a
          recommendation, endorsement, referral arrangement or financial advice, and we do not
          receive commissions for it.
        </p>
      </LegalSection>

      <LegalSection title="7. Acceptable use">
        <p>You must not:</p>
        <ul className="list-disc space-y-2 pl-5">
          <li>break any applicable law or regulation, or infringe anyone&apos;s rights;</li>
          <li>scrape, crawl or bulk-copy the Service without written permission;</li>
          <li>
            probe, scan or test vulnerabilities, or attempt to bypass security (except responsible
            disclosure);
          </li>
          <li>reverse engineer the Service except where the law does not allow us to prohibit it;</li>
          <li>upload malware, interfere with the Service, or access another user&apos;s data;</li>
          <li>use the Service to distribute spam, scams or misleading financial promotions;</li>
          <li>impersonate another person or misrepresent your affiliation;</li>
          <li>use bots or automation to farm XP, trade, or manipulate rankings.</li>
        </ul>
      </LegalSection>

      <LegalSection title="8. Our content">
        <p>
          Lessons, quizzes, examples, text, graphics, logos and software on the Service are owned by
          or licensed to Koinaku and protected by intellectual property laws. We give you a personal,
          non-exclusive, non-transferable, revocable licence to use the Service for your own
          learning. Lesson content cites third-party sources; those sources remain the property of
          their owners and citations do not imply endorsement.
        </p>
      </LegalSection>

      <LegalSection title="9. Your content and feedback">
        <p>
          If you send us feedback, suggestions or content flags, you give us a non-exclusive,
          royalty-free licence to use them to operate and improve the Service.
        </p>
      </LegalSection>

      <LegalSection title="10. Social features and leaderboards">
        <p>
          The Service includes friend connections, invite codes, cohorts and leaderboards. Display
          names, avatars, XP and ranking may be visible to other users. You can limit leaderboard
          visibility in your settings. There are no direct messages or open community feeds.
        </p>
      </LegalSection>

      <LegalSection title="11. Third-party services">
        <p>
          The Service runs on third-party providers (including Supabase for data hosting and
          authentication, and Netlify for web hosting) and links to third-party sites. We are not
          responsible for third-party content, terms or privacy practices.
        </p>
      </LegalSection>

      <LegalSection title="12. Paid features (future)">
        <p>
          The Service is currently free. We may introduce paid subscriptions later. If we do, we will
          show you the price, billing period and cancellation terms before you are charged. No charge
          will ever apply without your explicit agreement.
        </p>
      </LegalSection>

      <LegalSection title="13. Disclaimers">
        <p>
          To the maximum extent permitted by law, the Service is provided “as is” and “as available”.
          We do not promise uninterrupted, error-free or always-available service, or that lesson
          content is complete or error-free at all times. Simulated prices may not reflect real
          market prices at any moment.
        </p>
        <p>
          Nothing in these Terms excludes, restricts or modifies any consumer guarantee, right or
          remedy you have under Australian Consumer Law, Indonesian consumer protection law or any
          other mandatory law.
        </p>
      </LegalSection>

      <LegalSection title="14. Liability">
        <p>
          To the maximum extent permitted by law, we are not liable for any indirect, incidental,
          special, consequential or punitive loss, or for loss of profits, data, goodwill or
          opportunity, arising from your use of the Service. Our total aggregate liability is limited
          to the greater of AUD 100 and the amount you paid us in the 12 months before the claim.
          These limits do not apply to liability that cannot be limited by law.
        </p>
      </LegalSection>

      <LegalSection title="15. Indemnity">
        <p>
          You agree to indemnify us against claims, losses and expenses arising from your breach of
          these Terms, your misuse of the Service, or your infringement of anyone&apos;s rights, except
          to the extent caused by our breach or negligence.
        </p>
      </LegalSection>

      <LegalSection title="16. Ending the agreement">
        <p>
          You can stop using the Service and delete your account at any time in-app or by emailing
          hello@koinaku.com. We may suspend or end your access for breach of these Terms, with notice
          where practicable. Provisions that by their nature should survive (intellectual property,
          disclaimers, liability, governing law) survive termination.
        </p>
      </LegalSection>

      <LegalSection title="17. Changes">
        <p>
          We may change the Service and these Terms from time to time. For material changes, we will
          give at least 14 days&apos; notice by email or prominent in-app notice. If you keep using the
          Service after the effective date, you accept the changes.
        </p>
      </LegalSection>

      <LegalSection title="18. Governing law and disputes">
        <p>
          These Terms are governed by the laws of New South Wales, Australia. The courts of New South
          Wales have non-exclusive jurisdiction. This choice of law does not deprive you of any
          mandatory protection you have as a consumer under the law of the country where you live,
          including Indonesia. Before going to court, contact us at hello@koinaku.com and give us 30
          days to resolve the issue informally.
        </p>
      </LegalSection>

      <LegalSection title="19. General">
        <p>
          If any part of these Terms is unenforceable, the rest continues to apply. Our failure to
          enforce a provision is not a waiver of it. These Terms, together with the Privacy Policy,
          are the entire agreement between you and us about the Service.
        </p>
      </LegalSection>

      <LegalSection title="20. Contact">
        <p>
          <strong>Vivid Savitri-Hampton trading as Koinaku</strong>
          <br />
          38 Sandstone Crescent, Tascott, NSW 2250, Australia
          <br />
          Email: hello@koinaku.com
          <br />
          Web: koinaku.com
        </p>
      </LegalSection>
    </LegalPage>
  );
}
