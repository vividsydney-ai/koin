-- KO-49: Allow up to 3 financial goals during onboarding
-- Convert profiles.financial_goal from TEXT to TEXT[] with max-3 constraint.

ALTER TABLE profiles
  ADD COLUMN financial_goals TEXT[];

UPDATE profiles
  SET financial_goals = ARRAY[financial_goal]
  WHERE financial_goal IS NOT NULL;

ALTER TABLE profiles
  DROP COLUMN financial_goal;

ALTER TABLE profiles
  RENAME COLUMN financial_goals TO financial_goal;

ALTER TABLE profiles
  ADD CONSTRAINT financial_goal_max_3 CHECK (array_length(financial_goal, 1) <= 3);

-- Note: RLS and policies for profiles remain unchanged.
