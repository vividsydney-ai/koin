# Koinaku MVP v2.0 Curriculum Map

**Version:** 2.0  
**Scope:** 32-lesson free foundation-first track  
**Locked by:** Loop state KO-CURR-001 / plan `karnak-black-bolt-booster-gold`  
**Author:** Curriculum Architect subagent  

---

## 1. Rationale

### 1.1 Why this order?

The current curriculum jumps from “needs vs. wants” directly into risk/return and IDX in five lessons. MVP v2.0 slows the pace so that an Indonesian teen with zero finance background meets every concept in the right order:

1. **Foundation first** — define money, value, inflation, income/wealth, needs/wants, assets/liabilities, risk, and time value of money *before* any investing content appears.
2. **Behavior before products** — budgeting, emergency funds, saving first, spending traps, debt traps, and goal setting are taught before interest, banks, or reksa dana.
3. **Scam defense before wealth building** — users must know how to check an OJK license and spot red flags before they encounter compound-return claims.
4. **Wealth building before stock picking** — interest, compound interest, risk-return, diversification, and reksa dana are taught before reading a stock page.
5. **Investing fundamentals** — stocks, IDX rules, lot sizes, and portfolio thinking come only after the earlier concepts are locked.
6. **Pro teaser** — four advanced lessons preview Koin Pro topics (taxes, macro, behavioral bias, financial planning) without requiring Pro access.

### 1.2 Existing lessons: kept, rewritten, or deactivated

| Current slug | Current # | Decision in v2.0 | New # | Notes |
|--------------|-----------|------------------|-------|-------|
| `money-basics-101` | 1 | **Rewrite in place** | 1 | Strip fraud content (moved to Lesson 15). Reteach as pure “What is money?” + needs/wants split. |
| `budgeting-101` | 2 | **Keep / rewrite** | 9 | Topic matches; tighten Indonesian-student framing. |
| `inflation-101` | 3 | **Keep / rewrite** | 3 | Topic matches; keep BI source framing, split purchasing-power concept into Lesson 2. |
| `risk-return-101` | 4 | **Narrow / rewrite** | 22 | Existing lesson mixes compounding + diversification. v2.0 narrows to risk-return only. |
| `idx-basics-101` | 5 | **Narrow / rewrite** | 26 | Existing lesson is a broad IDX intro. v2.0 narrows to IDX rules and lot sizes. |
| `emergency-fund-101` | 10 | **Keep / move** | 10 | Just published in migration 025; change `lesson_number` from 10 to 10 (already fits new sequence). |
| `money_basics-advanced` | 10 (draft) | **Deactivate** | — | Repurposed row already became `emergency-fund-101`; original advanced content discarded. |
| `inflation-advanced` | 11 (draft) | **Deactivate** | — | Too advanced for MVP v2.0; may become Koin Pro material. |
| `budgeting-advanced` | 12 (draft) | **Deactivate** | — | May become Koin Pro material. |
| `risk_return-advanced` | 13 (draft) | **Deactivate** | — | May become Koin Pro material. |
| `idx_basics-advanced` | 14 (draft) | **Deactivate** | — | May become Koin Pro material. |
| `behavioral_finance-advanced` | 15 (draft) | **Deactivate** | — | Concepts reappear in Lesson 31 at a teaser level. |

*Deactivation means `is_published = false`; no rows are deleted so existing user attempts stay intact.*

### 1.3 New topics to add

The current `topics` table only has five rows. The curriculum below reuses those five and adds the following new topic rows (topic_slug → display name):

| topic_slug | name (EN) | name_id (ID) |
|------------|-----------|--------------|
| `value_purchasing_power` | Value & Purchasing Power | Nilai dan Daya Beli |
| `income_wealth` | Income vs Wealth | Pendapatan vs Kekayaan |
| `assets_liabilities` | Assets vs Liabilities | Aset vs Liabilitas |
| `risk_basics` | Understanding Risk | Memahami Risiko |
| `time_value_money` | Time Value of Money | Nilai Waktu Uang |
| `emergency_fund` | Emergency Fund | Dana Darurat |
| `saving_habits` | Saving Habits | Kebiasaan Menabung |
| `spending_behavior` | Spending Behavior | Perilaku Pengeluaran |
| `debt_management` | Debt Management | Manajemen Utang |
| `goal_setting` | Goal Setting | Menetapkan Tujuan Keuangan |
| `scam_defense` | Scam Defense | Pertahanan dari Penipuan |
| `ojk_license_check` | OJK License Check | Cek Izin OJK |
| `phishing_social_engineering` | Phishing & Social Engineering | Phishing & Rekayasa Sosial |
| `mlm_pyramid` | MLM & Pyramid Red Flags | Tanda MLM & Piramida |
| `interest` | Interest | Bunga |
| `compound_interest` | Compound Interest | Bunga Majemuk |
| `bank_vs_investment` | Bank vs Investment | Bank vs Investasi |
| `diversification` | Diversification | Diversifikasi |
| `reksa_dana` | Reksa Dana Basics | Dasar-Dasar Reksa Dana |
| `stocks` | Stocks | Saham |
| `stock_analysis` | Reading a Stock Page | Membaca Halaman Saham |
| `portfolio` | Portfolio Thinking | Berpikir Portofolio |
| `taxes` | Taxes on Returns | Pajak atas Imbal Hasil |
| `macro_indicators` | Macro Indicators | Indikator Makro |
| `behavioral_finance` | Behavioral Finance | Keuangan Perilaku |
| `financial_planning` | Financial Planning | Perencanaan Keuangan |

---

## 2. Stage 1 — Foundation (8 lessons, `beginner`)

Pure vocabulary and mental models. No investing, no product pitches, no tax.

### Lesson 1: What Is Money?

- **lesson_number:** 1
- **slug:** `money-basics-101`
- **title:** What Is Money?
- **title_id:** Apa Itu Uang?
- **topic_slug:** `money_basics`
- **difficulty:** beginner
- **xp_reward:** 50
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** *(none)*
- **one_line_objective:** The user can explain money as a medium of exchange, store of value, and unit of account using a daily Indonesian transaction.
- **quiz_type_recommendation:** `matching`
- **source_theme:** OJK SNLIK / OJK Buku Saku Pengelolaan Keuangan Pribadi
- **book_hook:** *The Psychology of Money* — introduction: money is a tool for optionality, not a scorecard.
- **indonesian_example_prompt:** Bayu wants to buy mie ayam at a warung but the seller only accepts cash; explain how money solves the problem of barter and why a GoPay balance is still “money.”

### Lesson 2: Value and Purchasing Power

- **lesson_number:** 2
- **slug:** `value-and-purchasing-power`
- **title:** Value and Purchasing Power
- **title_id:** Nilai dan Daya Beli
- **topic_slug:** `value_purchasing_power`
- **difficulty:** beginner
- **xp_reward:** 50
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `money-basics-101`
- **one_line_objective:** The user can compare what the same amount of rupiah can buy in two different situations.
- **quiz_type_recommendation:** `multiple_choice`
- **source_theme:** BI inflation / OJK consumer protection
- **book_hook:** *The Psychology of Money* — “wealth is what you don’t see,” i.e., purchasing power matters more than display.
- **indonesian_example_prompt:** A bowl of mie ayam costs Rp 15,000 in Jakarta and Rp 12,000 in Yogyakarta; write a short example showing why Rp 50,000 has different purchasing power in each city.

### Lesson 3: Inflation Basics

- **lesson_number:** 3
- **slug:** `inflation-101`
- **title:** Inflation: Why Your Rupiah Buys Less Over Time
- **title_id:** Inflasi: Mengapa Rupiahmu Membeli Lebih Sedikit dari Waktu ke Waktu
- **topic_slug:** `inflation`
- **difficulty:** beginner
- **xp_reward:** 55
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `value-and-purchasing-power`
- **one_line_objective:** The user can define inflation, state BI’s target range, and explain why cash loses purchasing power over time.
- **quiz_type_recommendation:** `true_false`
- **source_theme:** Bank Indonesia — Tentang Inflasi / BI inflation target
- **book_hook:** *The Psychology of Money* — the hidden tax of inflation on idle cash.
- **indonesian_example_prompt:** In 2020 a bowl of mie ayam cost Rp 12,000; in 2025 it costs Rp 16,000. Show how Rina’s Rp 120,000 under the pillow buys fewer bowls today.

### Lesson 4: Income vs Wealth

- **lesson_number:** 4
- **slug:** `income-vs-wealth`
- **title:** Income vs Wealth
- **title_id:** Pendapatan vs Kekayaan
- **topic_slug:** `income_wealth`
- **difficulty:** beginner
- **xp_reward:** 50
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `money-basics-101`
- **one_line_objective:** The user can distinguish income (a flow) from wealth (a stock) and identify which one indicates long-term financial health.
- **quiz_type_recommendation:** `matching`
- **source_theme:** OJK SNLIK / OJK Buku Saku
- **book_hook:** *The Psychology of Money* — “wealth is what you don’t see” (high income ≠ high wealth).
- **indonesian_example_prompt:** Andi earns Rp 8 juta/month as a sales promoter but has zero savings; Budi earns Rp 4 juta/month as a barista and has Rp 15 juta saved. Ask which person is wealthier and why.

### Lesson 5: Needs vs Wants

- **lesson_number:** 5
- **slug:** `needs-vs-wants-101`
- **title:** Needs vs Wants
- **title_id:** Kebutuhan vs Keinginan
- **topic_slug:** `money_basics`
- **difficulty:** beginner
- **xp_reward:** 50
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `money-basics-101`
- **one_line_objective:** The user can classify a list of monthly expenses into needs and wants and explain why the distinction matters for budgeting.
- **quiz_type_recommendation:** `ordering` *(order monthly spending from need to want)*
- **source_theme:** OJK SNLIK / OJK Buku Saku Pengelolaan Keuangan Pribadi
- **book_hook:** *I Will Teach You To Be Rich* — conscious spending framework: cover needs first, then guilt-free wants.
- **indonesian_example_prompt:** Sari gets Rp 1,500,000 monthly allowance. List her expenses (kos, pulsa, streaming subscription, new sneakers, mie ayam lunch) and ask her to mark each as need or want.

### Lesson 6: Assets vs Liabilities

- **lesson_number:** 6
- **slug:** `assets-vs-liabilities`
- **title:** Assets vs Liabilities
- **title_id:** Aset vs Liabilitas
- **topic_slug:** `assets_liabilities`
- **difficulty:** beginner
- **xp_reward:** 55
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `income-vs-wealth`
- **one_line_objective:** The user can define an asset as something that puts money in your pocket and a liability as something that takes money out.
- **quiz_type_recommendation:** `matching`
- **source_theme:** OJK Buku Saku / OJK consumer education
- **book_hook:** *Rich Dad Poor Dad* — asset/liability framing only; localize to Indonesian contexts.
- **indonesian_example_prompt:** Dodi buys a motorbike on credit to become an ojek online driver. His friend Eko buys a motorbike on credit just for weekend rides. Explain why the same item can be an asset for one person and a liability for the other.

### Lesson 7: Understanding Risk

- **lesson_number:** 7
- **slug:** `understanding-risk`
- **title:** Understanding Risk
- **title_id:** Memahami Risiko
- **topic_slug:** `risk_basics`
- **difficulty:** beginner
- **xp_reward:** 55
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `needs-vs-wants-101`
- **one_line_objective:** The user can explain risk as the chance of an outcome being worse than expected and give a non-investing example.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** OJK consumer protection / OJK SNLIK
- **book_hook:** *The Psychology of Money* — “risk is what’s left over after you think you’ve thought of everything.”
- **indonesian_example_prompt:** Rina lends Rp 200,000 to a classmate who often pays back late. Write a short case study showing the risk (not getting paid back) and the reward (helping a friend).

### Lesson 8: Time Value of Money

- **lesson_number:** 8
- **slug:** `time-value-of-money`
- **title:** Time Value of Money
- **title_id:** Nilai Waktu Uang
- **topic_slug:** `time_value_money`
- **difficulty:** beginner
- **xp_reward:** 60
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `understanding-risk`
- **one_line_objective:** The user can explain why receiving the same amount of money sooner is generally better than later.
- **quiz_type_recommendation:** `multiple_choice`
- **source_theme:** OJK Buku Saku / BI financial literacy
- **book_hook:** *The Psychology of Money* — the power of starting early; opportunity cost of waiting.
- **indonesian_example_prompt:** Bayu is owed Rp 500,000. He can be paid today or in three months. Explain why receiving it today gives him more options, using the example of buying a needed phone charger now versus later.

---

## 3. Stage 2 — Behavior & Habits (6 lessons, `beginner`)

Budgeting, emergency funds, saving first, spending traps, debt traps, and goal setting.

### Lesson 9: Budgeting Basics

- **lesson_number:** 9
- **slug:** `budgeting-101`
- **title:** Budgeting: The 50/30/20 Rule, Indonesian Style
- **title_id:** Anggaran: Aturan 50/30/20 ala Indonesia
- **topic_slug:** `budgeting`
- **difficulty:** beginner
- **xp_reward:** 60
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `needs-vs-wants-101`
- **one_line_objective:** The user can split a monthly income into needs, wants, and savings/debt using an Indonesian-student budget.
- **quiz_type_recommendation:** `fill_blank`
- **source_theme:** OJK Buku Saku Pengelolaan Keuangan Pribadi
- **book_hook:** *I Will Teach You To Be Rich* — conscious spending plan adapted to Indonesian income levels.
- **indonesian_example_prompt:** Ani earns Rp 2,000,000/month from a part-time job. She pays kos Rp 800,000, eats mie ayam Rp 600,000, and wants Rp 400,000 for streaming and hangouts. Ask how much she should save/debt-pay using 50/30/20.

### Lesson 10: Emergency Fund

- **lesson_number:** 10
- **slug:** `emergency-fund-101`
- **title:** Emergency Fund: Prepare Before You Invest
- **title_id:** Dana Darurat: Siapkan Sebelum Investasi
- **topic_slug:** `emergency_fund`
- **difficulty:** beginner
- **xp_reward:** 65
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `budgeting-101`
- **one_line_objective:** The user can state the 3–6 month rule, name two safe places to store an emergency fund, and explain why it must stay separate from daily cash.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** OJK Buku Saku / OJK consumer protection
- **book_hook:** *The Psychology of Money* — “savings is a hedge against regret and emergency.”
- **indonesian_example_prompt:** Budi is an ojek online driver with irregular income. His phone breaks, costing Rp 3,000,000 to fix. Write a case study showing why a separate emergency fund prevents him from borrowing from a pinjol app.

### Lesson 11: Pay Yourself First

- **lesson_number:** 11
- **slug:** `pay-yourself-first`
- **title:** Pay Yourself First
- **title_id:** Bayar Dirimu Sendiri Dulu
- **topic_slug:** `saving_habits`
- **difficulty:** beginner
- **xp_reward:** 55
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `emergency-fund-101`
- **one_line_objective:** The user can describe how to automate savings before discretionary spending and explain why this habit beats willpower.
- **quiz_type_recommendation:** `true_false`
- **source_theme:** OJK Buku Saku / OJK SNLIK
- **book_hook:** *I Will Teach You To Be Rich* — automate your finances so you save without deciding every month.
- **indonesian_example_prompt:** Every payday, Doni transfers Rp 300,000 to a separate tabungan before buying pulsa or coffee. Explain why this “pay yourself first” habit is more reliable than saving what is left at the end of the month.

### Lesson 12: Spending Traps

- **lesson_number:** 12
- **slug:** `spending-traps`
- **title:** Spending Traps
- **title_id:** Jebakan Pengeluaran
- **topic_slug:** `spending_behavior`
- **difficulty:** beginner
- **xp_reward:** 55
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `pay-yourself-first`
- **one_line_objective:** The user can identify three common spending traps (flash sales, influencer hype, “small” daily treats) and propose a defense for each.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** OJK consumer protection / OJK financial literacy campaigns
- **book_hook:** *The Psychology of Money* — “no one is impressed with your possessions as much as you are.”
- **indonesian_example_prompt:** Dina sees a Shopee flash sale: “buy 2 get 1 free” on skincare she does not need. Write a case study asking what she should do before checking out and why.

### Lesson 13: Debt Traps

- **lesson_number:** 13
- **slug:** `debt-traps`
- **title:** Debt Traps: PayLater, Pinjol, and Credit Cards
- **title_id:** Jebakan Utang: PayLater, Pinjol, dan Kartu Kredit
- **topic_slug:** `debt_management`
- **difficulty:** beginner
- **xp_reward:** 60
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `spending-traps`
- **one_line_objective:** The user can explain how high-interest or late-payment debt can grow faster than income and name one escape strategy.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** OJK consumer protection / OJK waspadai investasi bodong
- **book_hook:** *I Will Teach You To Be Rich* — the high cost of credit-card and consumer debt; pay high-interest debt aggressively.
- **indonesian_example_prompt:** Raka uses PayLater to buy a Rp 1,200,000 hoodie and misses the due date. The bill grows to Rp 1,500,000 with late fees. Ask what Raka should have done first and how to get out.

### Lesson 14: Financial Goal Setting

- **lesson_number:** 14
- **slug:** `goal-setting-101`
- **title:** Financial Goal Setting
- **title_id:** Menetapkan Tujuan Keuangan
- **topic_slug:** `goal_setting`
- **difficulty:** beginner
- **xp_reward:** 55
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `debt-traps`
- **one_line_objective:** The user can write one short-term, one medium-term, and one long-term financial goal using a specific amount and deadline.
- **quiz_type_recommendation:** `fill_blank`
- **source_theme:** OJK SNLIK / OJK Buku Saku
- **book_hook:** *Tiny Habits* — anchor new financial habits to existing routines; *I Will Teach You To Be Rich* — target-date savings.
- **indonesian_example_prompt:** Fani wants a Rp 5,000,000 laptop in 10 months for college. Ask her to break this into a monthly savings target and explain why vague goals like “save more” usually fail.

---

## 4. Stage 3 — Scam Defense (4 lessons, `beginner`)

Recognize red flags before any wealth-building or investing content.

### Lesson 15: Too Good To Be True

- **lesson_number:** 15
- **slug:** `too-good-to-be-true`
- **title:** Too Good To Be True
- **title_id:** Terlalu Bagus untuk Jadi Kenyataan
- **topic_slug:** `scam_defense`
- **difficulty:** beginner
- **xp_reward:** 60
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `goal-setting-101`
- **one_line_objective:** The user can list three red flags of investment fraud and explain why “guaranteed high returns” is impossible.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** OJK consumer protection — Waspadai Investasi Bodong
- **book_hook:** *The Psychology of Money* — “no one is impressed with your possessions as much as you are” / avoiding get-rich-quick stories.
- **indonesian_example_prompt:** A Telegram group promises “guaranteed 20% profit per month, zero risk, invite your friends.” Write a case study asking what is wrong with each claim.

### Lesson 16: Check Before You Invest: OJK License

- **lesson_number:** 16
- **slug:** `check-ojk-license`
- **title:** Check Before You Invest: OJK License
- **title_id:** Cek Sebelum Investasi: Izin OJK
- **topic_slug:** `ojk_license_check`
- **difficulty:** beginner
- **xp_reward:** 60
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `too-good-to-be-true`
- **one_line_objective:** The user can name the OJK website/app tools to verify a financial product and explain why an unlicensed product is illegal and dangerous.
- **quiz_type_recommendation:** `ordering` *(steps to verify a product)*
- **source_theme:** OJK consumer protection / OJK licensing portal
- **book_hook:** *I Will Teach You To Be Rich* — only use regulated, reputable institutions.
- **indonesian_example_prompt:** A friend recommends a “crypto staking” app that is not on OJK’s list. Show the exact steps to check the OJK licensing page and what to tell the friend.

### Lesson 17: Phishing and Social Engineering

- **lesson_number:** 17
- **slug:** `phishing-social-engineering`
- **title:** Phishing and Social Engineering
- **title_id:** Phishing dan Rekayasa Sosial
- **topic_slug:** `phishing_social_engineering`
- **difficulty:** beginner
- **xp_reward:** 55
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `check-ojk-license`
- **one_line_objective:** The user can identify phishing attempts via SMS, WhatsApp, or fake websites and state the correct response.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** OJK consumer protection / BI digital financial literacy
- **book_hook:** *The Psychology of Money* — trust but verify; fear and urgency are used against you.
- **indonesian_example_prompt:** Bayu gets a WhatsApp message: “Your BCA account is blocked, click this link to reactivate.” The link asks for OTP. Ask what Bayu should do and why.

### Lesson 18: MLM and Pyramid Red Flags

- **lesson_number:** 18
- **slug:** `mlm-pyramid-red-flags`
- **title:** MLM and Pyramid Red Flags
- **title_id:** Tanda MLM dan Piramida
- **topic_slug:** `mlm_pyramid`
- **difficulty:** beginner
- **xp_reward:** 60
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `phishing-social-engineering`
- **one_line_objective:** The user can distinguish a product-based MLM from a recruitment-driven pyramid scheme and explain why the latter collapses.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** OJK consumer protection / OJK waspadai investasi bodong
- **book_hook:** *The Psychology of Money* — beware of stories where wealth seems to come from recruiting rather than value creation.
- **indonesian_example_prompt:** Sari is invited to a skincare “business” where she must buy Rp 3,000,000 stock and recruit two friends to earn. Write a case study asking whether this is MLM or pyramid and what red flags she should spot.

---

## 5. Stage 4 — Wealth Building Basics (6 lessons, `intermediate`)

Interest, compound interest, bank vs investment, risk-return, diversification, reksa dana.

### Lesson 19: What Is Interest?

- **lesson_number:** 19
- **slug:** `interest-101`
- **title:** What Is Interest?
- **title_id:** Apa Itu Bunga?
- **topic_slug:** `interest`
- **difficulty:** intermediate
- **xp_reward:** 60
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `time-value-of-money`
- **one_line_objective:** The user can define interest as the cost of borrowing or reward for saving and calculate simple interest on a small rupiah amount.
- **quiz_type_recommendation:** `fill_blank`
- **source_theme:** BI suku bunga / OJK Buku Saku
- **book_hook:** *The Psychology of Money* — small differences in rate and time compound into large outcomes.
- **indonesian_example_prompt:** Rina saves Rp 1,000,000 in a bank deposito that pays 4% per year. Show how much interest she earns in one year and explain what the bank does with that money.

### Lesson 20: Compound Interest

- **lesson_number:** 20
- **slug:** `compound-interest-101`
- **title:** Compound Interest: Money Making Money
- **title_id:** Bunga Majemuk: Uang yang Membuat Uang
- **topic_slug:** `compound_interest`
- **difficulty:** intermediate
- **xp_reward:** 65
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `interest-101`
- **one_line_objective:** The user can explain compound interest as earning interest on interest and compare it to simple interest over multiple periods.
- **quiz_type_recommendation:** `multiple_choice`
- **source_theme:** OJK Buku Saku Mengenal Produk Investasi / BI financial literacy
- **book_hook:** *The Psychology of Money* — “time is the most powerful force in investing.”
- **indonesian_example_prompt:** Doni saves Rp 100,000/month starting at age 18 with 6% annual return. His brother starts at age 28. Ask how much more Doni has at age 40 and why starting early matters.

### Lesson 21: Bank vs Investment

- **lesson_number:** 21
- **slug:** `bank-vs-investment`
- **title:** Bank vs Investment: Where Should Your Money Go?
- **title_id:** Bank vs Investasi: Uangmu Harus ke Mana?
- **topic_slug:** `bank_vs_investment`
- **difficulty:** intermediate
- **xp_reward:** 60
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `compound-interest-101`
- **one_line_objective:** The user can compare savings/deposits with investment products on safety, liquidity, return, and time horizon.
- **quiz_type_recommendation:** `matching`
- **source_theme:** OJK Buku Saku Mengenal Produk Investasi / BI
- **book_hook:** *A Random Walk Down Wall Street* — savings for short-term safety, investments for long-term growth.
- **indonesian_example_prompt:** Bayu has Rp 5,000,000. He needs Rp 2,000,000 next month for tuition and can lock away Rp 3,000,000 for two years. Ask which portion belongs in a bank and which can be invested.

### Lesson 22: Risk and Return

- **lesson_number:** 22
- **slug:** `risk-return-101`
- **title:** Risk and Return
- **title_id:** Risiko dan Pengembalian
- **topic_slug:** `risk_return`
- **difficulty:** intermediate
- **xp_reward:** 65
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `understanding-risk`
- **one_line_objective:** The user can explain the general relationship between risk and expected return and give one Indonesian example for each end of the spectrum.
- **quiz_type_recommendation:** `multiple_choice`
- **source_theme:** OJK Buku Saku Mengenal Produk Investasi / IDX Academy
- **book_hook:** *A Random Walk Down Wall Street* — there is no free lunch; higher expected returns demand accepting more risk.
- **indonesian_example_prompt:** Compare a tabungan bank (low risk, low return) with a reksa dana saham (higher risk, higher potential return). Ask which is more appropriate for a goal five years away and why.

### Lesson 23: Diversification

- **lesson_number:** 23
- **slug:** `diversification-101`
- **title:** Diversification: Don’t Put All Eggs in One Basket
- **title_id:** Diversifikasi: Jangan Taruh Semua Telur dalam Satu Keranjang
- **topic_slug:** `diversification`
- **difficulty:** intermediate
- **xp_reward:** 60
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `risk-return-101`
- **one_line_objective:** The user can explain diversification as spreading money across assets to reduce the impact of any single loss.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** OJK / IDX investor education
- **book_hook:** *A Random Walk Down Wall Street* — diversification is the only free lunch in investing.
- **indonesian_example_prompt:** A warung only sells mie ayam. When raw chicken prices spike, sales collapse. A second warung sells mie ayam, es teh, and nasi goreng. Ask which warung is more diversified and why.

### Lesson 24: Reksa Dana Basics

- **lesson_number:** 24
- **slug:** `reksa-dana-basics`
- **title:** Reksa Dana Basics
- **title_id:** Dasar-Dasar Reksa Dana
- **topic_slug:** `reksa_dana`
- **difficulty:** intermediate
- **xp_reward:** 65
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `diversification-101`
- **one_line_objective:** The user can describe a reksa dana as pooled money managed by an investment manager and match the three main types (money market, fixed income, equity) to their risk level.
- **quiz_type_recommendation:** `matching`
- **source_theme:** OJK / IDX beginner investment guide
- **book_hook:** *A Random Walk Down Wall Street* — index and mutual funds as simple diversification tools.
- **indonesian_example_prompt:** Ani wants to start investing but does not know how to pick stocks. Explain how a reksa dana lets her own many stocks/bonds at once through an OJK-registered investment manager.

---

## 6. Stage 5 — Investing Fundamentals (4 lessons, `intermediate`)

Stocks, IDX rules, lot sizes, reading a stock page, portfolio thinking.

### Lesson 25: What Is a Stock?

- **lesson_number:** 25
- **slug:** `what-is-a-stock`
- **title:** What Is a Stock?
- **title_id:** Apa Itu Saham?
- **topic_slug:** `stocks`
- **difficulty:** intermediate
- **xp_reward:** 60
- **estimated_minutes:** 5
- **prerequisite_lesson_slugs:** `reksa-dana-basics`
- **one_line_objective:** The user can define a stock as partial ownership of a company and explain why stock prices change with supply and demand.
- **quiz_type_recommendation:** `multiple_choice`
- **source_theme:** IDX Academy / IDX Glossary
- **book_hook:** *A Random Walk Down Wall Street* — owning stocks means owning real businesses.
- **indonesian_example_prompt:** Explain that buying 1 lot of BBCA means owning a tiny piece of Bank Central Asia, and that the price moves because buyers and sellers agree (or disagree) on what it is worth.

### Lesson 26: IDX Rules and Lot Sizes

- **lesson_number:** 26
- **slug:** `idx-basics-101`
- **title:** IDX Rules and Lot Sizes
- **title_id:** Aturan IDX dan Ukuran Lot
- **topic_slug:** `idx_basics`
- **difficulty:** intermediate
- **xp_reward:** 65
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `what-is-a-stock`
- **one_line_objective:** The user can state the IDX trading day, lot size (100 shares), and one investor protection mechanism (SIPF).
- **quiz_type_recommendation:** `fill_blank`
- **source_theme:** IDX Academy / IDX investor protection (SIPF)
- **book_hook:** *A Random Walk Down Wall Street* — understand market structure before trading.
- **indonesian_example_prompt:** Doni wants to buy 75 shares of TLKM. Explain why he cannot do that on IDX and how many shares one lot represents, using IDX rules.

### Lesson 27: Reading a Stock Page

- **lesson_number:** 27
- **slug:** `reading-a-stock-page`
- **title:** Reading a Stock Page
- **title_id:** Membaca Halaman Saham
- **topic_slug:** `stock_analysis`
- **difficulty:** intermediate
- **xp_reward:** 65
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `idx-basics-101`
- **one_line_objective:** The user can identify open, high, low, close, volume, and market cap on an IDX stock summary and explain what volume tells you.
- **quiz_type_recommendation:** `matching`
- **source_theme:** IDX statistics / IDX glossary
- **book_hook:** *A Random Walk Down Wall Street* — price and volume are signals, not stories; avoid confusing noise with information.
- **indonesian_example_prompt:** Show a simplified BBCA stock card from IDX with open Rp 8,450, high Rp 8,620, low Rp 8,400, close Rp 8,550, volume 45M. Ask which numbers show price range and how active the day was.

### Lesson 28: Portfolio Thinking

- **lesson_number:** 28
- **slug:** `portfolio-thinking`
- **title:** Portfolio Thinking
- **title_id:** Berpikir Portofolio
- **topic_slug:** `portfolio`
- **difficulty:** intermediate
- **xp_reward:** 70
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `reading-a-stock-page`
- **one_line_objective:** The user can explain why a portfolio is the combination of all holdings and why asset mix should match goals and time horizon.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** IDX investor academy / OJK Buku Saku
- **book_hook:** *A Random Walk Down Wall Street* + *The Psychology of Money* — portfolio construction is about behavior, not just math.
- **indonesian_example_prompt:** Rina has Rp 10,000,000: Rp 3M in tabungan, Rp 4M in reksa dana pasar uang, Rp 3M in one stock. Ask whether this is a portfolio, what is missing, and how her goal (laptop in 1 year vs retirement in 30 years) changes the answer.

---

## 7. Stage 6 — Pro Teaser (4 lessons, `advanced`)

Preview Koin Pro topics: taxes, macro indicators, behavioral bias intro, financial plan.

### Lesson 29: Taxes on Your Returns

- **lesson_number:** 29
- **slug:** `taxes-on-returns`
- **title:** Taxes on Your Returns
- **title_id:** Pajak atas Imbal Hasil
- **topic_slug:** `taxes`
- **difficulty:** advanced
- **xp_reward:** 65
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `portfolio-thinking`
- **one_line_objective:** The user can name at least two types of investment return that may be taxed in Indonesia and explain why tax matters when comparing “gross” vs “net” return.
- **quiz_type_recommendation:** `multiple_choice`
- **source_theme:** OJK / DJP (Direktorat Jenderal Pajak) investor guidance
- **book_hook:** *I Will Teach You To Be Rich* — taxes are an expense; optimize legally, not by avoiding them.
- **indonesian_example_prompt:** Doni earns Rp 500,000 interest from a deposito and Rp 1,000,000 from a stock dividend. Explain that the government may take a portion as tax, so the return he keeps is lower than the headline number.

### Lesson 30: Macro Indicators to Watch

- **lesson_number:** 30
- **slug:** `macro-indicators`
- **title:** Macro Indicators to Watch
- **title_id:** Indikator Makro yang Perlu Diperhatikan
- **topic_slug:** `macro_indicators`
- **difficulty:** advanced
- **xp_reward:** 65
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `taxes-on-returns`
- **one_line_objective:** The user can describe BI Rate, inflation, and exchange rate as macro indicators that affect investment prices and purchasing power.
- **quiz_type_recommendation:** `matching`
- **source_theme:** Bank Indonesia — BI Rate, inflation, exchange rate
- **book_hook:** *A Random Walk Down Wall Street* — macro matters, but nobody consistently times it; focus on what you can control.
- **indonesian_example_prompt:** When BI raises the BI Rate, bank deposit interest may rise and stock prices may become more volatile. Ask why a teen investor should care, using pulsa prices or import gadget prices as examples.

### Lesson 31: Behavioral Bias Intro

- **lesson_number:** 31
- **slug:** `behavioral-bias-intro`
- **title:** Behavioral Bias Intro
- **title_id:** Pengenalan Bias Perilaku
- **topic_slug:** `behavioral_finance`
- **difficulty:** advanced
- **xp_reward:** 65
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `macro-indicators`
- **one_line_objective:** The user can identify FOMO, loss aversion, and herd behavior in a simple investing scenario.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** OJK investor education / IDX Academy
- **book_hook:** *The Psychology of Money* — “your personal history with money is the single biggest variable”; *Thinking, Fast and Slow* — loss aversion and FOMO.
- **indonesian_example_prompt:** All of Bayu’s friends are buying GOTO stock because of a viral TikTok. He is afraid of missing out but also afraid of losing money. Write a case study asking which biases are at work and what a calmer decision looks like.

### Lesson 32: Building Your Financial Plan

- **lesson_number:** 32
- **slug:** `building-financial-plan`
- **title:** Building Your Financial Plan
- **title_id:** Membangun Rencana Keuanganmu
- **topic_slug:** `financial_planning`
- **difficulty:** advanced
- **xp_reward:** 70
- **estimated_minutes:** 6
- **prerequisite_lesson_slugs:** `behavioral-bias-intro`
- **one_line_objective:** The user can draft a one-page financial plan covering goals, emergency fund, debt, protection, and an investment starter step.
- **quiz_type_recommendation:** `case_study`
- **source_theme:** OJK SNLIK / OJK Buku Saku
- **book_hook:** *I Will Teach You To Be Rich* — the 6-week personal finance plan; *The Psychology of Money* — plan for the planner, not the optimist.
- **indonesian_example_prompt:** Ani is 19, earns Rp 2.5M/month from freelance design, has no emergency fund, and Rp 2M in PayLater debt. Write a case study asking her to order the first five steps of her financial plan.

---

## 8. Summary Tables

### 8.1 Lessons by stage

| Stage | Lessons | Difficulty | New quiz types used |
|-------|---------|------------|---------------------|
| Foundation | 1–8 | beginner | matching, multiple_choice, true_false, ordering, case_study, fill_blank |
| Behavior & Habits | 9–14 | beginner | fill_blank, case_study, true_false |
| Scam Defense | 15–18 | beginner | case_study, ordering |
| Wealth Building Basics | 19–24 | intermediate | fill_blank, multiple_choice, matching, case_study |
| Investing Fundamentals | 25–28 | intermediate | multiple_choice, fill_blank, matching, case_study |
| Pro Teaser | 29–32 | advanced | multiple_choice, matching, case_study |

### 8.2 Slug reuse vs. new

| Slug status | Count | Slugs |
|-------------|-------|-------|
| Reused existing | 6 | `money-basics-101`, `inflation-101`, `budgeting-101`, `emergency-fund-101`, `risk-return-101`, `idx-basics-101` |
| New | 27 | all others |

*(Note: `money-basics-101` is reused for Lesson 1 but fully rewritten; `risk-return-101` and `idx-basics-101` are narrowed to a single concept.)*

### 8.3 Existing advanced draft lessons to deactivate

- `money_basics-advanced` (original row now repurposed as `emergency-fund-101`)
- `inflation-advanced`
- `budgeting-advanced`
- `risk_return-advanced`
- `idx_basics-advanced`
- `behavioral_finance-advanced`

---

## 9. Handoff Notes for Downstream Agents

- **Source Researcher:** Use `source_theme` per lesson to find ≥1 Tier 1 source (OJK/BI/IDX) and ≥1 book/source note. Avoid duplicating existing source codes OJK-001..008, BI-001..007, IDX-001..007, GLB-001..010.
- **Content Writer:** Follow the 18-year-old test; each lesson body must define terms before applying them. Foundation lessons must introduce terms first.
- **Variant Writer:** Respect the `quiz_type_recommendation`; use `case_study` for Lessons 7, 10, 12, 13, 15, 17, 18, 23, 28, 31, 32; use `matching` for vocabulary-heavy lessons (1, 4, 6, 21, 24, 27, 30).
- **Indonesian Contextualizer:** Replace any Western examples with the contexts listed in `indonesian_example_prompt` (mie ayam, GoPay, pulsa, warung, ojek online, allowance, etc.).
- **Verifier:** Confirm: 32 sequential lesson numbers; no duplicate concepts; investing only in Stages 4–5; Pro Teaser only in Stage 6; every lesson has a topic slug present in seed.sql or listed in §1.3.
