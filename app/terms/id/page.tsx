import { LegalPage, LegalSection } from "@/components/LegalPage";

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
    </LegalPage>
  );
}
