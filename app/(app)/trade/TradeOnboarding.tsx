"use client";

import { useState } from "react";
import { completeTradeOnboarding, saveRiskProfile, type RiskProfile } from "@/lib/trading/onboarding";

const TOTAL_STEPS = 8;

interface TradeOnboardingProps {
  userId: string;
  onComplete: () => void;
  onClose?: () => void;
}

export default function TradeOnboarding({ userId, onComplete, onClose }: TradeOnboardingProps) {
  const [step, setStep] = useState(1);
  const [riskAnswers, setRiskAnswers] = useState<Record<number, number>>({});
  const [submitting, setSubmitting] = useState(false);

  const handleNext = () => {
    if (step < TOTAL_STEPS) {
      setStep(step + 1);
    }
  };

  const handleBack = () => {
    if (step > 1) {
      setStep(step - 1);
    }
  };

  const handleRiskAnswer = (questionIndex: number, score: number) => {
    setRiskAnswers((prev) => ({ ...prev, [questionIndex]: score }));
  };

  const riskScore = Object.values(riskAnswers).reduce((sum, s) => sum + s, 0);

  const getRiskLabel = (score: number): RiskProfile["riskLabel"] => {
    if (score <= 5) return "conservative";
    if (score <= 8) return "moderate";
    if (score <= 11) return "growth";
    return "aggressive";
  };

  const handleFinish = async () => {
    setSubmitting(true);
    try {
      await saveRiskProfile(userId, {
        riskScore,
        riskLabel: getRiskLabel(riskScore),
      });
      await completeTradeOnboarding(userId);
      onComplete();
    } catch (e) {
      console.error(e);
    } finally {
      setSubmitting(false);
    }
  };

  const isLastStep = step === TOTAL_STEPS;
  const canProceed = step !== 7 || Object.keys(riskAnswers).length === RISK_QUESTIONS.length;

  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center bg-background/90 p-4 backdrop-blur-sm sm:items-center">
      <div className="w-full max-w-md overflow-hidden rounded-radius-lg bg-surface shadow-xl">
        <div className="border-b border-muted px-5 py-4">
          <div className="flex items-center justify-between">
            <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
              Paper Trading Onboarding
            </p>
            <div className="flex items-center gap-3">
              <p className="text-xs text-muted-foreground">
                {step} / {TOTAL_STEPS}
              </p>
              {onClose && (
                <button
                  onClick={onClose}
                  className="text-xs font-semibold text-muted-foreground hover:text-foreground"
                  aria-label="Close onboarding"
                >
                  Close
                </button>
              )}
            </div>
          </div>
          <div className="mt-2.5 flex gap-1.5">
            {Array.from({ length: TOTAL_STEPS }).map((_, i) => (
              <div
                key={i}
                className={`h-1 flex-1 rounded-full transition-all ${
                  i < step ? "bg-primary" : "bg-muted"
                }`}
              />
            ))}
          </div>
        </div>

        <div className="max-h-[70vh] overflow-y-auto px-5 py-6">
          {step === 1 && <WelcomeStep />}
          {step === 2 && <StocksStep />}
          {step === 3 && <LotStep />}
          {step === 4 && <OrderStep />}
          {step === 5 && <RiskStep />}
          {step === 6 && <BudgetStep />}
          {step === 7 && (
            <RiskQuizStep answers={riskAnswers} onAnswer={handleRiskAnswer} />
          )}
          {step === 8 && <FinishStep riskScore={riskScore} riskLabel={getRiskLabel(riskScore)} />}
        </div>

        <div className="border-t border-muted px-5 py-4">
          <div className="flex gap-3">
            {step > 1 && (
              <button
                onClick={handleBack}
                className="rounded-radius-md border border-muted bg-surface px-4 py-3 text-sm font-semibold text-foreground transition-colors hover:bg-muted/10"
              >
                Back
              </button>
            )}
            <button
              onClick={isLastStep ? handleFinish : handleNext}
              disabled={!canProceed || submitting}
              className="flex-1 rounded-radius-md bg-primary py-3 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
            >
              {submitting
                ? "Saving..."
                : isLastStep
                  ? "Start trading"
                  : "Continue"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

function WelcomeStep() {
  return (
    <div className="space-y-4 text-center">
      <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 text-2xl">
        📈
      </div>
      <h2 className="text-xl font-bold text-foreground">Welcome to Paper Trading</h2>
      <p className="text-sm leading-relaxed text-muted-foreground">
        Before you buy and sell stocks with Koin, let's cover the basics: what stocks are, how the
        Indonesian stock market works, and how to manage risk so you don't gamble money you can't
        afford to lose.
      </p>
      <p className="text-sm leading-relaxed text-muted-foreground">
        This is practice money. The goal is to learn, not to get rich overnight.
      </p>
    </div>
  );
}

function StocksStep() {
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-foreground">What is a stock?</h2>
      <p className="text-sm leading-relaxed text-muted-foreground">
        A stock (saham) is a small ownership slice of a company. When you buy 1 lot of BBCA, you own
        a tiny piece of Bank Central Asia. If the company grows and earns more, the stock price may
        go up. If it struggles, the price may go down.
      </p>
      <div className="rounded-radius-md bg-muted p-3 text-sm text-foreground">
        <strong>Key terms</strong>
        <ul className="mt-2 list-disc space-y-1 pl-4 text-muted-foreground">
          <li>
            <strong>IDX</strong> — Bursa Efek Indonesia, the national stock exchange.
          </li>
          <li>
            <strong>Ticker</strong> — Short code for a stock, like BBCA, BBRI, TLKM, GOTO, UNVR.
          </li>
          <li>
            <strong>Share</strong> — One unit of ownership.
          </li>
          <li>
            <strong>Dividend</strong> — A share of company profit paid to owners.
          </li>
        </ul>
      </div>
    </div>
  );
}

function LotStep() {
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-foreground">Lots and board lots</h2>
      <p className="text-sm leading-relaxed text-muted-foreground">
        On IDX, stocks are traded in lots. <strong>1 lot = 100 shares.</strong> You cannot buy a
        single share; you must buy in multiples of 100.
      </p>
      <div className="rounded-radius-md bg-primary/5 p-3 text-sm text-foreground">
        <strong>Example</strong>
        <p className="mt-1 text-muted-foreground">
          If BBCA is priced at Rp 8,650 per share, then 1 lot costs Rp 865,000. If you buy 2 lots,
          you pay Rp 1,730,000 and own 200 shares.
        </p>
      </div>
      <p className="text-sm leading-relaxed text-muted-foreground">
        This is why starting with a paper portfolio of Rp 10,000,000 matters — it teaches you to
        think in position sizes, not just share counts.
      </p>
    </div>
  );
}

function OrderStep() {
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-foreground">Buy vs. Sell orders</h2>
      <p className="text-sm leading-relaxed text-muted-foreground">
        A <strong>buy</strong> order turns cash into stocks. A <strong>sell</strong> order turns
        stocks back into cash. In this app, orders are executed at the latest closing price for
        simplicity.
      </p>
      <div className="rounded-radius-md bg-muted p-3 text-sm text-foreground">
        <strong>Order tips</strong>
        <ul className="mt-2 list-disc space-y-1 pl-4 text-muted-foreground">
          <li>Check how much cash you have before buying.</li>
          <li>You can only sell stocks you already own.</li>
          <li>Prices change daily — yesterday's price may not be today's price.</li>
          <li>Don't put all your money in one stock.</li>
        </ul>
      </div>
    </div>
  );
}

function RiskStep() {
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-foreground">Risk and diversification</h2>
      <p className="text-sm leading-relaxed text-muted-foreground">
        All investing involves risk. Higher potential returns usually mean higher risk. The safest
        way to reduce risk is <strong>diversification</strong> — spreading your money across
        different companies and industries.
      </p>
      <div className="rounded-radius-md bg-warning/5 p-3 text-sm text-warning">
        <strong>Common mistakes</strong>
        <ul className="mt-2 list-disc space-y-1 pl-4">
          <li>Investing money you need for daily expenses.</li>
          <li>Buying a stock just because a friend or influencer mentioned it.</li>
          <li>Panicking and selling as soon as the price drops.</li>
          <li>Putting everything in one stock.</li>
        </ul>
      </div>
    </div>
  );
}

function BudgetStep() {
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-foreground">Budgeting and savings first</h2>
      <p className="text-sm leading-relaxed text-muted-foreground">
        Real investing should only happen after you have covered your needs, built an emergency
        fund, and paid off high-interest debt. Paper trading is a safe way to practice, but the
        habit matters: never trade with money you cannot afford to lose.
      </p>
      <div className="rounded-radius-md bg-muted p-3 text-sm text-foreground">
        <strong>Healthy order</strong>
        <ol className="mt-2 list-decimal space-y-1 pl-4 text-muted-foreground">
          <li>Cover needs and emergencies.</li>
          <li>Save regularly, even if small.</li>
          <li>Learn with paper trading.</li>
          <li>Only then consider real investing with money you can leave invested long-term.</li>
        </ol>
      </div>
    </div>
  );
}

const RISK_QUESTIONS = [
  {
    question: "If your paper portfolio lost 10% in one week, what would you do?",
    options: [
      { label: "Sell everything immediately", score: 1 },
      { label: "Wait and watch closely", score: 2 },
      { label: "Buy more if the reason still makes sense", score: 3 },
    ],
  },
  {
    question: "How would you divide Rp 10,000,000 in paper money?",
    options: [
      { label: "Keep it all in cash", score: 1 },
      { label: "Mostly safe stocks, a little in growth stocks", score: 2 },
      { label: "Spread across several industries, some higher risk", score: 3 },
      { label: "Mostly high-growth stocks", score: 4 },
    ],
  },
  {
    question: "How long are you comfortable leaving money invested?",
    options: [
      { label: "Less than a year", score: 1 },
      { label: "1–3 years", score: 2 },
      { label: "3–5 years", score: 3 },
      { label: "5 years or more", score: 4 },
    ],
  },
  {
    question: "What matters most to you right now?",
    options: [
      { label: "Not losing money", score: 1 },
      { label: "Steady, modest growth", score: 2 },
      { label: "Growth with some ups and downs", score: 3 },
      { label: "Maximum growth, accepting big swings", score: 4 },
    ],
  },
];

function RiskQuizStep({
  answers,
  onAnswer,
}: {
  answers: Record<number, number>;
  onAnswer: (index: number, score: number) => void;
}) {
  return (
    <div className="space-y-5">
      <div>
        <h2 className="text-xl font-bold text-foreground">Risk profile quiz</h2>
        <p className="mt-1 text-sm text-muted-foreground">
          Answer honestly. There are no right answers — only answers that match how you think about
          money and risk.
        </p>
      </div>

      {RISK_QUESTIONS.map((q, i) => (
        <div key={i} className="space-y-2">
          <p className="text-sm font-semibold text-foreground">
            {i + 1}. {q.question}
          </p>
          <div className="space-y-2">
            {q.options.map((opt) => (
              <button
                key={opt.label}
                onClick={() => onAnswer(i, opt.score)}
                className={`w-full rounded-radius-md border px-3 py-2.5 text-left text-sm transition-colors ${
                  answers[i] === opt.score
                    ? "border-primary bg-primary/10 text-primary"
                    : "border-muted bg-background text-foreground hover:border-primary/40"
                }`}
              >
                {opt.label}
              </button>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}

function FinishStep({ riskScore, riskLabel }: { riskScore: number; riskLabel: string }) {
  const labelText: Record<string, string> = {
    conservative: "Conservative — safety first",
    moderate: "Moderate — balanced growth",
    growth: "Growth — comfortable with swings",
    aggressive: "Aggressive — high growth, high risk",
  };

  return (
    <div className="space-y-4 text-center">
      <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-success/10 text-2xl">
        🎓
      </div>
      <h2 className="text-xl font-bold text-foreground">You're ready to practice</h2>
      <p className="text-sm leading-relaxed text-muted-foreground">
        Your paper portfolio starts with Rp 10,000,000. Use it to experiment, learn from mistakes,
        and build good habits before investing real money.
      </p>
      <div className="rounded-radius-md bg-primary/5 p-3 text-sm text-foreground">
        <p className="font-semibold">Your risk profile</p>
        <p className="mt-1 capitalize text-muted-foreground">
          {labelText[riskLabel] ?? riskLabel} (score: {riskScore})
        </p>
      </div>
      <p className="text-xs text-muted-foreground">
        You can replay this onboarding anytime from the Trade tab.
      </p>
    </div>
  );
}
