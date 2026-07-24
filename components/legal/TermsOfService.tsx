import { LegalSection } from "@/components/LegalPage";

export function TermsOfService({ locale }: { locale: "en" | "id" }) {
  if (locale === "id") {
    return <TermsOfServiceId />;
  }
  return <TermsOfServiceEn />;
}

function TermsOfServiceEn() {
  return (
    <>
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
    </>
  );
}

function TermsOfServiceId() {
  return (
    <>
      <LegalSection title="1. Tentang Ketentuan ini">
        <p>
          Ketentuan Layanan ini adalah perjanjian hukum antara kamu dan{" "}
          <strong>Vivid Savitri-Hampton yang berdagang sebagai Koinaku</strong> (“Koinaku”, “kami”),
          pengelola aplikasi web Koinaku di web.koinaku.com dan situs web koinaku.com (bersama,
          “Layanan”). Dengan membuat akun atau menggunakan Layanan, kamu setuju dengan Ketentuan ini
          dan Kebijakan Privasi kami. Jika tidak setuju, jangan gunakan Layanan.
        </p>
        <p>
          Koinaku dioperasikan dari Australia untuk pengguna utama di Indonesia. Hubungi kami di{" "}
          <a href="mailto:hello@koinaku.com" className="text-primary hover:underline">
            hello@koinaku.com
          </a>
          .
        </p>
      </LegalSection>

      <LegalSection title="2. Apa itu Koinaku (dan bukan)">
        <p>
          Koinaku adalah platform <strong>edukasi</strong> keuangan. Kami menawarkan pelajaran uang
          dan berinvestasi dalam ukuran ringkas, plus sandbox paper trading untuk berlatih dengan
          portofolio simulasi.
        </p>
        <p>
          <strong>Koinaku bukan:</strong> bank, pialang, perusahaan efek, manajer investasi, atau
          penasihat keuangan; penyedia saran produk keuangan; platform trading uang nyata; atau produk
          kripto. Tidak ada uang nyata yang disetor, diinvestasikan, ditarik, atau berisiko di Layanan.
        </p>
        <p>
          Tidak ada apa pun di Layanan yang menjadi rekomendasi untuk membeli, menjual, atau
          memegang efek atau produk keuangan. Sebelum membuat keputusan investasi nyata, lakukan riset
          sendiri dan pertimbangkan saran dari profesional berlisensi.
        </p>
      </LegalSection>

      <LegalSection title="3. Siapa yang boleh menggunakan Layanan">
        <ul className="list-disc space-y-2 pl-5">
          <li>Kamu harus berusia minimal 16 tahun.</li>
          <li>Jika kamu di bawah 18 tahun, orang tua atau wali harus membaca dan menyetujui Ketentuan ini atas nama kamu.</li>
          <li>Layanan tidak ditujukan untuk anak di bawah 16 tahun. Jika kami mengetahui akun milik anak di bawah 16 tahun, kami akan menghapus akun dan datanya.</li>
          <li>Kamu harus memberikan informasi pendaftaran yang akurat dan memperbaruinya.</li>
          <li>Satu orang, satu akun. Jangan membuat akun atas nama orang lain.</li>
        </ul>
      </LegalSection>

      <LegalSection title="4. Akun kamu">
        <p>
          Kamu bertanggung jawab atas segala sesuatu yang terjadi di akun kamu dan menjaga
          kerahasiaan kata sandi. Segera beritahu kami di hello@koinaku.com jika kamu mencurigai
          akses tidak sah. Kami dapat menangguhkan atau menghentikan akun yang melanggar Ketentuan
          ini atau membahayakan integritas Layanan.
        </p>
      </LegalSection>

      <LegalSection title="5. Item virtual">
        <p>
          XP, level, rentetan (streak), lencana, Poin Koin, portofolio simulasi, dan sertifikat
          kelulusan adalah item virtual tanpa nilai moneter. Item virtual tidak dapat dibeli,
          dijual, ditukar, diuangkan, dipindahkan, atau dikonversi menjadi uang atau barang apa pun.
          Paper trading hanya menggunakan saldo Rupiah simulasi. Kami dapat menyesuaikan atau
          membatalkan item virtual yang diberikan karena kesalahan atau manipulasi.
        </p>
      </LegalSection>

      <LegalSection title="6. Kelulusan dan daftar aplikasi investasi">
        <p>
          Ketika portofolio simulasi mencapai ambang kelulusan, kami dapat menampilkan daftar aplikasi
          investasi terdaftar di OJK. Daftar ini hanya bersifat informasi — bukan rekomendasi,
          endorsement, perjanjian rujukan, atau saran keuangan, dan kami tidak menerima komisi darinya.
        </p>
      </LegalSection>

      <LegalSection title="7. Penggunaan yang boleh">
        <p>Kamu tidak boleh:</p>
        <ul className="list-disc space-y-2 pl-5">
          <li>melanggar hukum atau hak siapa pun;</li>
          <li>melakukan scraping, crawling, atau penyalinan massal tanpa izin tertulis;</li>
          <li>membobol, memindai, atau menguji kerentanan, atau mencoba menghindari keamanan (kecuali pengungkapan bertanggung jawab);</li>
          <li>merekayasa balik Layanan kecuali hukum melarang larangan tersebut;</li>
          <li>mengunggah malware, mengganggu Layanan, atau mengakses data pengguna lain;</li>
          <li>menggunakan Layanan untuk menyebarkan spam, penipuan, atau promosi finansial menyesatkan;</li>
          <li>meniru orang lain atau menyalahkan afiliasi;</li>
          <li>menggunakan bot atau otomatisasi untuk farming XP, trading, atau memanipulasi peringkat.</li>
        </ul>
      </LegalSection>

      <LegalSection title="8. Konten kami">
        <p>
          Pelajaran, kuis, contoh, teks, grafik, logo, dan perangkat lunak di Layanan dimiliki oleh atau
          dilisensikan kepada Koinaku dan dilindungi oleh hukum kekayaan intelektual. Kami memberikan
          kamu lisensi pribadi, non-eksklusif, tidak dapat dipindahkan, dan dapat dicabut untuk
          menggunakan Layanan untuk pembelajaran kamu sendiri. Konten pelajaran mengutip sumber
          pihak ketiga; sumber tersebut tetap menjadi milik pemiliknya dan kutipan bukan berarti
          endorsement.
        </p>
      </LegalSection>

      <LegalSection title="9. Konten dan masukan kamu">
        <p>
          Jika kamu mengirimkan masukan, saran, atau laporan bendera konten, kamu memberi kami lisensi
          non-eksklusif dan bebas royalti untuk menggunakannya untuk mengoperasikan dan meningkatkan
          Layanan.
        </p>
      </LegalSection>

      <LegalSection title="10. Fitur sosial dan papan peringkat">
        <p>
          Layanan mencakup pertemanan, kode undangan, kelompok, dan papan peringkat. Nama tampilan,
          avatar, XP, dan peringkat dapat terlihat oleh pengguna lain. Kamu dapat membatasi
          visibilitas papan peringkat di pengaturan. Tidak ada pesan langsung atau feed komunitas
          terbuka di Layanan.
        </p>
      </LegalSection>

      <LegalSection title="11. Layanan pihak ketiga">
        <p>
          Layanan berjalan di atas penyedia pihak ketiga (termasuk Supabase untuk database dan
          otentikasi, serta Netlify untuk hosting web) dan menyertakan tautan ke situs pihak ketiga.
          Kami tidak bertanggung jawab atas konten, ketentuan, atau praktik privasi pihak ketiga.
        </p>
      </LegalSection>

      <LegalSection title="12. Fitur berbayar (di masa depan)">
        <p>
          Layanan saat ini gratis. Kami dapat memperkenalkan langganan berbayar di kemudian hari. Jika
          demikian, kami akan menunjukkan harga, periode penagihan, dan syarat pembatalan sebelum
          kamu dikenakan biaya. Tidak ada biaya yang berlaku tanpa persetujuan eksplisit kamu.
        </p>
      </LegalSection>

      <LegalSection title="13. Penyangkalan">
        <p>
          Sejauh diizinkan oleh hukum, Layanan disediakan “sebagaimana adanya” dan “sebagaimana
          tersedia”. Kami tidak menjamin Layanan selalu tersedia tanpa gangguan atau bebas kesalahan,
          atau bahwa konten pelajaran selalu lengkap dan bebas kesalahan. Harga simulasi mungkin tidak
          mencerminkan harga pasar nyata setiap saat.
        </p>
        <p>
          Tidak ada bagian dari Ketentuan ini yang mengecualikan, membatasi, atau mengubah jaminan
          konsumen, hak, atau upaya hukum yang kamu miliki berdasarkan Hukum Konsumen Australia,
          hukum perlindungan konsumen Indonesia, atau hukum wajib lainnya.
        </p>
      </LegalSection>

      <LegalSection title="14. Tanggung jawab">
        <p>
          Sejauh diizinkan oleh hukum, kami tidak bertanggung jawab atas kerugian tidak langsung,
          insidental, khusus, konsekuensial, atau hukuman, atau kehilangan keuntungan, data, nama
          baik, atau peluang. Total tanggung jawab kami dibatasi pada yang lebih besar antara AUD 100
          dan jumlah yang kamu bayarkan kepada kami dalam 12 bulan sebelum klaim. Batasan ini tidak
          berlaku untuk tanggung jawab yang tidak dapat dibatasi berdasarkan hukum.
        </p>
      </LegalSection>

      <LegalSection title="15. Ganti rugi">
        <p>
          Kamu setuju untuk mengganti rugi kami atas klaim, kerugian, dan biaya yang timbul dari
          pelanggaran kamu terhadap Ketentuan ini, penyalahgunaan Layanan, atau pelanggaran hak siapa
          pun, kecuali sejauh disebabkan oleh pelanggaran atau kelalaian kami.
        </p>
      </LegalSection>

      <LegalSection title="16. Pengakhiran">
        <p>
          Kamu dapat berhenti menggunakan Layanan dan menghapus akun kapan saja di aplikasi atau
          dengan mengemail hello@koinaku.com. Kami dapat menangguhkan atau mengakhiri akses kamu
          karena pelanggaran Ketentuan ini, dengan pemberitahuan jika memungkinkan. Ketentuan yang
          secara alami harus bertahan (hak kekayaan intelektual, penyangkalan, tanggung jawab, hukum
          yang berlaku) tetap berlaku setelah pengakhiran.
        </p>
      </LegalSection>

      <LegalSection title="17. Perubahan">
        <p>
          Kami dapat mengubah Layanan dan Ketentuan ini dari waktu ke waktu. Untuk perubahan material,
          kami akan memberi pemberitahuan minimal 14 hari melalui email atau pemberitahuan mencolok di
          aplikasi. Jika kamu terus menggunakan Layanan setelah tanggal efektif, kamu menerima
          perubahan tersebut.
        </p>
      </LegalSection>

      <LegalSection title="18. Hukum yang berlaku dan sengketa">
        <p>
          Ketentuan ini diatur oleh hukum New South Wales, Australia. Pengadilan New South Wales
          memiliki yurisdiksi non-eksklusif. Pemilihan hukum ini tidak menghilangkan perlindungan
          wajib yang kamu miliki sebagai konsumen di negara tempat tinggal kamu, termasuk Indonesia.
          Sebelum mengajukan gugatan, hubungi kami di hello@koinaku.com dan beri kami 30 hari untuk
          menyelesaikan masalah secara informal.
        </p>
      </LegalSection>

      <LegalSection title="19. Umum">
        <p>
          Jika ada bagian Ketentuan ini yang tidak dapat ditegakkan, bagian lain tetap berlaku. Kegagalan
          kami menegakkan ketentuan bukanlah pengabaian. Ketentuan ini, bersama Kebijakan Privasi,
          merupakan keseluruhan perjanjian antara kamu dan kami tentang Layanan.
        </p>
      </LegalSection>

      <LegalSection title="20. Kontak">
        <p>
          <strong>Vivid Savitri-Hampton yang berdagang sebagai Koinaku</strong>
          <br />
          38 Sandstone Crescent, Tascott, NSW 2250, Australia
          <br />
          Email: hello@koinaku.com
          <br />
          Web: koinaku.com
        </p>
      </LegalSection>
    </>
  );
}
