-- KO-225: restore English quiz payloads for two lessons whose `quiz_data`
-- was populated with the Indonesian payload. Keep quiz_data_id Indonesian.

UPDATE public.lessons
SET quiz_data = $$[
  {
    "type": "multiple_choice",
    "answer": "3–6 months",
    "options": ["1 month", "3–6 months", "12 months", "An emergency fund is not needed"],
    "question": "How many months of regular expenses are commonly recommended for an emergency fund?",
    "difficulty": "beginner",
    "parameters": {},
    "explanation": "A common rule of thumb is to keep three to six months of regular expenses, adjusted for income stability and dependents."
  },
  {
    "type": "true_false",
    "answer": false,
    "question": "An emergency fund can be kept in stocks for higher potential returns.",
    "difficulty": "beginner",
    "parameters": {},
    "explanation": "Stocks can fluctuate and fall when an emergency occurs. Keep emergency savings in a safe, liquid instrument instead."
  },
  {
    "type": "multiple_choice",
    "answer": "Avoid selling investments during an emergency",
    "options": ["Guarantee that investments always gain value", "Avoid selling investments during an emergency", "Replace life insurance", "Increase deposit returns"],
    "question": "Why is it important to build an emergency fund before investing?",
    "difficulty": "beginner",
    "parameters": {},
    "explanation": "An emergency fund means you do not have to liquidate investments when the market is unfavorable."
  }
]$$::jsonb
WHERE slug = 'emergency-fund-101' AND is_published = TRUE;

UPDATE public.lessons
SET quiz_data = $$[
  {
    "type": "multiple_choice",
    "answer": "Reduce portfolio risk",
    "options": ["Guarantee high returns", "Reduce portfolio risk", "Avoid taxes", "Predict which stock will rise"],
    "question": "The main purpose of diversification is to ...",
    "difficulty": "beginner",
    "parameters": {},
    "explanation": "Diversification spreads risk so that one asset's loss has less impact on the overall portfolio."
  },
  {
    "type": "multiple_choice",
    "answer": "Stocks from different sectors, such as banking and telecommunications",
    "options": ["Only one technology stock", "Stocks from different sectors, such as banking and telecommunications", "Keeping only cash", "Borrowing money to trade"],
    "question": "An example of diversification on the IDX is buying ...",
    "difficulty": "beginner",
    "parameters": {},
    "explanation": "Sector diversification reduces the impact if one industry declines."
  },
  {
    "type": "multiple_choice",
    "answer": "Spread investments across different instruments",
    "options": ["Put all money in one asset", "Spread investments across different instruments", "Never invest", "Follow the latest trend"],
    "question": "Diversification means ...",
    "difficulty": "beginner",
    "parameters": {},
    "explanation": "Diversification is the strategy of spreading investments so you do not depend on one instrument."
  }
]$$::jsonb
WHERE slug = 'diversification-101' AND is_published = TRUE;
