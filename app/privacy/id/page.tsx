import { LegalPage, LegalSection } from "@/components/LegalPage";

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
      <LegalSection title="1. Siapa kami">
        <p>
          Koinaku adalah platform edukasi keuangan yang dioperasikan oleh{" "}
          <strong>Vivid Savitri-Hampton yang berdagang sebagai Koinaku</strong>, 38 Sandstone
          Crescent, Tascott, NSW 2250, Australia, untuk pengguna utama di Indonesia. Hubungi kami
          di{" "}
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
            <strong>Data gamifikasi:</strong> peristiwa XP, level, rentetan, lencana, Poin Koin.
          </li>
          <li>
            <strong>Data trading simulasi:</strong> portofolio virtual, kepemilikan, transaksi,
            watchlist, profil risiko.
          </li>
          <li>
            <strong>Data sosial:</strong> koneksi teman, kode undangan, keanggotaan kelompok,
            peringkat papan peringkat.
          </li>
          <li>
            <strong>Pengaturan:</strong> preferensi notifikasi, waktu pengingat rentetan, opt-in
            laporan mingguan, visibilitas papan peringkat.
          </li>
          <li>
            <strong>Peristiwa penggunaan dan analitik:</strong> peristiwa dalam aplikasi, properti
            peristiwa, pengidentifikasi sesi, stempel waktu.
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
          <li>Menyampaikan pelajaran, kuis, rentetan, XP, lencana, dan Poin Koin.</li>
          <li>Mengoperasikan sandbox paper trading dan kelulusan.</li>
          <li>Mempersonalisasi jalur pembelajaran dan rekomendasi kamu.</li>
          <li>Menjalankan papan peringkat, teman, dan kelompok.</li>
          <li>Mengirim pengingat rentetan, laporan mingguan, dan email layanan.</li>
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
          Kami hanya menggunakan cookie yang sangat diperlukan: cookie sesi yang aman dan httpOnly
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
          <strong>Pengontrol data:</strong> Vivid Savitri-Hampton yang berdagang sebagai Koinaku,
          38 Sandstone Crescent, Tascott, NSW 2250, Australia
          <br />
          <strong>Kontak privasi:</strong>{" "}
          <a href="mailto:hello@koinaku.com" className="text-primary hover:underline">
            hello@koinaku.com
          </a>
        </p>
      </LegalSection>
    </LegalPage>
  );
}
