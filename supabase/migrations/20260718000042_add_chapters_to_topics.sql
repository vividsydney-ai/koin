-- Add chapter grouping to topics
-- Chapters make the curriculum feel bite-sized and fun instead of a flat list.

alter table topics add column chapter text;

comment on column topics.chapter is 'Chapter grouping used by the Learn page curriculum UI.';

-- Assign existing topics to chapters. Slugs verified against production on 2026-07-18.
-- Extra topics not in the original brief (money_basics, inflation, budgeting, risk_return, idx_basics)
-- are placed in the semantically closest chapter. The topic too-good-to-be-true does not exist in
-- the database; its lesson lives under the scam_defense topic.

update topics set chapter = 'Money Basics' where slug in (
  'foundation_zero',
  'money_basics',
  'value_purchasing_power',
  'inflation',
  'income_wealth',
  'assets_liabilities',
  'risk_basics',
  'time_value_money'
);

update topics set chapter = 'Protect Yourself' where slug in (
  'scam_defense',
  'ojk_license_check',
  'phishing_social_engineering',
  'mlm_pyramid'
);

update topics set chapter = 'Grow Your Money' where slug in (
  'interest',
  'compound_interest',
  'bank_vs_investment',
  'risk_return',
  'diversification',
  'reksa_dana'
);

update topics set chapter = 'Investing in Indonesia' where slug in (
  'stocks',
  'idx_basics',
  'stock_analysis',
  'portfolio',
  'taxes',
  'macro_indicators'
);

update topics set chapter = 'Money Life Skills' where slug in (
  'emergency_fund',
  'saving_habits',
  'budgeting',
  'spending_behavior',
  'debt_management',
  'goal_setting',
  'behavioral_finance',
  'financial_planning'
);
