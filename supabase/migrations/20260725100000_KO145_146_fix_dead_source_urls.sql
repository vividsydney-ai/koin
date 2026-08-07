-- Migration: KO-145 + KO-146 — Replace unreachable BI/IDX source URLs with verified Wikipedia equivalents
-- BI (bi.go.id) URLs return connection failures; IDX (idx.co.id) URLs return 403 (bot-blocked).
-- Per product decision: dead Tier 1 source URLs replaced with topic-equivalent Wikipedia articles.
-- Original source_code and organization preserved; URL + trust_notes updated; status set to needs_review.

-- Bank Indonesia sources (all bi.go.id URLs unreachable)
UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Inflasi',
  trust_notes = 'Original BI page unreachable. Replaced with Indonesian Wikipedia article on inflation. Source content remains authoritative on the topic.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'BI-001';

UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Suku_bunga',
  trust_notes = 'Original BI page (tingkat suku bunga) unreachable. Replaced with Indonesian Wikipedia article on interest rates.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'BI-002';

UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Sistem_pembayaran',
  trust_notes = 'Original BI page (sistem pembayaran) unreachable. Replaced with Indonesian Wikipedia article on payment systems.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'BI-003';

UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Bank_Indonesia',
  trust_notes = 'Original BI publications page unreachable. Replaced with general Indonesian Wikipedia article on Bank Indonesia.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'BI-004';

UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Nilai_tukar',
  trust_notes = 'Original BI page (informasi kurs) unreachable. Replaced with Indonesian Wikipedia article on exchange rates.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'BI-005';

-- BI-006 (Instagram) is still reachable — no change needed

UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Bank_Indonesia',
  trust_notes = 'Duplicate of BI-004. Original BI publications page unreachable. Replaced with general Indonesian Wikipedia article on Bank Indonesia.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'BI-007';

UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Statistik',
  trust_notes = 'Original BI statistics page unreachable. Replaced with Indonesian Wikipedia article on statistics.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'BI-008';

UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Bank_Indonesia',
  trust_notes = 'Original BI publications page unreachable. Replaced with general Indonesian Wikipedia article on Bank Indonesia.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'BI-009';

-- IDX sources (idx.co.id returns 403 from automated access)
UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Investasi',
  trust_notes = 'Original IDX investor academy page blocked by site (403). Replaced with Indonesian Wikipedia article on investment.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'IDX-001';

UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Pasar_modal',
  trust_notes = 'Original IDX glossary page blocked by site (403). Replaced with Indonesian Wikipedia article on capital markets.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'IDX-002';

UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Saham',
  trust_notes = 'Original IDX trade summary page blocked by site (403). Replaced with Indonesian Wikipedia article on stocks.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'IDX-003';

-- IDX-004 (YouTube) is still reachable — no change needed

UPDATE sources SET
  url = 'https://id.wikipedia.org/wiki/Investasi',
  trust_notes = 'Original IDX investment guide page blocked by site (403). Replaced with Indonesian Wikipedia article on investment.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'IDX-005';

-- IDX-006 (App Store) is still reachable — no change needed

UPDATE sources SET
  url = 'https://en.wikipedia.org/wiki/Investor_protection',
  trust_notes = 'Original IDX investor protection page blocked by site (403). Replaced with English Wikipedia article on investor protection.',
  status = 'needs_review',
  last_checked_at = NOW()
WHERE source_code = 'IDX-007';

-- IDX-008 (YouTube playlists) is still reachable — no change needed
