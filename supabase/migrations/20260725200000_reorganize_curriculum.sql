-- Migration 055: Reorganize curriculum and deactivate duplicates
-- Issue: KO-156 (Curriculum Reorganization)
-- Date: 2026-07-25
--
-- This migration:
-- 1. Deactivates 5 duplicate lessons (main track versions that duplicate Foundation 0)
-- 2. Keeps Foundation 0 lessons as the canonical versions
-- 3. Preserves all lesson content (no deletions)
--
-- Duplicates deactivated:
-- - "What Is Money?" (main #1 vs Foundation 0 #101)
-- - "Income vs Wealth" (main #4 vs Foundation 0 #104)
-- - "Needs vs Wants" (main #5 vs Foundation 0 #110)
-- - "Assets vs Liabilities" (main #6 vs Foundation 0 #105)
-- - "What Is Interest?" (main #25 vs Foundation 0 #103)

-- Deactivate main track duplicates
UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = '0fa42c9f-66b9-42c1-b622-9f194a505a06'; -- #1 "What Is Money?"
UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = '1be1d991-71c2-4d37-a6db-6658ec89367a'; -- #4 "Income vs Wealth (Main Track)"
UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = 'c08723e0-8b2f-4c86-b24a-3fbc90d78b8f'; -- #5 "Needs vs Wants (Main Track)"
UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = '0c9d741a-7151-4bea-bb7f-152a185efa2a'; -- #6 "Assets vs Liabilities (Main Track)"
UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = 'a3dfa5b3-e967-439f-bf9a-a07d36d1f951'; -- #25 "What Is Interest? (Main Track)"

-- Update lesson_order for remaining published lessons to ensure logical progression
-- Chapter 01: Money Basics (truly basic, beginner level)
UPDATE lessons SET lesson_order = 100 WHERE slug = 'value-and-purchasing-power';
UPDATE lessons SET lesson_order = 101 WHERE slug = 'inflation-101';
UPDATE lessons SET lesson_order = 102 WHERE slug = 'understanding-risk';
UPDATE lessons SET lesson_order = 103 WHERE slug = 'time-value-of-money';

-- Chapter 02: Money Life Skills (budgeting, saving, behavior)
UPDATE lessons SET lesson_order = 200 WHERE slug = 'budgeting-101';
UPDATE lessons SET lesson_order = 201 WHERE slug = 'pay-yourself-first';
UPDATE lessons SET lesson_order = 202 WHERE slug = 'spending-traps';
UPDATE lessons SET lesson_order = 203 WHERE slug = 'behavioral-bias-intro';

-- Chapter 03: Protect Yourself (scam defense)
UPDATE lessons SET lesson_order = 300 WHERE slug = 'too-good-to-be-true';
UPDATE lessons SET lesson_order = 301 WHERE slug = 'check-ojk-license';
UPDATE lessons SET lesson_order = 302 WHERE slug = 'phishing-social-engineering';
UPDATE lessons SET lesson_order = 303 WHERE slug = 'mlm-pyramid-red-flags';

-- Chapter 04: Debt Management
UPDATE lessons SET lesson_order = 400 WHERE slug = 'debt-traps';
UPDATE lessons SET lesson_order = 401 WHERE slug = 'good-debt-vs-bad-debt';
UPDATE lessons SET lesson_order = 402 WHERE slug = 'why-pay-later-is-bad';
UPDATE lessons SET lesson_order = 403 WHERE slug = 'credit-card-good-or-bad';
UPDATE lessons SET lesson_order = 404 WHERE slug = 'how-to-pay-debt-responsibly';

-- Chapter 05: Financial Planning
UPDATE lessons SET lesson_order = 500 WHERE slug = 'emergency-fund-101';
UPDATE lessons SET lesson_order = 501 WHERE slug = 'goal-setting-101';
UPDATE lessons SET lesson_order = 502 WHERE slug = 'building-financial-plan';

-- Chapter 06: Grow Your Money (interest, investing basics)
UPDATE lessons SET lesson_order = 600 WHERE slug = 'compound-interest-101';
UPDATE lessons SET lesson_order = 601 WHERE slug = 'bank-vs-investment';
UPDATE lessons SET lesson_order = 602 WHERE slug = 'risk-return-101';
UPDATE lessons SET lesson_order = 603 WHERE slug = 'diversification-101';
UPDATE lessons SET lesson_order = 604 WHERE slug = 'reksa-dana-basics';

-- Chapter 07: Investing in Indonesia
UPDATE lessons SET lesson_order = 700 WHERE slug = 'what-is-a-stock';
UPDATE lessons SET lesson_order = 701 WHERE slug = 'idx-basics-101';
UPDATE lessons SET lesson_order = 702 WHERE slug = 'reading-a-stock-page';
UPDATE lessons SET lesson_order = 703 WHERE slug = 'portfolio-thinking';
UPDATE lessons SET lesson_order = 704 WHERE slug = 'taxes-on-returns';
UPDATE lessons SET lesson_order = 705 WHERE slug = 'macro-indicators';

-- Chapter 08: Cryptocurrency
UPDATE lessons SET lesson_order = 800 WHERE slug = 'what-is-cryptocurrency';
UPDATE lessons SET lesson_order = 801 WHERE slug = 'crypto-risks-scams-indonesia';
UPDATE lessons SET lesson_order = 802 WHERE slug = 'how-to-buy-crypto-safely';
UPDATE lessons SET lesson_order = 803 WHERE slug = 'crypto-vs-investing-vs-gambling';

-- Advanced lessons (keep unpublished, high lesson_order)
UPDATE lessons SET lesson_order = 900 WHERE slug = 'loss-aversion-101';
UPDATE lessons SET lesson_order = 901 WHERE slug = 'confidence-101';
UPDATE lessons SET lesson_order = 902 WHERE slug = 'volatility-101';
UPDATE lessons SET lesson_order = 903 WHERE slug = 'inflation-advanced';
UPDATE lessons SET lesson_order = 904 WHERE slug = 'budgeting-advanced';
UPDATE lessons SET lesson_order = 905 WHERE slug = 'risk_return-advanced';
UPDATE lessons SET lesson_order = 906 WHERE slug = 'idx_basics-advanced';
UPDATE lessons SET lesson_order = 907 WHERE slug = 'behavioral_finance-advanced';
