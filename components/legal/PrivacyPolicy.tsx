import { LegalSection } from "@/components/LegalPage";

export function PrivacyPolicy({ locale }: { locale: "en" | "id" }) {
  if (locale === "id") {
    return <PrivacyPolicyId />;
  }
  return <PrivacyPolicyEn />;
}

function PrivacyPolicyEn() {
  return (
    <>
      <LegalSection title="1. Who we are">
        <p>
          Koinaku is a financial education platform operated by <strong>Koinaku</strong> for users
          primarily in Indonesia. Contact us at{" "}
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
          We use only strictly necessary cookies, including secure session cookies that keep you
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
          <strong>Data controller:</strong> Koinaku
          <br />
          <strong>Privacy contact:</strong>{" "}
          <a href="mailto:hello@koinaku.com" className="text-primary hover:underline">
            hello@koinaku.com
          </a>
        </p>
      </LegalSection>
    </>
  );
}

function PrivacyPolicyId() {
  return (
    <>
      <LegalSection title="1. Siapa kami">
        <p>
          Koinaku adalah platform edukasi keuangan yang dioperasikan oleh <strong>Koinaku</strong>
          untuk pengguna utama di Indonesia. Hubungi kami di{" "}
          <a href="mailto:hello@koinaku.com" className="text-primary hover:underline">
            hello@koinaku.com
          </a>
          .
        </p>
        <p>
          Kebijakan Privasi ini menjelaskan data pribadi apa yang kami kumpulkan, mengapa kami
          mengumpulkannya, dengan siapa kami membagikannya, dan hak yang kamu miliki.
        </p>
      </LegalSection>

      <LegalSection title="2. Siapa yang terikat kebijakan ini">
        <p>
          Siapa pun yang mengunjungi atau menggunakan Layanan. Layanan ini untuk orang berusia 16
          tahun ke atas. Jika kamu di bawah 18 tahun, orang tua atau wali harus menyetujui
          penggunaanmu. Kami tidak dengan sengaja mengumpulkan data pribadi dari anak di bawah 16
          tahun; jika kami mengetahuinya, kami akan menghapusnya.
        </p>
      </LegalSection>

      <LegalSection title="3. Apa yang kami kumpulkan">
        <ul className="list-disc space-y-2 pl-5">
          <li>
            <strong>Data akun:</strong> alamat email, kata sandi (disimpan hanya sebagai hash
            kriptografi oleh penyedia auth kami), nama pengguna, nama tampilan, avatar.
          </li>
          <li>
            <strong>Data profil:</strong> rentang usia, tujuan keuangan (maksimal 3), bahasa pilihan.
          </li>
          <li>
            <strong>Data pembelajaran:</strong> jawaban dan skor asesmen, upaya pelajaran, progres,
            jawaban kuis, rekomendasi yang ditampilkan.
          </li>
          <li>
            <strong>Data gamifikasi:</strong> peristiwa XP, level, streak, lencana, Poin Koin.
          </li>
          <li>
            <strong>Data trading simulasi:</strong> portofolio virtual, kepemilikan, transaksi,
            daftar pantau, profil risiko.
          </li>
          <li>
            <strong>Data sosial:</strong> koneksi teman, kode undangan, keanggotaan kelompok,
            peringkat papan peringkat.
          </li>
          <li>
            <strong>Pengaturan:</strong> preferensi notifikasi, waktu pengingat streak, keikutsertaan
            laporan mingguan, visibilitas papan peringkat.
          </li>
          <li>
            <strong>Peristiwa penggunaan dan analitik:</strong> peristiwa dalam aplikasi, properti
            peristiwa, pengidentifikasi sesi, cap waktu.
          </li>
          <li>
            <strong>Komunikasi:</strong> permintaan dukungan, masukan, laporan bendera konten.
          </li>
          <li>
            <strong>Data teknis:</strong> alamat IP, jenis perangkat dan browser, perkiraan wilayah
            dari IP (dikumpulkan secara sementara oleh penyedia hosting).
          </li>
        </ul>
        <p>
          <strong>Apa yang tidak kami kumpulkan:</strong> detail pembayaran atau bank uang nyata,
          nomor ID pemerintah, lokasi presisi, kontak ponsel, atau data dari akun broker nyata.
        </p>
      </LegalSection>

      <LegalSection title="4. Bagaimana kami mengumpulkannya">
        <ul className="list-disc space-y-2 pl-5">
          <li>Langsung dari kamu: pendaftaran, onboarding, pengaturan, email dukungan.</li>
          <li>Otomatis: peristiwa gameplay, pembelajaran, dan analitik saat kamu menggunakan Layanan.</li>
          <li>Bukan dari pihak ketiga: kami tidak membeli data atau menerima data dari data broker.</li>
        </ul>
      </LegalSection>

      <LegalSection title="5. Mengapa kami menggunakannya">
        <ul className="list-disc space-y-2 pl-5">
          <li>Membuat dan mengelola akun kamu serta mengotentikasi kamu.</li>
          <li>Menyampaikan pelajaran, kuis, streak, XP, lencana, dan Poin Koin.</li>
          <li>Mengoperasikan sandbox paper trading dan kelulusan.</li>
          <li>Mempersonalisasi jalur pembelajaran dan rekomendasi kamu.</li>
          <li>Menjalankan papan peringkat, teman, dan kelompok.</li>
          <li>Mengirim pengingat streak, laporan mingguan, dan email layanan.</li>
          <li>Memahami dan meningkatkan Layanan.</li>
          <li>Menjaga keamanan Layanan dan mencegah penyalahgunaan.</li>
          <li>Memenuhi kewajiban hukum dan menegakkan Ketentuan kami.</li>
        </ul>
        <p>
          Pengambilan keputusan otomatis: profil risiko dan rekomendasi pelajaran dibuat secara
          otomatis dari aktivitas kamu, tetapi hanya memengaruhi konten edukasi yang kamu lihat.
        </p>
      </LegalSection>

      <LegalSection title="6. Cookie dan teknologi serupa">
        <p>
          Kami hanya menggunakan cookie yang sangat diperlukan, termasuk cookie sesi yang aman
          untuk menjaga kamu tetap masuk. Kami tidak menggunakan cookie iklan, pelacak lintas situs,
          atau cookie analitik pihak ketiga.
        </p>
      </LegalSection>

      <LegalSection title="7. Dengan siapa kami membagikan data">
        <p>Kami hanya membagikan data pribadi dengan penyedia layanan yang menjalankan Layanan:</p>
        <ul className="list-disc space-y-2 pl-5">
          <li>
            <strong>Supabase</strong> — database, otentikasi, penyimpanan file (Jepang/Singapura).
          </li>
          <li>
            <strong>Netlify</strong> — hosting web dan pengiriman konten (Amerika Serikat dan edge
            CDN).
          </li>
          <li>
            <strong>Google Workspace</strong> — email transaksional dari hello@koinaku.com (Amerika
            Serikat).
          </li>
          <li>
            <strong>Fontshare (CDN)</strong> — pengiriman font merek (edge CDN).
          </li>
        </ul>
        <p>
          Kami juga mengungkapkan data jika diwajibkan oleh hukum, untuk melindungi hak dan
          keselamatan, atau sebagai bagian dari merger atau penjualan aset dengan pemberitahuan
          kepada kamu. Kami tidak menjual data pribadi kamu.
        </p>
      </LegalSection>

      <LegalSection title="8. Transfer data internasional">
        <p>
          Kami beroperasi dari Australia dan penyedia kami memproses data di lokasi yang tercantum
          di atas. Untuk pengguna Indonesia, transfer lintas batas dilakukan sesuai dengan
          persyaratan UU PDP. Untuk pengguna UE/Inggris, kami mengandalkan keputusan kecukupan atau
          Standard Contractual Clauses.
        </p>
      </LegalSection>

      <LegalSection title="9. Berapa lama kami menyimpan data">
        <ul className="list-disc space-y-2 pl-5">
          <li>Data akun dan pembelajaran: disimpan selama akun kamu aktif.</li>
          <li>Peristiwa analitik: hingga 24 bulan, kemudian dihapus atau diagregasi.</li>
          <li>Email dan catatan dukungan: hingga 24 bulan setelah percakapan ditutup.</li>
          <li>Log dan catatan keamanan: hingga 12 bulan.</li>
          <li>Cadangan: data yang dihapus mungkin bertahan dalam cadangan terenkripsi hingga 30 hari.</li>
        </ul>
        <p>
          Ketika kamu menghapus akun, kami menghapus atau de-identifikasi data pribadi kamu dalam 30
          hari, kecuali yang harus kami simpan berdasarkan hukum.
        </p>
      </LegalSection>

      <LegalSection title="10. Bagaimana kami melindungi data">
        <ul className="list-disc space-y-2 pl-5">
          <li>Enkripsi dalam transit (HTTPS di mana-mana) dan saat istirahat (dikelola penyedia).</li>
          <li>Row Level Security pada semua tabel pengguna.</li>
          <li>Kata sandi ditangani oleh Supabase Auth dan disimpan hanya sebagai hash kriptografi.</li>
          <li>Validasi input dan akses least-privilege; rahasia tidak pernah dikomit ke kode.</li>
        </ul>
        <p>
          Jika terjadi pelanggaran data yang mungkin membahayakan kamu, kami akan memberitahumu dan
          regulator terkait dalam kerangka waktu yang diwajibkan oleh hukum.
        </p>
      </LegalSection>

      <LegalSection title="11. Hak kamu">
        <p>
          Setiap orang dapat menggunakan hak ini dengan mengemail hello@koinaku.com dari email akun
          mereka:
        </p>
        <ul className="list-disc space-y-2 pl-5">
          <li>Mengakses, memperbaiki, atau menghapus data pribadi kamu.</li>
          <li>Menolak atau membatasi pemrosesan tertentu.</li>
          <li>Menarik persetujuan jika pemrosesan didasarkan pada persetujuan.</li>
          <li>Menerima data kamu dalam format terstruktur yang dapat dibaca mesin.</li>
        </ul>
        <p>
          Pengguna Indonesia memiliki hak tambahan berdasarkan UU PDP. Pengguna Australia dapat
          meminta akses dan koreksi berdasarkan Privacy Act. Pengguna UE/Inggris memiliki hak GDPR.
          Pengguna California memiliki hak CCPA/CPRA. Kami tidak akan mendiskriminasi kamu karena
          menggunakan hak-hak ini.
        </p>
      </LegalSection>

      <LegalSection title="12. Anak dan usia">
        <p>
          Layanan ini untuk orang berusia 16 tahun ke atas. Pengguna berusia 16–17 tahun hanya boleh
          menggunakan Layanan dengan persetujuan orang tua atau wali. Jika kamu yakin anak di bawah
          16 tahun telah membuat akun, email kami dan kami akan menghapus akun serta datanya.
        </p>
      </LegalSection>

      <LegalSection title="13. Tautan pihak ketiga">
        <p>
          Pelajaran mengutip sumber eksternal, dan kelulusan dapat mencantumkan broker terdaftar di
          OJK. Kami tidak bertanggung jawab atas praktik privasi situs pihak ketiga.
        </p>
      </LegalSection>

      <LegalSection title="14. Perubahan kebijakan ini">
        <p>
          Kami akan memposting perubahan di sini dengan tanggal “terakhir diperbarui” yang baru.
          Untuk perubahan material, kami akan memberitahumu melalui email atau pemberitahuan mencolok
          di aplikasi minimal 14 hari sebelum berlaku.
        </p>
      </LegalSection>

      <LegalSection title="15. Kontak dan pengaduan">
        <p>
          <strong>Pengontrol data:</strong> Koinaku
          <br />
          <strong>Kontak privasi:</strong>{" "}
          <a href="mailto:hello@koinaku.com" className="text-primary hover:underline">
            hello@koinaku.com
          </a>
        </p>
      </LegalSection>
    </>
  );
}
