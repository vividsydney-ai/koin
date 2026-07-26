-- Migration: Separate Foundation 0 into its own chapter
-- Date: 2026-07-26
-- Purpose: Split Foundation 0 from Chapter 01 (Money Basics) into Chapter 00 (Foundation)
--          to reduce lesson count in Chapter 01 and provide clear prerequisite track

-- Update foundation_zero topic to use "Foundation" chapter instead of "Money Basics"
UPDATE topics
SET chapter = 'Foundation'
WHERE slug = 'foundation_zero';

-- Update display_order to ensure Foundation appears first
-- Shift all existing chapters down by 1 to make room for Foundation at position 0
UPDATE topics
SET display_order = display_order + 10
WHERE chapter IN ('Money Basics', 'Money Life Skills', 'Protect Yourself', 'Let''s Talk About Debt', 'Plan Your Money', 'Grow Your Money', 'Investing in Indonesia', 'Cryptocurrency 101');

-- Set Foundation chapter to position 0
UPDATE topics
SET display_order = 0
WHERE slug = 'foundation_zero';

-- Add Foundation to the chapter list in the Learn page (if using hardcoded list)
-- This is handled in the frontend code, not in this migration
