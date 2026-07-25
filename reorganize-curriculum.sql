-- Migration: Reorganize curriculum structure
-- Deactivate duplicates and renumber lessons

-- Deactivate main track duplicates (Foundation 0 versions are canonical)
UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = '0fa42c9f-66b9-42c1-b622-9f194a505a06'; -- #1 "What Is Money?"
UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = '1be1d991-71c2-4d37-a6db-6658ec89367a'; -- #4 "Income vs Wealth (Main Track)"
UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = 'c08723e0-8b2f-4c86-b24a-3fbc90d78b8f'; -- #5 "Needs vs Wants (Main Track)"
UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = '0c9d741a-7151-4bea-bb7f-152a185efa2a'; -- #6 "Assets vs Liabilities (Main Track)"
UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = 'a3dfa5b3-e967-439f-bf9a-a07d36d1f951'; -- #25 "What Is Interest? (Main Track)"
