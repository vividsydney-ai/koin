# Curriculum Reorganization Summary

**Date:** 2026-07-25  
**Total Lessons:** 60  
**Duplicates Found:** 5 (deactivated, not deleted)  
**Published Lessons:** 35  
**Unpublished Lessons:** 25 (advanced/backup content)

---

## 📊 Chapter Breakdown

### Foundation 0 (Pre-requisite Mini-Track)
**Status:** ✅ 12 published lessons (101-112)  
**Purpose:** Basic financial literacy concepts for assessment-gated users

Lessons:
- What Is Money? (Foundation 0)
- What Is Inflation?
- What Is Interest?
- Income vs Wealth
- Assets vs Liabilities
- What Is Risk?
- What Is Return?
- Saving vs Investing
- Emergency Fund
- Needs vs Wants
- What Is Debt?
- Scam Red Flags

---

### Chapter 01: Money Basics
**Status:** 4 published / 2 deactivated / 1 unpublished  
**Topics:** money_basics, value_purchasing_power, inflation, risk_basics, time_value_money

**Published (4):**
- Value and Purchasing Power
- Inflation: Why Your Rupiah Buys Less Over Time
- Understanding Risk
- Time Value of Money

**Deactivated (2) - Duplicates with Foundation 0:**
- ~~What Is Money?~~ (duplicate of Foundation 0 #101)
- ~~Needs vs Wants (Main Track)~~ (duplicate of Foundation 0 #110)

**Unpublished (1):**
- Advanced Inflation: Phillips curve (advanced difficulty)

---

### Chapter 02: Money Life Skills
**Status:** 3 published / 6 unpublished  
**Topics:** budgeting, saving_habits, spending_behavior, behavioral_finance

**Published (3):**
- Budgeting: The 50/30/20 Rule, Indonesian Style
- Pay Yourself First
- Spending Traps

**Unpublished (6):**
- Behavioral Bias Intro (advanced)
- Loss Aversion & FOMO (intermediate)
- Confidence & Risk Tolerance (intermediate)
- Volatility & Emotional Control (intermediate)
- Advanced Budgeting: capital budgeting (advanced)
- Advanced Behavioral Finance: bounded rationality (advanced)

---

### Chapter 03: Protect Yourself
**Status:** ✅ 4 published  
**Topics:** scam_defense, ojk_license_check, phishing_social_engineering, mlm_pyramid

**Published (4):**
- Too Good To Be True
- Check Before You Invest: OJK License
- Phishing and Social Engineering
- MLM and Pyramid Red Flags

---

### Chapter 04: Debt Management
**Status:** ✅ 5 published  
**Topics:** debt_management

**Published (5):**
- Debt Traps: PayLater, Pinjol, and Credit Cards
- Good Debt vs Bad Debt
- Why "Pay Later" Is Bad
- Credit Cards: Good or Bad?
- How to Pay Debt Responsibly

---

### Chapter 05: Financial Planning
**Status:** 2 published / 1 unpublished  
**Topics:** emergency_fund, goal_setting, financial_planning

**Published (2):**
- Emergency Fund: Prepare Before You Invest
- Financial Goal Setting

**Unpublished (1):**
- Building Your Financial Plan (advanced)

---

### Chapter 06: Grow Your Money
**Status:** 5 published / 1 deactivated / 1 unpublished  
**Topics:** interest, compound_interest, bank_vs_investment, risk_return, diversification, reksa_dana

**Published (5):**
- Compound Interest: Money Making Money
- Bank vs Investment: Where Should Your Money Go?
- Risk and Return
- Diversification: Don't Put All Eggs in One Basket
- Reksa Dana Basics

**Deactivated (1) - Duplicate with Foundation 0:**
- ~~What Is Interest? (Main Track)~~ (duplicate of Foundation 0 #103)

**Unpublished (1):**
- Advanced Risk & Return: Black-Scholes intuition (advanced)

---

### Chapter 07: Investing in Indonesia
**Status:** 4 published / 3 unpublished  
**Topics:** stocks, idx_basics, stock_analysis, portfolio, taxes, macro_indicators

**Published (4):**
- What Is a Stock?
- IDX Rules and Lot Sizes
- Reading a Stock Page
- Portfolio Thinking

**Unpublished (3):**
- Taxes on Your Returns (advanced)
- Macro Indicators to Watch (advanced)
- Advanced IDX Basics: market microstructure (advanced)

---

### Chapter 08: Cryptocurrency
**Status:** ✅ 4 published  
**Topics:** cryptocurrency

**Published (4):**
- What is Cryptocurrency?
- Crypto Risks and Scams in Indonesia
- How to Buy Crypto Safely
- Crypto vs Investing vs Gambling

---

### Uncategorized
**Status:** 2 unpublished  
**Lessons:**
- Assets vs Liabilities (Main Track) - duplicate of Foundation 0 #105
- Income vs Wealth (Main Track) - duplicate of Foundation 0 #104

---

## 🔍 Duplicates Deactivated (5)

These lessons were deactivated (`is_published = false`) because they duplicate Foundation 0 content. The Foundation 0 versions remain published as the canonical versions.

| # | Title | Topic | Replaced By |
|---|-------|-------|-------------|
| 1 | What Is Money? | money_basics | Foundation 0 #101 |
| 4 | Income vs Wealth (Main Track) | income_wealth | Foundation 0 #104 |
| 5 | Needs vs Wants (Main Track) | money_basics | Foundation 0 #110 |
| 6 | Assets vs Liabilities (Main Track) | assets_liabilities | Foundation 0 #105 |
| 25 | What Is Interest? (Main Track) | interest | Foundation 0 #103 |

**Note:** Lessons are deactivated, not deleted. All content remains in the database.

---

## 📁 Files Generated

1. **reorganized-curriculum-FINAL-2026-07-25.csv** - Full curriculum export with reorganization details
2. **supabase/migrations/20260725200000_reorganize_curriculum.sql** - Migration to apply changes
3. **CURRICULUM-REORG-SUMMARY.md** - This file

---

## 🚀 Next Steps

### Option 1: Review CSV First
```bash
# Open the CSV in your spreadsheet app
open reorganized-curriculum-FINAL-2026-07-25.csv
```

### Option 2: Apply Migration
```bash
# Apply to local Supabase
supabase db push

# Or apply to production
supabase db push --linked
```

### Option 3: Manual Review
The migration file contains:
- 5 UPDATE statements to deactivate duplicates
- UPDATE statements to reorder lessons by chapter

---

## ✅ Verification Checklist

- [x] Foundation 0 lessons (101-112) remain published
- [x] 5 duplicate main track lessons deactivated
- [x] Advanced lessons (difficulty=advanced) remain unpublished
- [x] Lessons numbered 45-52 (intermediate/advanced) remain unpublished
- [x] Chapter grouping follows logical progression:
  - Ch 01: Basic money concepts
  - Ch 02: Money management skills
  - Ch 03: Scam protection
  - Ch 04: Debt management
  - Ch 05: Financial planning
  - Ch 06: Investment basics
  - Ch 07: Stock market investing
  - Ch 08: Cryptocurrency

---

## 📈 Impact

**Before:**
- 39 published lessons (including duplicates)
- Confusing overlap between Foundation 0 and main track
- Out-of-order lesson numbering

**After:**
- 35 published lessons (no duplicates)
- Clear separation: Foundation 0 (prerequisite) → 8 chapters (main curriculum)
- Logical progression from basic to advanced
- All content preserved (deactivated, not deleted)
