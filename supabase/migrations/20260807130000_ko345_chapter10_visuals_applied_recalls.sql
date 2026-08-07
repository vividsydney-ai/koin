-- KO-345: Chapter 10 — Reading Trading Charts visual blocks, visual_applied
-- questions, and five-day recall prompts.
--
-- All chart data is illustrative teaching material. No real ticker, live price,
-- or guaranteed outcome is shown.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Bilingual visual blocks (one per lesson, concept placement)
-- ---------------------------------------------------------------------------
WITH blocks(slug, placement, block_type, display_order, data_status, content) AS (
  VALUES
    -- Lesson 1: OHLC basics
    ('chart-ohcl-basics', 'concept', 'annotated_data', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "Candle anatomy",
        "title": "One candle holds four prices",
        "disclosure": "Illustrative prices for learning only.",
        "altText": "A single practice candle showing open, high, low, and close prices.",
        "payload": {
          "quoteTitle": "One practice candle",
          "chart": {
            "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Practice"}],
            "accent": "core",
            "compact": false,
            "markers": [
              {"number": 1, "candleIndex": 0, "position": "high", "side": "left"},
              {"number": 2, "candleIndex": 0, "position": "low", "side": "right"},
              {"number": 3, "candleIndex": 0, "position": "bodyBottom", "side": "left"},
              {"number": 4, "candleIndex": 0, "position": "bodyTop", "side": "right"}
            ]
          },
          "annotations": [
            {"number": 1, "label": "High", "detail": "The highest price reached during this period."},
            {"number": 2, "label": "Low", "detail": "The lowest price reached during this period."},
            {"number": 3, "label": "Open", "detail": "The first traded price when the period started."},
            {"number": 4, "label": "Close", "detail": "The last traded price when the period ended."}
          ]
        }
      },
      "id": {
        "eyebrow": "Anatomi candle",
        "title": "Satu candle menyimpan empat harga",
        "disclosure": "Harga ilustratif untuk pembelajaran saja.",
        "altText": "Satu candle latihan yang menunjukkan harga open, high, low, dan close.",
        "payload": {
          "quoteTitle": "Satu candle latihan",
          "chart": {
            "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Latihan"}],
            "accent": "core",
            "compact": false,
            "markers": [
              {"number": 1, "candleIndex": 0, "position": "high", "side": "left"},
              {"number": 2, "candleIndex": 0, "position": "low", "side": "right"},
              {"number": 3, "candleIndex": 0, "position": "bodyBottom", "side": "left"},
              {"number": 4, "candleIndex": 0, "position": "bodyTop", "side": "right"}
            ]
          },
          "annotations": [
            {"number": 1, "label": "High", "detail": "Harga tertinggi yang tercapai dalam periode ini."},
            {"number": 2, "label": "Low", "detail": "Harga terendah yang tercapai dalam periode ini."},
            {"number": 3, "label": "Open", "detail": "Harga transaksi pertama saat periode dimulai."},
            {"number": 4, "label": "Close", "detail": "Harga transaksi terakhir saat periode berakhir."}
          ]
        }
      }
    }$block$::jsonb),

    -- Lesson 2: Body and wick
    ('chart-body-and-wick', 'concept', 'annotated_data', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "Reading the shape",
        "title": "Body shows the open-to-close range; wicks show rejection",
        "disclosure": "Illustrative prices for learning only.",
        "altText": "Two practice candles side by side, highlighting the body and the upper and lower wicks.",
        "payload": {
          "quoteTitle": "Body and wicks",
          "chart": {
            "candles": [
              {"open": 100, "high": 120, "low": 92, "close": 114, "label": "Up"},
              {"open": 114, "high": 120, "low": 92, "close": 100, "label": "Down"}
            ],
            "accent": "core",
            "compact": false,
            "markers": [
              {"number": 1, "candleIndex": 0, "position": "bodyCenter", "side": "left"},
              {"number": 2, "candleIndex": 0, "position": "high", "side": "right"},
              {"number": 3, "candleIndex": 0, "position": "low", "side": "left"}
            ]
          },
          "annotations": [
            {"number": 1, "label": "Body", "detail": "The range between the open and close prices."},
            {"number": 2, "label": "Upper wick", "detail": "Price moved higher but was rejected before the close."},
            {"number": 3, "label": "Lower wick", "detail": "Price moved lower but was rejected before the close."}
          ]
        }
      },
      "id": {
        "eyebrow": "Membaca bentuk",
        "title": "Body menunjukkan rentang open-ke-close; wick menunjukkan penolakan",
        "disclosure": "Harga ilustratif untuk pembelajaran saja.",
        "altText": "Dua candle latihan berdampingan yang menyoroti body serta wick atas dan bawah.",
        "payload": {
          "quoteTitle": "Body dan wick",
          "chart": {
            "candles": [
              {"open": 100, "high": 120, "low": 92, "close": 114, "label": "Naik"},
              {"open": 114, "high": 120, "low": 92, "close": 100, "label": "Turun"}
            ],
            "accent": "core",
            "compact": false,
            "markers": [
              {"number": 1, "candleIndex": 0, "position": "bodyCenter", "side": "left"},
              {"number": 2, "candleIndex": 0, "position": "high", "side": "right"},
              {"number": 3, "candleIndex": 0, "position": "low", "side": "left"}
            ]
          },
          "annotations": [
            {"number": 1, "label": "Body", "detail": "Rentang antara harga open dan close."},
            {"number": 2, "label": "Wick atas", "detail": "Harga sempat naik lebih tinggi tetapi ditolak sebelum close."},
            {"number": 3, "label": "Wick bawah", "detail": "Harga sempat turun lebih rendah tetapi ditolak sebelum close."}
          ]
        }
      }
    }$block$::jsonb),

    -- Lesson 3: Bullish, bearish, doji
    ('chart-bullish-bearish-doji', 'concept', 'comparison', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "Direction and indecision",
        "title": "Bullish, bearish, and doji candles",
        "disclosure": "Illustrative prices for learning only.",
        "altText": "Three practice candles showing bullish, bearish, and doji shapes.",
        "payload": {
          "leftTitle": "Bullish",
          "rightTitle": "Bearish",
          "items": [
            {
              "title": "Bullish",
              "subtitle": "Closes above its open",
              "chart": {"candles": [{"open": 100, "high": 114, "low": 97, "close": 110}], "accent": "core", "compact": true},
              "footnote": "Buyers had more control by the close."
            },
            {
              "title": "Bearish",
              "subtitle": "Closes below its open",
              "chart": {"candles": [{"open": 110, "high": 114, "low": 97, "close": 100}], "accent": "core", "compact": true},
              "footnote": "Sellers had more control by the close."
            },
            {
              "title": "Doji",
              "subtitle": "Open and close are near each other",
              "chart": {"candles": [{"open": 104, "high": 112, "low": 96, "close": 104}], "accent": "core", "compact": true},
              "footnote": "Shows indecision, not that nothing happened."
            }
          ]
        }
      },
      "id": {
        "eyebrow": "Arah dan ketidakpastian",
        "title": "Candle bullish, bearish, dan doji",
        "disclosure": "Harga ilustratif untuk pembelajaran saja.",
        "altText": "Tiga candle latihan yang menunjukkan bentuk bullish, bearish, dan doji.",
        "payload": {
          "leftTitle": "Bullish",
          "rightTitle": "Bearish",
          "items": [
            {
              "title": "Bullish",
              "subtitle": "Ditutup di atas open",
              "chart": {"candles": [{"open": 100, "high": 114, "low": 97, "close": 110}], "accent": "core", "compact": true},
              "footnote": "Pembeli memiliki kendali lebih saat close."
            },
            {
              "title": "Bearish",
              "subtitle": "Ditutup di bawah open",
              "chart": {"candles": [{"open": 110, "high": 114, "low": 97, "close": 100}], "accent": "core", "compact": true},
              "footnote": "Penjual memiliki kendali lebih saat close."
            },
            {
              "title": "Doji",
              "subtitle": "Open dan close berada dekat",
              "chart": {"candles": [{"open": 104, "high": 112, "low": 96, "close": 104}], "accent": "core", "compact": true},
              "footnote": "Menunjukkan ketidakpastian, bukan tidak terjadi apa-apa."
            }
          ]
        }
      }
    }$block$::jsonb),

    -- Lesson 4: Long wicks and rejection
    ('chart-long-wick-rejection', 'concept', 'process', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "What a long wick means",
        "title": "Price pushed, then was rejected",
        "disclosure": "Illustrative prices for learning only.",
        "altText": "A three-candle sequence showing price pushing up, hitting resistance, forming a long upper wick, and closing back down.",
        "payload": {
          "steps": [
            {"title": "Price pushes up", "description": "Buyers drive the price higher during the period."},
            {"title": "It reaches a level", "description": "The price hits an area where sellers respond."},
            {"title": "A long wick forms", "description": "The high is reached, but price cannot hold there."},
            {"title": "Price closes back down", "description": "Selling pressure returns price closer to where it opened."}
          ],
          "chart": {
            "candles": [
              {"open": 102, "high": 129, "low": 99, "close": 125, "label": "Push"},
              {"open": 125, "high": 129, "low": 105, "close": 108, "label": "Rejection"},
              {"open": 108, "high": 115, "low": 100, "close": 103, "label": "Close down"}
            ],
            "accent": "core",
            "compact": false
          }
        }
      },
      "id": {
        "eyebrow": "Apa artinya wick panjang",
        "title": "Harga mendorong, lalu ditolak",
        "disclosure": "Harga ilustratif untuk pembelajaran saja.",
        "altText": "Rangkaian tiga candle yang menunjukkan harga mendorong naik, menemui resistance, membentuk wick atas panjang, dan ditutup turun kembali.",
        "payload": {
          "steps": [
            {"title": "Harga mendorong naik", "description": "Pembeli mendorong harga lebih tinggi selama periode."},
            {"title": "Mencapai sebuah level", "description": "Harga menemui area di mana penjual merespons."},
            {"title": "Wick panjang terbentuk", "description": "High tercapai, tetapi harga tidak bisa bertahan di sana."},
            {"title": "Harga ditutup turun kembali", "description": "Tekanan jual mengembalikan harga mendekati open."}
          ],
          "chart": {
            "candles": [
              {"open": 102, "high": 129, "low": 99, "close": 125, "label": "Dorong"},
              {"open": 125, "high": 129, "low": 105, "close": 108, "label": "Penolakan"},
              {"open": 108, "high": 115, "low": 100, "close": 103, "label": "Tutup turun"}
            ],
            "accent": "core",
            "compact": false
          }
        }
      }
    }$block$::jsonb),

    -- Lesson 5: Hammer, inverted hammer, shooting star
    ('chart-hammer-shooting-star', 'concept', 'comparison', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "Pattern vocabulary",
        "title": "Small body, long wick, and surrounding context",
        "disclosure": "Illustrative prices for learning only.",
        "altText": "Three labelled candle silhouettes showing a hammer, an inverted hammer, and a shooting star.",
        "payload": {
          "leftTitle": "Hammer",
          "rightTitle": "Shooting star",
          "items": [
            {
              "title": "Hammer",
              "subtitle": "Small body at the top, long lower wick",
              "chart": {"candles": [{"open": 105, "high": 111, "low": 82, "close": 109}], "accent": "core", "compact": true},
              "footnote": "Often studied after a decline; still needs confirmation."
            },
            {
              "title": "Inverted hammer",
              "subtitle": "Small body at the bottom, long upper wick",
              "chart": {"candles": [{"open": 95, "high": 118, "low": 92, "close": 97}], "accent": "core", "compact": true},
              "footnote": "Shape alone is not a buy signal."
            },
            {
              "title": "Shooting star",
              "subtitle": "Small body at the bottom, long upper wick after a rise",
              "chart": {"candles": [{"open": 125, "high": 148, "low": 122, "close": 127}], "accent": "core", "compact": true},
              "footnote": "Context and next candles matter."
            }
          ]
        }
      },
      "id": {
        "eyebrow": "Kosa kata pola",
        "title": "Body kecil, wick panjang, dan konteks sekitarnya",
        "disclosure": "Harga ilustratif untuk pembelajaran saja.",
        "altText": "Tiga siluet candle berlabel yang menunjukkan hammer, inverted hammer, dan shooting star.",
        "payload": {
          "leftTitle": "Hammer",
          "rightTitle": "Shooting star",
          "items": [
            {
              "title": "Hammer",
              "subtitle": "Body kecil di atas, wick bawah panjang",
              "chart": {"candles": [{"open": 105, "high": 111, "low": 82, "close": 109}], "accent": "core", "compact": true},
              "footnote": "Sering dipelajari setelah penurunan; tetap butuh konfirmasi."
            },
            {
              "title": "Inverted hammer",
              "subtitle": "Body kecil di bawah, wick atas panjang",
              "chart": {"candles": [{"open": 95, "high": 118, "low": 92, "close": 97}], "accent": "core", "compact": true},
              "footnote": "Bentuk saja bukan sinyal beli."
            },
            {
              "title": "Shooting star",
              "subtitle": "Body kecil di bawah, wick atas panjang setelah kenaikan",
              "chart": {"candles": [{"open": 125, "high": 148, "low": 122, "close": 127}], "accent": "core", "compact": true},
              "footnote": "Konteks dan candle berikutnya penting."
            }
          ]
        }
      }
    }$block$::jsonb),

    -- Lesson 6: Support and resistance
    ('chart-support-resistance', 'concept', 'annotated_data', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "Zones, not lines",
        "title": "Support and resistance are reaction areas",
        "disclosure": "Illustrative prices for learning only.",
        "altText": "A mini line chart showing price bouncing in a support zone below and reversing in a resistance zone above.",
        "payload": {
          "quoteTitle": "Repeated touches create zones",
          "chart": {
            "candles": [
              {"open": 102, "high": 110, "low": 96, "close": 108, "label": "1"},
              {"open": 108, "high": 114, "low": 101, "close": 104, "label": "2"},
              {"open": 104, "high": 111, "low": 100, "close": 109, "label": "3"},
              {"open": 109, "high": 118, "low": 108, "close": 113, "label": "4"},
              {"open": 113, "high": 119, "low": 110, "close": 111, "label": "5"}
            ],
            "accent": "core",
            "compact": false,
            "markers": [
              {"number": 1, "candleIndex": 0, "position": "low", "side": "left"},
              {"number": 2, "candleIndex": 3, "position": "high", "side": "right"}
            ]
          },
          "annotations": [
            {"number": 1, "label": "Support zone", "detail": "An area where price has repeatedly paused or bounced."},
            {"number": 2, "label": "Resistance zone", "detail": "An area where price has repeatedly reversed."}
          ]
        }
      },
      "id": {
        "eyebrow": "Zona, bukan garis",
        "title": "Support dan resistance adalah area reaksi",
        "disclosure": "Harga ilustratif untuk pembelajaran saja.",
        "altText": "Grafik mini yang menunjukkan harga memantul di zona support di bawah dan berbalik di zona resistance di atas.",
        "payload": {
          "quoteTitle": "Sentuhan berulang membentuk zona",
          "chart": {
            "candles": [
              {"open": 102, "high": 110, "low": 96, "close": 108, "label": "1"},
              {"open": 108, "high": 114, "low": 101, "close": 104, "label": "2"},
              {"open": 104, "high": 111, "low": 100, "close": 109, "label": "3"},
              {"open": 109, "high": 118, "low": 108, "close": 113, "label": "4"},
              {"open": 113, "high": 119, "low": 110, "close": 111, "label": "5"}
            ],
            "accent": "core",
            "compact": false,
            "markers": [
              {"number": 1, "candleIndex": 0, "position": "low", "side": "left"},
              {"number": 2, "candleIndex": 3, "position": "high", "side": "right"}
            ]
          },
          "annotations": [
            {"number": 1, "label": "Zona support", "detail": "Area tempat harga berulang kali berhenti atau memantul."},
            {"number": 2, "label": "Zona resistance", "detail": "Area tempat harga berulang kali berbalik."}
          ]
        }
      }
    }$block$::jsonb),

    -- Lesson 7: Trend and timeframe
    ('chart-trend-and-timeframe', 'concept', 'comparison', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "Timeframe changes the story",
        "title": "A trend only exists within a chosen timeframe",
        "disclosure": "Illustrative prices for learning only.",
        "altText": "The same price history drawn as a smooth daily uptrend and as a noisy hourly chart.",
        "payload": {
          "leftTitle": "Daily",
          "rightTitle": "Hourly",
          "items": [
            {
              "title": "Daily timeframe",
              "subtitle": "Smoother trend is easier to see",
              "chart": {
                "candles": [
                  {"open": 100, "high": 108, "low": 98, "close": 106},
                  {"open": 106, "high": 115, "low": 104, "close": 113},
                  {"open": 113, "high": 122, "low": 111, "close": 119}
                ],
                "accent": "core",
                "compact": true
              },
              "footnote": "Each candle summarises one full day."
            },
            {
              "title": "Hourly timeframe",
              "subtitle": "Same period looks noisier",
              "chart": {
                "candles": [
                  {"open": 100, "high": 108, "low": 96, "close": 102},
                  {"open": 102, "high": 110, "low": 98, "close": 105},
                  {"open": 105, "high": 112, "low": 101, "close": 103},
                  {"open": 103, "high": 111, "low": 100, "close": 108},
                  {"open": 108, "high": 116, "low": 104, "close": 113},
                  {"open": 113, "high": 122, "low": 109, "close": 119}
                ],
                "accent": "core",
                "compact": true
              },
              "footnote": "Each candle summarises one hour."
            }
          ]
        }
      },
      "id": {
        "eyebrow": "Timeframe mengubah cerita",
        "title": "Tren hanya ada dalam timeframe yang dipilih",
        "disclosure": "Harga ilustratif untuk pembelajaran saja.",
        "altText": "Riwayat harga yang sama digambar sebagai tren naik harian yang halus dan grafik per jam yang lebih berisik.",
        "payload": {
          "leftTitle": "Harian",
          "rightTitle": "Per jam",
          "items": [
            {
              "title": "Timeframe harian",
              "subtitle": "Tren yang lebih halus lebih mudah dilihat",
              "chart": {
                "candles": [
                  {"open": 100, "high": 108, "low": 98, "close": 106},
                  {"open": 106, "high": 115, "low": 104, "close": 113},
                  {"open": 113, "high": 122, "low": 111, "close": 119}
                ],
                "accent": "core",
                "compact": true
              },
              "footnote": "Setiap candle merangkum satu hari penuh."
            },
            {
              "title": "Timeframe per jam",
              "subtitle": "Periode yang sama terlihat lebih berisik",
              "chart": {
                "candles": [
                  {"open": 100, "high": 108, "low": 96, "close": 102},
                  {"open": 102, "high": 110, "low": 98, "close": 105},
                  {"open": 105, "high": 112, "low": 101, "close": 103},
                  {"open": 103, "high": 111, "low": 100, "close": 108},
                  {"open": 108, "high": 116, "low": 104, "close": 113},
                  {"open": 113, "high": 122, "low": 109, "close": 119}
                ],
                "accent": "core",
                "compact": true
              },
              "footnote": "Setiap candle merangkum satu jam."
            }
          ]
        }
      }
    }$block$::jsonb),

    -- Lesson 8: What a chart cannot tell you
    ('chart-reading-limits', 'concept', 'comparison', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "Know the limits",
        "title": "What a chart can and cannot show",
        "disclosure": "Illustrative learning comparison.",
        "altText": "Two-column comparison of what price charts show and what they cannot show.",
        "payload": {
          "leftTitle": "What a chart shows",
          "rightTitle": "What a chart cannot show",
          "rows": [
            {"left": "Past open, high, low, and close prices.", "right": "A guaranteed future price."},
            {"left": "Where price has repeatedly reacted.", "right": "Whether a company is well managed."},
            {"left": "How volatile a period was.", "right": "Whether an investment fits your personal situation."},
            {"left": "Patterns that help describe past behaviour.", "right": "A risk-free decision."}
          ]
        }
      },
      "id": {
        "eyebrow": "Ketahui batasannya",
        "title": "Apa yang bisa dan tidak bisa ditunjukkan grafik",
        "disclosure": "Perbandingan pembelajaran ilustratif.",
        "altText": "Perbandingan dua kolom tentang apa yang ditunjukkan grafik harga dan apa yang tidak bisa ditunjukkannya.",
        "payload": {
          "leftTitle": "Apa yang ditunjukkan grafik",
          "rightTitle": "Apa yang tidak bisa ditunjukkan grafik",
          "rows": [
            {"left": "Harga open, high, low, dan close masa lalu.", "right": "Harga masa depan yang dijamin."},
            {"left": "Di mana harga berulang kali bereaksi.", "right": "Apakah perusahaan dikelola dengan baik."},
            {"left": "Seberapa volatil sebuah periode.", "right": "Apakah investasi cocok untuk situasi pribadimu."},
            {"left": "Pola yang membantu menggambarkan perilaku masa lalu.", "right": "Keputusan bebas risiko."}
          ]
        }
      }
    }$block$::jsonb)
)
INSERT INTO public.lesson_visual_blocks (lesson_id, placement, block_type, display_order, data_status, content, is_published)
SELECT lesson.id, blocks.placement, blocks.block_type, blocks.display_order,
       blocks.data_status, blocks.content, TRUE
FROM blocks
JOIN public.lessons AS lesson ON lesson.slug = blocks.slug
WHERE lesson.is_published = TRUE
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = TRUE,
  updated_at = NOW();


-- ---------------------------------------------------------------------------
-- 2. Visual block source junctions (OJK-CHART-001 for all illustrative blocks)
-- ---------------------------------------------------------------------------
WITH block_sources(slug, display_order, source_code, citation_label) AS (
  VALUES
    ('chart-ohcl-basics', 10, 'OJK-CHART-001', 'OJK: capital-market literacy'),
    ('chart-body-and-wick', 10, 'OJK-CHART-001', 'OJK: capital-market literacy'),
    ('chart-bullish-bearish-doji', 10, 'OJK-CHART-001', 'OJK: capital-market literacy'),
    ('chart-long-wick-rejection', 10, 'OJK-CHART-001', 'OJK: capital-market literacy'),
    ('chart-hammer-shooting-star', 10, 'OJK-CHART-001', 'OJK: capital-market literacy'),
    ('chart-support-resistance', 10, 'OJK-CHART-001', 'OJK: capital-market literacy'),
    ('chart-trend-and-timeframe', 10, 'OJK-CHART-001', 'OJK: capital-market literacy'),
    ('chart-reading-limits', 10, 'OJK-CHART-001', 'OJK: capital-market literacy')
)
INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, block_sources.citation_label
FROM block_sources
JOIN public.lessons AS lesson ON lesson.slug = block_sources.slug
JOIN public.lesson_visual_blocks AS block
  ON block.lesson_id = lesson.id AND block.display_order = block_sources.display_order
JOIN public.sources AS source ON source.source_code = block_sources.source_code
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET
  citation_label = EXCLUDED.citation_label;

-- ---------------------------------------------------------------------------
-- 3. Applied questions (visual_applied), three bilingual variants per lesson
-- ---------------------------------------------------------------------------
WITH applied_questions(slug, body, body_id) AS (
  VALUES
    -- Lesson 1: OHLC basics
    ('chart-ohcl-basics', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Looking at the practice candle, what was the highest price reached?",
      "options": ["116", "109", "100", "94"],
      "answer": "116",
      "explanation": "The high is the top of the upper wick. On this candle the high is 116.",
      "chart": {
        "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Practice"}],
        "markers": [{"number": 1, "candleIndex": 0, "position": "high", "side": "left"}]
      }
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Melihat candle latihan, berapa harga tertinggi yang tercapai?",
      "options": ["116", "109", "100", "94"],
      "answer": "116",
      "explanation": "High adalah puncak wick atas. Pada candle ini high-nya 116.",
      "chart": {
        "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Latihan"}],
        "markers": [{"number": 1, "candleIndex": 0, "position": "high", "side": "left"}]
      }
    }$block$::jsonb),
    ('chart-ohcl-basics', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Which price tells you where the period ended?",
      "options": ["Close", "Open", "High", "Low"],
      "answer": "Close",
      "explanation": "The close is the last traded price of the period.",
      "chart": {
        "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Practice"}],
        "markers": [{"number": 1, "candleIndex": 0, "position": "close", "side": "right"}]
      }
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Harga mana yang menunjukkan di mana periode berakhir?",
      "options": ["Close", "Open", "High", "Low"],
      "answer": "Close",
      "explanation": "Close adalah harga transaksi terakhir dalam periode.",
      "chart": {
        "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Latihan"}],
        "markers": [{"number": 1, "candleIndex": 0, "position": "close", "side": "right"}]
      }
    }$block$::jsonb),
    ('chart-ohcl-basics', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "The distance from 94 to 116 on the candle represents what?",
      "options": ["The full trading range", "Only the body", "The opening price", "The guaranteed future range"],
      "answer": "The full trading range",
      "explanation": "The range from low (94) to high (116) shows every price touched during the period.",
      "chart": {
        "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Practice"}],
        "markers": [
          {"number": 1, "candleIndex": 0, "position": "low", "side": "left"},
          {"number": 2, "candleIndex": 0, "position": "high", "side": "right"}
        ]
      }
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Jarak dari 94 ke 116 pada candle mewakili apa?",
      "options": ["Rentang perdagangan penuh", "Hanya body", "Harga pembukaan", "Rentang masa depan yang dijamin"],
      "answer": "Rentang perdagangan penuh",
      "explanation": "Rentang dari low (94) ke high (116) menunjukkan setiap harga yang tersentuh selama periode.",
      "chart": {
        "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Latihan"}],
        "markers": [
          {"number": 1, "candleIndex": 0, "position": "low", "side": "left"},
          {"number": 2, "candleIndex": 0, "position": "high", "side": "right"}
        ]
      }
    }$block$::jsonb),

    -- Lesson 2: Body and wick
    ('chart-body-and-wick', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "In the Up candle, the body runs from which prices?",
      "options": ["100 to 114", "92 to 120", "102 to 110", "94 to 116"],
      "answer": "100 to 114",
      "explanation": "The body is the range between open (100) and close (114).",
      "chart": {
        "candles": [{"open": 100, "high": 120, "low": 92, "close": 114, "label": "Up"}],
        "markers": [
          {"number": 1, "candleIndex": 0, "position": "bodyBottom", "side": "left"},
          {"number": 2, "candleIndex": 0, "position": "bodyTop", "side": "right"}
        ]
      }
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Pada candle Naik, body berada di rentang harga mana?",
      "options": ["100 sampai 114", "92 sampai 120", "102 sampai 110", "94 sampai 116"],
      "answer": "100 sampai 114",
      "explanation": "Body adalah rentang antara open (100) dan close (114).",
      "chart": {
        "candles": [{"open": 100, "high": 120, "low": 92, "close": 114, "label": "Naik"}],
        "markers": [
          {"number": 1, "candleIndex": 0, "position": "bodyBottom", "side": "left"},
          {"number": 2, "candleIndex": 0, "position": "bodyTop", "side": "right"}
        ]
      }
    }$block$::jsonb),
    ('chart-body-and-wick', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "What does the upper wick show?",
      "options": ["Price was rejected from that high", "The close price", "The only traded price", "A guaranteed reversal"],
      "answer": "Price was rejected from that high",
      "explanation": "The wick above the body marks prices reached but not held before the close.",
      "chart": {
        "candles": [{"open": 100, "high": 120, "low": 92, "close": 114, "label": "Up"}],
        "markers": [{"number": 1, "candleIndex": 0, "position": "high", "side": "left"}]
      }
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Apa yang ditunjukkan oleh wick atas?",
      "options": ["Harga ditolak dari high tersebut", "Harga close", "Satu-satunya harga yang diperdagangkan", "Pembalikan yang dijamin"],
      "answer": "Harga ditolak dari high tersebut",
      "explanation": "Wick di atas body menandai harga yang tersentuh tetapi tidak bertahan sebelum close.",
      "chart": {
        "candles": [{"open": 100, "high": 120, "low": 92, "close": 114, "label": "Naik"}],
        "markers": [{"number": 1, "candleIndex": 0, "position": "high", "side": "left"}]
      }
    }$block$::jsonb),
    ('chart-body-and-wick', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "A long lower wick with a small body suggests what?",
      "options": ["Price dipped but recovered before close", "Buyers always win", "The trend is guaranteed", "The open and close are identical"],
      "answer": "Price dipped but recovered before close",
      "explanation": "A long lower wick means sellers pushed price down, but buyers lifted it back before the close."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Wick bawah panjang dengan body kecil mengindikasikan apa?",
      "options": ["Harga sempat turun tetapi pulih sebelum close", "Pembeli selalu menang", "Tren dijamin", "Open dan close identik"],
      "answer": "Harga sempat turun tetapi pulih sebelum close",
      "explanation": "Wick bawah panjang berarti penjual mendorong harga turun, tetapi pembeli mengangkatnya kembali sebelum close."
    }$block$::jsonb),

    -- Lesson 3: Bullish, bearish, doji
    ('chart-bullish-bearish-doji', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Which candle closes above its open?",
      "options": ["Bullish", "Bearish", "Doji", "None"],
      "answer": "Bullish",
      "explanation": "A bullish candle has a close above its open."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Candle mana yang ditutup di atas open-nya?",
      "options": ["Bullish", "Bearish", "Doji", "Tidak ada"],
      "answer": "Bullish",
      "explanation": "Candle bullish ditutup di atas open-nya."
    }$block$::jsonb),
    ('chart-bullish-bearish-doji', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "What does a doji mainly show?",
      "options": ["Indecision", "A guaranteed reversal", "Strong buying", "Strong selling"],
      "answer": "Indecision",
      "explanation": "A doji forms when open and close are near each other, showing neither buyers nor sellers won clearly."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Apa yang utama ditunjukkan oleh doji?",
      "options": ["Ketidakpastian", "Pembalikan yang dijamin", "Pembelian kuat", "Penjualan kuat"],
      "answer": "Ketidakpastian",
      "explanation": "Doji terbentuk saat open dan close berada dekat, menunjukkan baik pembeli maupun penjual tidak menang secara jelas."
    }$block$::jsonb),
    ('chart-bullish-bearish-doji', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Why should you not rely only on the bullish or bearish colour?",
      "options": ["Context matters and colour alone does not predict", "Colour always predicts the next move", "Doji candles are always bullish", "Bearish candles never reverse"],
      "answer": "Context matters and colour alone does not predict",
      "explanation": "A single candle's colour is one clue; the surrounding trend and confirmation still matter."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Mengapa tidak boleh mengandalkan warna bullish atau bearish saja?",
      "options": ["Konteks penting dan warna saja tidak memprediksi", "Warna selalu memprediksi langkah berikutnya", "Candle doji selalu bullish", "Candle bearish tidak pernah berbalik"],
      "answer": "Konteks penting dan warna saja tidak memprediksi",
      "explanation": "Warna satu candle adalah satu petunjuk; tren sekitar dan konfirmasi tetap penting."
    }$block$::jsonb),

    -- Lesson 4: Long wick rejection
    ('chart-long-wick-rejection', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "In the sequence, what created the long upper wick?",
      "options": ["Price hit a level and was pushed back", "Buyers stayed in control", "The close was above the high", "No sellers entered"],
      "answer": "Price hit a level and was pushed back",
      "explanation": "The long upper wick forms when price rises but selling pressure pushes it back down before the close."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Dalam rangkaian, apa yang menciptakan wick atas panjang?",
      "options": ["Harga menemui level dan ditolak kembali", "Pembeli tetap menguasai", "Close di atas high", "Tidak ada penjual yang masuk"],
      "answer": "Harga menemui level dan ditolak kembali",
      "explanation": "Wick atas panjang terbentuk saat harga naik tetapi tekanan jual mendorongnya turun sebelum close."
    }$block$::jsonb),
    ('chart-long-wick-rejection', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "A long upper wick after a rise is best read as what?",
      "options": ["A clue to study context", "A command to sell immediately", "Proof price will keep rising", "A guarantee of reversal"],
      "answer": "A clue to study context",
      "explanation": "A long wick is evidence of rejection, not a standalone buy or sell signal."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Wick atas panjang setelah kenaikan paling baik dibaca sebagai apa?",
      "options": ["Petunjuk untuk mempelajari konteks", "Perintah untuk segera menjual", "Bukti harga akan terus naik", "Jaminan pembalikan"],
      "answer": "Petunjuk untuk mempelajari konteks",
      "explanation": "Wick panjang adalah bukti penolakan, bukan sinyal beli atau jual yang berdiri sendiri."
    }$block$::jsonb),
    ('chart-long-wick-rejection', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "What happened after the long wick formed?",
      "options": ["Price closed back down", "Price closed at the high", "The period had no sellers", "The wick became the body"],
      "answer": "Price closed back down",
      "explanation": "After the rejection, selling pressure returned price closer to where it started."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Apa yang terjadi setelah wick panjang terbentuk?",
      "options": ["Harga ditutup turun kembali", "Harga ditutup di high", "Periode tidak memiliki penjual", "Wick menjadi body"],
      "answer": "Harga ditutup turun kembali",
      "explanation": "Setelah penolakan, tekanan jual mengembalikan harga mendekati harga awal."
    }$block$::jsonb),

    -- Lesson 5: Hammer, inverted hammer, shooting star
    ('chart-hammer-shooting-star', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "A hammer has a small body and a long wick in which direction?",
      "options": ["Lower", "Upper", "Both", "Neither"],
      "answer": "Lower",
      "explanation": "A hammer has a small body near the top of the period and a long lower wick."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Hammer memiliki body kecil dan wick panjang ke arah mana?",
      "options": ["Bawah", "Atas", "Keduanya", "Tidak ada"],
      "answer": "Bawah",
      "explanation": "Hammer memiliki body kecil di dekat atas periode dan wick bawah panjang."
    }$block$::jsonb),
    ('chart-hammer-shooting-star', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Which statement about these patterns is correct?",
      "options": ["Their meaning depends on trend and confirmation", "They predict the next move alone", "A hammer always means buy", "A shooting star always means sell"],
      "answer": "Their meaning depends on trend and confirmation",
      "explanation": "These shapes are vocabulary, not standalone predictions."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Pernyataan mana tentang pola-pola ini yang benar?",
      "options": ["Maknanya bergantung pada tren dan konfirmasi", "Mereka memprediksi langkah berikutnya sendirian", "Hammer selalu berarti beli", "Shooting star selalu berarti jual"],
      "answer": "Maknanya bergantung pada tren dan konfirmasi",
      "explanation": "Bentuk-bentuk ini adalah kosa kata, bukan prediksi yang berdiri sendiri."
    }$block$::jsonb),
    ('chart-hammer-shooting-star', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "An inverted hammer has a long upper wick and a small body near which end?",
      "options": ["The low", "The high", "The middle", "The open"],
      "answer": "The low",
      "explanation": "An inverted hammer has a small body near the low of the period with a long upper wick."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Inverted hammer memiliki wick atas panjang dan body kecil di dekat ujung mana?",
      "options": ["Low", "High", "Tengah", "Open"],
      "answer": "Low",
      "explanation": "Inverted hammer memiliki body kecil di dekat low periode dengan wick atas panjang."
    }$block$::jsonb),

    -- Lesson 6: Support and resistance
    ('chart-support-resistance', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Why is support described as a zone rather than a single price?",
      "options": ["Because price reacts near a range multiple times", "Because one touch is enough", "Because it guarantees a bounce", "Because it is an exact number"],
      "answer": "Because price reacts near a range multiple times",
      "explanation": "Support is an area where price has repeatedly paused or bounced, not a single exact price."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Mengapa support dijelaskan sebagai zona bukan harga tunggal?",
      "options": ["Karena harga bereaksi di dekat rentang beberapa kali", "Karena satu sentuhan sudah cukup", "Karena dijamin memantul", "Karena angka yang tepat"],
      "answer": "Karena harga bereaksi di dekat rentang beberapa kali",
      "explanation": "Support adalah area tempat harga berulang kali berhenti atau memantul, bukan harga tepat tunggal."
    }$block$::jsonb),
    ('chart-support-resistance', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "In the chart, resistance is where price has repeatedly done what?",
      "options": ["Reversed lower", "Bounced higher", "Stayed flat", "Ignored sellers"],
      "answer": "Reversed lower",
      "explanation": "Resistance is an area where rising prices have repeatedly reversed back down."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Pada grafik, resistance adalah area di mana harga berulang kali melakukan apa?",
      "options": ["Berbalik turun", "Memantul naik", "Tetap datar", "Mengabaikan penjual"],
      "answer": "Berbalik turun",
      "explanation": "Resistance adalah area di mana harga naik berulang kali berbalik turun."
    }$block$::jsonb),
    ('chart-support-resistance', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "If price briefly moves below a support zone then returns, what does that suggest?",
      "options": ["Support is an area, not an exact floor", "The zone is no longer relevant", "Price will definitely fall", "Support always holds exactly"],
      "answer": "Support is an area, not an exact floor",
      "explanation": "Small breaches can happen within a support zone; the broader area still matters."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Jika harga sebentar bergerak di bawah zona support lalu kembali, apa yang disarankan?",
      "options": ["Support adalah area, bukan lantai tepat", "Zona tidak lagi relevan", "Harga pasti akan jatuh", "Support selalu bertahan tepat"],
      "answer": "Support adalah area, bukan lantai tepat",
      "explanation": "Pelanggaran kecil bisa terjadi dalam zona support; area yang lebih luas tetap penting."
    }$block$::jsonb),

    -- Lesson 7: Trend and timeframe
    ('chart-trend-and-timeframe', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "The daily chart shows a smoother trend because each candle covers what?",
      "options": ["One full day", "One hour", "One trade", "One week"],
      "answer": "One full day",
      "explanation": "A daily candle compresses a full day's trading into one bar, smoothing out intraday noise."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Grafik harian menunjukkan tren yang lebih halus karena setiap candle mencakup apa?",
      "options": ["Satu hari penuh", "Satu jam", "Satu transaksi", "Satu minggu"],
      "answer": "Satu hari penuh",
      "explanation": "Candle harian memampatkan perdagangan satu hari penuh ke dalam satu bar, sehingga menghaluskan noise intraday."
    }$block$::jsonb),
    ('chart-trend-and-timeframe', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Why does the hourly chart look noisier for the same period?",
      "options": ["Each candle covers less time and shows more detail", "Hourly data is always wrong", "Daily candles hide all price movement", "The trend changed on the hourly chart"],
      "answer": "Each candle covers less time and shows more detail",
      "explanation": "Shorter timeframes reveal more detail, which can look more volatile than the same period on a daily chart."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Mengapa grafik per jam terlihat lebih berisik untuk periode yang sama?",
      "options": ["Setiap candle mencakup waktu lebih sedikit dan menunjukkan lebih banyak detail", "Data per jam selalu salah", "Candle harian menyembunyikan semua pergerakan harga", "Tren berubah di grafik per jam"],
      "answer": "Setiap candle mencakup waktu lebih sedikit dan menunjukkan lebih banyak detail",
      "explanation": "Timeframe lebih pendek menunjukkan lebih banyak detail, yang bisa terlihat lebih volatil daripada periode yang sama di grafik harian."
    }$block$::jsonb),
    ('chart-trend-and-timeframe', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "A pattern should always be read with what information?",
      "options": ["Its timeframe stated", "Only its colour", "Only its wick length", "No context needed"],
      "answer": "Its timeframe stated",
      "explanation": "A pattern only has meaning within the timeframe it is drawn on."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Pola harus selalu dibaca dengan informasi apa?",
      "options": ["Timeframe-nya disebutkan", "Hanya warnanya", "Hanya panjang wick-nya", "Tidak perlu konteks"],
      "answer": "Timeframe-nya disebutkan",
      "explanation": "Pola hanya memiliki makna dalam timeframe tempat pola itu digambar."
    }$block$::jsonb),

    -- Lesson 8: What a chart cannot tell you
    ('chart-reading-limits', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Which of these can a price chart show?",
      "options": ["Past open, high, low, and close", "A guaranteed future price", "Whether a stock is right for you", "Company management quality"],
      "answer": "Past open, high, low, and close",
      "explanation": "Charts summarize historical price data; they cannot predict the future or judge suitability."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Manakah dari berikut ini yang bisa ditunjukkan grafik harga?",
      "options": ["Open, high, low, dan close masa lalu", "Harga masa depan yang dijamin", "Apakah saham cocok untukmu", "Kualitas manajemen perusahaan"],
      "answer": "Open, high, low, dan close masa lalu",
      "explanation": "Grafik merangkum data harga historis; grafik tidak dapat memprediksi masa depan atau menilai kecocokan."
    }$block$::jsonb),
    ('chart-reading-limits', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "A chart pattern alone cannot tell you what?",
      "options": ["Whether an investment fits your personal situation", "Where price has reacted before", "How volatile a period was", "The close price"],
      "answer": "Whether an investment fits your personal situation",
      "explanation": "Personal suitability depends on goals, risk tolerance, and circumstances, not only price history."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Pola grafik saja tidak dapat memberitahumu apa?",
      "options": ["Apakah investasi cocok untuk situasi pribadimu", "Di mana harga pernah bereaksi", "Seberapa volatil sebuah periode", "Harga close"],
      "answer": "Apakah investasi cocok untuk situasi pribadimu",
      "explanation": "Kecocokan pribadi bergantung pada tujuan, toleransi risiko, dan keadaan, bukan hanya riwayat harga."
    }$block$::jsonb),
    ('chart-reading-limits', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Why should chart reading be combined with goals and risk limits?",
      "options": ["Because charts describe past price, not personal suitability", "Because charts replace all research", "Because one pattern guarantees profit", "Because charts show fundamentals"],
      "answer": "Because charts describe past price, not personal suitability",
      "explanation": "Charts help read price history; goals and risk limits keep decisions personal and responsible."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Mengapa membaca grafik harus dikombinasikan dengan tujuan dan batas risiko?",
      "options": ["Karena grafik menggambarkan harga masa lalu, bukan kecocokan pribadi", "Karena grafik menggantikan semua riset", "Karena satu pola menjamin keuntungan", "Karena grafik menunjukkan fundamental"],
      "answer": "Karena grafik menggambarkan harga masa lalu, bukan kecocokan pribadi",
      "explanation": "Grafik membantu membaca riwayat harga; tujuan dan batas risiko membuat keputusan tetap personal dan bertanggung jawab."
    }$block$::jsonb)
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied_questions.body, applied_questions.body_id, 'intermediate', 'visual_applied', TRUE
FROM applied_questions
JOIN public.lessons AS lesson ON lesson.slug = applied_questions.slug
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants AS existing
  WHERE existing.lesson_id = lesson.id AND existing.topic_tag = 'visual_applied'
);


-- ---------------------------------------------------------------------------
-- 4. Optional five-Jakarta-calendar-day recall prompts (one per lesson)
-- ---------------------------------------------------------------------------
WITH recalls(slug, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id) AS (
  VALUES
    ('chart-ohcl-basics',
     'A single candle shows four prices. Which price was the last traded price of the period?',
     'Satu candle menunjukkan empat harga. Harga mana yang merupakan harga transaksi terakhir dalam periode?',
     $block$[{"id":"close","label":"Close"},{"id":"open","label":"Open"},{"id":"high","label":"High"},{"id":"low","label":"Low"}]$block$::jsonb,
     $block$[{"id":"close","label":"Close"},{"id":"open","label":"Open"},{"id":"high","label":"High"},{"id":"low","label":"Low"}]$block$::jsonb,
     'close',
     'Close is the last traded price of the period.',
     'Close adalah harga transaksi terakhir dalam periode.'),
    ('chart-body-and-wick',
     'The wick of a candle shows what kind of price movement?',
     'Wick pada candle menunjukkan pergerakan harga seperti apa?',
     $block$[{"id":"rejected_range","label":"Prices that were reached but not held"},{"id":"body_only","label":"Only the open and close range"},{"id":"future_price","label":"A guaranteed future price"},{"id":"average_price","label":"The average price of the period"}]$block$::jsonb,
     $block$[{"id":"rejected_range","label":"Harga yang tersentuh tetapi tidak bertahan"},{"id":"body_only","label":"Hanya rentang open dan close"},{"id":"future_price","label":"Harga masa depan yang dijamin"},{"id":"average_price","label":"Harga rata-rata periode"}]$block$::jsonb,
     'rejected_range',
     'Wicks show prices the market reached but rejected before the close.',
     'Wick menunjukkan harga yang pernah dicapai pasar tetapi ditolak sebelum close.'),
    ('chart-bullish-bearish-doji',
     'A doji candle mainly signals what?',
     'Candle doji terutama menandakan apa?',
     $block$[{"id":"indecision","label":"Indecision between buyers and sellers"},{"id":"strong_buy","label":"A strong buying signal"},{"id":"guaranteed_reversal","label":"A guaranteed reversal"},{"id":"no_price_movement","label":"That the price did not move at all"}]$block$::jsonb,
     $block$[{"id":"indecision","label":"Ketidakpastian antara pembeli dan penjual"},{"id":"strong_buy","label":"Sinyal pembelian kuat"},{"id":"guaranteed_reversal","label":"Pembalikan yang dijamin"},{"id":"no_price_movement","label":"Bahwa harga sama sekali tidak bergerak"}]$block$::jsonb,
     'indecision',
     'A doji forms when open and close are close together, showing indecision.',
     'Doji terbentuk saat open dan close berada dekat, menunjukkan ketidakpastian.'),
    ('chart-long-wick-rejection',
     'What does a long upper wick after a price rise suggest?',
     'Apa yang disarankan oleh wick atas panjang setelah kenaikan harga?',
     $block$[{"id":"rejection","label":"Price was rejected from a higher level"},{"id":"continuation","label":"Price will definitely keep rising"},{"id":"no_sellers","label":"There were no sellers"},{"id":"guaranteed_buy","label":"A guaranteed buying opportunity"}]$block$::jsonb,
     $block$[{"id":"rejection","label":"Harga ditolak dari level yang lebih tinggi"},{"id":"continuation","label":"Harga pasti terus naik"},{"id":"no_sellers","label":"Tidak ada penjual"},{"id":"guaranteed_buy","label":"Kesempatan beli yang dijamin"}]$block$::jsonb,
     'rejection',
     'A long upper wick means price rose but was pushed back down before the close.',
     'Wick atas panjang berarti harga naik tetapi didorong kembali turun sebelum close.'),
    ('chart-hammer-shooting-star',
     'Which statement about hammer or shooting-star patterns is correct?',
     'Pernyataan mana tentang pola hammer atau shooting star yang benar?',
     $block$[{"id":"context_matters","label":"Their meaning depends on trend and confirmation"},{"id":"always_buy","label":"A hammer always means buy"},{"id":"always_sell","label":"A shooting star always means sell"},{"id":"shape_alone","label":"Shape alone predicts the next move"}]$block$::jsonb,
     $block$[{"id":"context_matters","label":"Maknanya bergantung pada tren dan konfirmasi"},{"id":"always_buy","label":"Hammer selalu berarti beli"},{"id":"always_sell","label":"Shooting star selalu berarti jual"},{"id":"shape_alone","label":"Bentuk saja memprediksi langkah berikutnya"}]$block$::jsonb,
     'context_matters',
     'These patterns are vocabulary, not standalone predictions; context matters.',
     'Pola-pola ini adalah kosa kata, bukan prediksi berdiri sendiri; konteks penting.'),
    ('chart-support-resistance',
     'Support and resistance are best described as what?',
     'Support dan resistance paling tepat dijelaskan sebagai apa?',
     $block$[{"id":"zones","label":"Zones where price has repeatedly reacted"},{"id":"exact_numbers","label":"Exact magical prices"},{"id":"guaranteed_floors","label":"Guaranteed floors and ceilings"},{"id":"single_lines","label":"Single precise lines"}]$block$::jsonb,
     $block$[{"id":"zones","label":"Zona tempat harga berulang kali bereaksi"},{"id":"exact_numbers","label":"Harga ajaib yang tepat"},{"id":"guaranteed_floors","label":"Lantai dan langit yang dijamin"},{"id":"single_lines","label":"Garis presisi tunggal"}]$block$::jsonb,
     'zones',
     'Support and resistance are areas defined by repeated price reactions, not exact numbers.',
     'Support dan resistance adalah area yang ditentukan oleh reaksi harga berulang, bukan angka tepat.'),
    ('chart-trend-and-timeframe',
     'Why can the same price history look different on a daily and hourly chart?',
     'Mengapa riwayat harga yang sama bisa terlihat berbeda di grafik harian dan per jam?',
     $block$[{"id":"timeframe","label":"Each candle covers a different amount of time"},{"id":"different_data","label":"They use completely different data"},{"id":"wrong_chart","label":"One of the charts is wrong"},{"id":"random","label":"The difference is random"}]$block$::jsonb,
     $block$[{"id":"timeframe","label":"Setiap candle mencakup jumlah waktu yang berbeda"},{"id":"different_data","label":"Mereka menggunakan data yang benar-benar berbeda"},{"id":"wrong_chart","label":"Sal satu grafik salah"},{"id":"random","label":"Perbedaannya acak"}]$block$::jsonb,
     'timeframe',
     'Different timeframes compress or expand the detail shown in each candle.',
     'Timeframe yang berbeda memampatkan atau memperluas detail yang ditampilkan pada setiap candle.'),
    ('chart-reading-limits',
     'What is a chart unable to tell you?',
     'Apa yang tidak dapat diberitahu oleh grafik?',
     $block$[{"id":"personal_suitability","label":"Whether an investment fits your personal situation"},{"id":"past_prices","label":"Past open, high, low, and close prices"},{"id":"reaction_areas","label":"Where price has reacted before"},{"id":"volatility","label":"How volatile a period was"}]$block$::jsonb,
     $block$[{"id":"personal_suitability","label":"Apakah investasi cocok untuk situasi pribadimu"},{"id":"past_prices","label":"Harga open, high, low, dan close masa lalu"},{"id":"reaction_areas","label":"Di mana harga pernah bereaksi"},{"id":"volatility","label":"Seberapa volatil sebuah periode"}]$block$::jsonb,
     'personal_suitability',
     'Charts summarize price history; personal suitability depends on goals and risk tolerance.',
     'Grafik merangkum riwayat harga; kecocokan pribadi bergantung pada tujuan dan toleransi risiko.')
)
INSERT INTO public.lesson_recall_questions (
  lesson_id, question_en, question_id, options_en, options_id,
  correct_option, explanation_en, explanation_id, is_active
)
SELECT lesson.id, recalls.question_en, recalls.question_id, recalls.options_en, recalls.options_id,
       recalls.correct_option, recalls.explanation_en, recalls.explanation_id, TRUE
FROM recalls
JOIN public.lessons AS lesson ON lesson.slug = recalls.slug
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = TRUE,
  updated_at = NOW();

COMMIT;
