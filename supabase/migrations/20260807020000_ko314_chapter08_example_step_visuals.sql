-- KO-314: put context-specific instructional visuals into the learner's
-- "How this plays out" step. These are illustrative/calculated and are not
-- additional market data or recommendations.

BEGIN;

WITH blocks(slug, block_type, display_order, data_status, content) AS (
  VALUES
    ('etfs-investing-with-one-click-part-2', 'worked_example', 10, 'calculated', jsonb_build_object(
      'en', jsonb_build_object(
        'eyebrow', 'Price mechanics',
        'title', 'A unit calculation is not a return forecast',
        'disclosure', 'Illustrative arithmetic before fees — not a live ETF quote or return promise.',
        'altText', 'A worked example multiplying 100 ETF units by an illustrative price, followed by the boundary that arithmetic is not a forecast.',
        'payload', jsonb_build_object(
          'inputs', jsonb_build_array(jsonb_build_object('label', 'Units', 'value', '100'), jsonb_build_object('label', 'Illustrative unit price', 'value', 'Rp 5,000'), jsonb_build_object('label', 'Gross amount', 'value', 'Rp 500,000')),
          'steps', jsonb_build_array('100 units × Rp 5,000 = Rp 500,000 before costs.', 'Check the current basket, fees, tracking, and liquidity separately.', 'Do not turn the multiplication into a future-value claim.'),
          'outcome', 'The calculation explains what is paid in the example; it does not tell you what the ETF will earn.'
        )
      ),
      'id', jsonb_build_object(
        'eyebrow', 'Mekanisme harga',
        'title', 'Perhitungan unit bukan prediksi imbal hasil',
        'disclosure', 'Aritmetika ilustratif sebelum biaya — bukan kutipan ETF atau janji imbal hasil.',
        'altText', 'Contoh perhitungan 100 unit ETF dikalikan harga ilustratif, lalu batas bahwa aritmetika bukan prediksi.',
        'payload', jsonb_build_object(
          'inputs', jsonb_build_array(jsonb_build_object('label', 'Unit', 'value', '100'), jsonb_build_object('label', 'Harga unit ilustratif', 'value', 'Rp 5.000'), jsonb_build_object('label', 'Jumlah kotor', 'value', 'Rp 500.000')),
          'steps', jsonb_build_array('100 unit × Rp 5.000 = Rp 500.000 sebelum biaya.', 'Periksa keranjang, biaya, pelacakan, dan likuiditas terbaru secara terpisah.', 'Jangan mengubah perkalian menjadi klaim nilai masa depan.'),
          'outcome', 'Perhitungan menjelaskan pembayaran dalam contoh; bukan imbal hasil ETF di masa depan.'
        )
      )
    )),
    ('bonds-sbn-safe-investing-with-the-government-part-2', 'worked_example', 10, 'calculated', jsonb_build_object(
      'en', jsonb_build_object(
        'eyebrow', 'Coupon mechanics',
        'title', 'Keep the series and date beside the arithmetic',
        'disclosure', 'Illustrative gross coupon calculation — current series terms, tax, and schedule must be checked separately.',
        'altText', 'A worked example multiplying illustrative principal by an annual coupon, with a reminder to check the named series and date.',
        'payload', jsonb_build_object(
          'inputs', jsonb_build_array(jsonb_build_object('label', 'Illustrative principal', 'value', 'Rp 1,000,000'), jsonb_build_object('label', 'Illustrative annual coupon', 'value', '6%'), jsonb_build_object('label', 'Gross annual coupon', 'value', 'Rp 60,000')),
          'steps', jsonb_build_array('Rp 1,000,000 × 6% = Rp 60,000 gross per year.', 'Attach the named series, source date, tax treatment, and payment schedule.', 'Recheck the current official document before relying on a product detail.'),
          'outcome', 'A clean calculation can still describe only the example, not every SBN series or future result.'
        )
      ),
      'id', jsonb_build_object(
        'eyebrow', 'Mekanisme kupon',
        'title', 'Simpan seri dan tanggal di samping perhitungan',
        'disclosure', 'Perhitungan kupon kotor ilustratif — ketentuan seri, pajak, dan jadwal terbaru perlu diperiksa terpisah.',
        'altText', 'Contoh perkalian pokok ilustratif dengan kupon tahunan, dengan pengingat untuk memeriksa seri dan tanggal.',
        'payload', jsonb_build_object(
          'inputs', jsonb_build_array(jsonb_build_object('label', 'Pokok ilustratif', 'value', 'Rp 1.000.000'), jsonb_build_object('label', 'Kupon tahunan ilustratif', 'value', '6%'), jsonb_build_object('label', 'Kupon kotor tahunan', 'value', 'Rp 60.000')),
          'steps', jsonb_build_array('Rp 1.000.000 × 6% = Rp 60.000 kotor per tahun.', 'Sertakan seri, tanggal sumber, perlakuan pajak, dan jadwal pembayaran.', 'Periksa kembali dokumen resmi terbaru sebelum mengandalkan detail produk.'),
          'outcome', 'Perhitungan yang rapi tetap hanya menjelaskan contoh, bukan semua seri SBN atau hasil masa depan.'
        )
      )
    )),
    ('tax-basics-npwp-pph-21-and-filing-taxes-part-2', 'process', 10, 'illustrative', jsonb_build_object(
      'en', jsonb_build_object(
        'eyebrow', 'Filing workflow',
        'title', 'Turn a tax example into a checklist',
        'disclosure', 'Illustrative workflow — use the current DJP route and deadline for the relevant taxpayer and year.',
        'altText', 'A four-step workflow from records to the current form, submission, and saved confirmation.',
        'payload', jsonb_build_object('steps', jsonb_build_array(jsonb_build_object('title', '1. Gather', 'description', 'Collect income and withholding records.'), jsonb_build_object('title', '2. Identify', 'description', 'Find the current form and route.'), jsonb_build_object('title', '3. Check', 'description', 'Read the current instruction and deadline.'), jsonb_build_object('title', '4. Save', 'description', 'Submit and keep confirmation.')))
      ),
      'id', jsonb_build_object(
        'eyebrow', 'Alur pelaporan',
        'title', 'Ubah contoh pajak menjadi daftar periksa',
        'disclosure', 'Alur ilustratif — gunakan jalur dan tenggat DJP terbaru sesuai wajib pajak dan tahun terkait.',
        'altText', 'Alur empat langkah dari catatan menuju formulir terbaru, pelaporan, dan bukti tersimpan.',
        'payload', jsonb_build_object('steps', jsonb_build_array(jsonb_build_object('title', '1. Kumpulkan', 'description', 'Kumpulkan catatan penghasilan dan pemotongan.'), jsonb_build_object('title', '2. Identifikasi', 'description', 'Cari formulir dan jalur terbaru.'), jsonb_build_object('title', '3. Periksa', 'description', 'Baca petunjuk dan tenggat terbaru.'), jsonb_build_object('title', '4. Simpan', 'description', 'Kirim dan simpan bukti.')))
      )
    )),
    ('brokerage-account-setup-opening-your-rdn-part-2', 'process', 10, 'illustrative', jsonb_build_object(
      'en', jsonb_build_object(
        'eyebrow', 'Before a real transfer',
        'title', 'Pause, verify, then practise',
        'disclosure', 'Illustrative provider-neutral checklist — current provider instructions always take priority.',
        'altText', 'A five-step checklist from the official provider channel to simulated practice before a real transfer.',
        'payload', jsonb_build_object('steps', jsonb_build_array(jsonb_build_object('title', '1. Official channel', 'description', 'Open the provider route from a verified domain.'), jsonb_build_object('title', '2. Read', 'description', 'Review identity, risk, account, and fee documents.'), jsonb_build_object('title', '3. Confirm', 'description', 'Check the receiving account and current instructions.'), jsonb_build_object('title', '4. Save', 'description', 'Keep agreements and support routes.'), jsonb_build_object('title', '5. Practise', 'description', 'Use a simulated order before moving real funds.')))
      ),
      'id', jsonb_build_object(
        'eyebrow', 'Sebelum transfer sungguhan',
        'title', 'Berhenti, verifikasi, lalu berlatih',
        'disclosure', 'Daftar periksa netral penyedia secara ilustratif — petunjuk penyedia terbaru selalu diutamakan.',
        'altText', 'Daftar lima langkah dari kanal resmi penyedia sampai latihan simulasi sebelum transfer sungguhan.',
        'payload', jsonb_build_object('steps', jsonb_build_array(jsonb_build_object('title', '1. Kanal resmi', 'description', 'Buka jalur penyedia dari domain terverifikasi.'), jsonb_build_object('title', '2. Baca', 'description', 'Tinjau dokumen identitas, risiko, rekening, dan biaya.'), jsonb_build_object('title', '3. Pastikan', 'description', 'Periksa rekening tujuan dan petunjuk terbaru.'), jsonb_build_object('title', '4. Simpan', 'description', 'Simpan perjanjian dan jalur dukungan.'), jsonb_build_object('title', '5. Berlatih', 'description', 'Gunakan order simulasi sebelum memindahkan dana sungguhan.')))
      )
    ))
), inserted AS (
  INSERT INTO public.lesson_visual_blocks (lesson_id, placement, block_type, display_order, data_status, content, is_published)
  SELECT lesson.id, 'example', blocks.block_type, blocks.display_order, blocks.data_status, blocks.content, TRUE
  FROM blocks
  JOIN public.lessons AS lesson ON lesson.slug = blocks.slug
  ON CONFLICT (lesson_id, placement, display_order)
  DO UPDATE SET block_type = EXCLUDED.block_type, data_status = EXCLUDED.data_status, content = EXCLUDED.content, is_published = TRUE, updated_at = NOW()
  RETURNING id
)
SELECT count(*) AS inserted_example_visuals FROM inserted;

COMMIT;
