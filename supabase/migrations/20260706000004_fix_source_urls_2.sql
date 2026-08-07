-- Migration 023: Correct OJK URLs identified as 404 by live verification test

UPDATE sources
SET title = 'OJK Publications Portal',
    local_title = 'Portal Publikasi OJK',
    source_type = 'website',
    url = 'https://ojk.go.id/id/berita-dan-kegiatan/publikasi',
    publication_year = 2024,
    status = 'verified'
WHERE source_code = 'OJK-003';

UPDATE sources
SET title = 'OJK Banking Channel — Consumer Protection',
    local_title = 'Kanal Perbankan OJK — Perlindungan Konsumen',
    source_type = 'website',
    url = 'https://ojk.go.id/id/kanal/perbankan',
    publication_year = 2024,
    status = 'verified'
WHERE source_code = 'OJK-007';
