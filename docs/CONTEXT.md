# Koinaku Domain Model

**Purpose:** Ubiquitous language for the Koinaku financial literacy app. This file defines what each domain term means, what it is *not*, and the invariants that must hold. It contains no implementation details.

---

## Core Identity

### User
A person who has signed up for Koinaku. A User has one Profile and one UserSettings record.

- A User must have a unique email.
- A User may be 16–30 years old (stretch: 16+).
- A User owns exactly one Portfolio in the paper trading sandbox.

### Profile
The public-facing identity of a User: display name, username, avatar, age range.

- A username is unique and URL-safe.
- A display name is shown to friends and on leaderboards.

### UserSettings
Per-user configuration and learning state: notification preferences, risk tolerance, foundation-zero requirement, starting lesson.

- `foundation_zero_required` is set by the Financial Literacy Assessment and may change if the user retakes the assessment.
- `starting_lesson_id` points to the first Lesson the User sees after onboarding.

---

## Learning Domain

### Financial Literacy Assessment
A short quiz taken during onboarding that measures baseline knowledge across foundation topics.

- The Assessment produces a score from 0 to N.
- The score determines whether the User starts with Foundation 0 or the Main Track.
- Each wrong answer may generate a Remediation Lesson.

### Foundation 0 Track
A sequence of micro-lessons that teach pure financial terms before the Main Track.

- Every new User with a low assessment score must complete Foundation 0 before accessing the Main Track.
- Foundation 0 Lessons are shorter and more term-focused than Main Track Lessons.

### Main Track
The 32-lesson foundation-first curriculum: Value & Purchasing Power → Investing Fundamentals.

- Main Track Lessons are ordered by `lesson_number` within their Topic.
- A User progresses sequentially unless unlocked by a remedial or adaptive recommendation.

### Topic
A thematic bucket for Lessons: e.g., Foundation 0, Behavior & Habits, Scam Defense, Wealth Building.

- A Topic has a display order.
- A Lesson belongs to exactly one Topic.

### Lesson
A single learnable unit: concept card, example, quiz, source trust section.

- A Lesson is either in Foundation 0 or the Main Track.
- A Lesson is published only when it has at least one Tier 1 Source, one approved LessonReview, and all source URLs are verified.
- A Lesson has one or more Content Variants.

### LessonVersion
A snapshot of a Lesson at a point in time. Used for review and rollback.

- A published Lesson has at least one approved LessonVersion.

### Content Variant
A distinct example, question, or explanation for a Lesson.

- Example Variants provide Indonesian-context scenarios.
- Question Variants provide quiz questions of a specific Question Type.
- A User should not see the same Variant again within a 7-day cooldown.

### Question Type
The format of a quiz question: multiple_choice, true_false, fill_blank, word_bank, ordering, matching, case_study.

- A Lesson should use at least two Question Types to reduce monotony.
- Slider and swipe_yes_no are planned but not part of the MVP domain.

### Source
A verifiable citation for a Lesson: regulator document, book, article, or media.

- Tier 1 Sources (OJK, BI, IDX) are required for publication.
- Tier 2 Sources (OECD, World Bank, books) enrich credibility.
- Tier 3 Sources (curated creators) are engagement-only and never sufficient alone.

### LessonReview
An approval record confirming a Lesson is accurate, sourced, and publishable.

- A Lesson cannot be published without `approved_to_publish = true`.
- A LessonReview is attributed to a reviewer (human or agent).

### LessonAttempt
A record of a User starting a Lesson.

### LessonProgress
A record of a User completing a Lesson, including score and XP earned.

### UserMastery
A score indicating how well a User understands a Topic.

- Mastery increases with correct answers and decreases with incorrect answers.
- Mastery may unlock advanced Lessons or trigger remedial recommendations.

### Remediation Lesson
A targeted micro-lesson generated when a User answers an assessment or quiz question incorrectly.

- A Remediation Lesson maps to a specific Foundation 0 Lesson.
- Remediation Lessons appear in the User's Learn tab until completed.

---

## Gamification Domain

### Daily Active Learning Session
The North Star Metric: one Lesson completion OR one Trade per User per day.

### Streak
The count of consecutive days a User has had at least one Daily Active Learning Session.

- A Streak increments when a User has a session on a new calendar day.
- A Streak resets to zero if a day is missed and no Streak Freeze is available.
- A Streak Freeze can preserve a Streak for one missed day.

### StreakEvent
A record of a streak increment, freeze use, or streak loss.

### XP
Experience points awarded for learning and trading actions.

- XP is awarded for lesson completion, quiz bonuses, streak milestones, and first trade.
- XP is not subtracted.

### Level
A milestone reached by accumulating XP.

- Each Level has an XP threshold.
- Level 1 is the starting Level.

### Badge
A recognition earned for achievements: first trade, streak milestones, graduation.

- Badges are trigger-based, not purchasable.

### Koin Point
In-app currency earned through streaks and lesson completion.

- Koin Points have no real-world value.
- Koin Points are not transferable between Users.
- A spend path is designed post-MVP.

---

## Paper Trading Domain

### Portfolio
A User's simulated investment account.

- A Portfolio starts with Rp 10.000.000 virtual capital.
- A Portfolio's value is the sum of cash + market value of Holdings.

### Holding
A position in a single stock within a Portfolio.

- A Holding has a quantity and average buy price.
- Holdings are lot-based (100 shares per lot).

### Trade
A simulated buy or sell transaction.

- A Trade is either `buy` or `sell`.
- A Trade executes at the latest Market Data price.
- A Trade updates the Portfolio and Holdings.

### Market Data
A snapshot of a stock's price at a point in time.

- Market Data is updated daily for curated IDX stocks.
- Prices are used for trade execution and portfolio valuation.

### Watchlist
A User's list of stocks they are monitoring.

### Risk Profile
A classification of a User's risk tolerance.

- The Risk Profile is set during onboarding and can be updated.
- It informs paper trading guidance but never provides investment advice.

---

## Graduation Domain

### Graduation
The state when a User's Portfolio value reaches 3x–5x of starting capital.

- Graduation is verified before a Certificate is issued.
- Graduation unlocks brokerage referral content.

### Certificate
A shareable proof of graduation.

- A Certificate is issued only after verified Graduation.

### Brokerage Recommendation
A neutral pointer to OJK-registered brokers.

- A Brokerage Recommendation is not investment advice.
- Language must be neutral: "OJK-registered" not "recommended."

---

## Social Domain

### Friendship
A mutual connection between two Users.

- Friendships enable leaderboards and social accountability.

### Friend Invite
A code or link a User shares to invite another person.

### Cohort
A group of Users, typically created for a school or corporate program.

- Cohorts have an invite code.
- Cohort membership may unlock custom leaderboards.

### Leaderboard
A ranked list of Users by XP or Koin Points over a time window.

- Weekly Leaderboards reset every Monday.
- A User sees their own rank plus the top N.

---

## Operations Domain

### Notification Queue
Pending outgoing notifications to a User.

- A Notification can be delivered via email or in-app.
- Web push notifications are not part of the MVP domain.

### Analytics Event
A timestamped record of a User action used for metrics.

- Analytics Events contain no PII beyond User identity.
- Analytics Events are insert-only.

### Content Flag
A User-submitted report of an issue with a Lesson or Source.

- A Content Flag moves through states: open, reviewing, resolved, rejected.

---

## Domain Invariants

1. A published Lesson must have ≥1 Tier 1 Source.
2. A published Lesson must have ≥1 approved LessonReview.
3. Every cited Source URL must be verified reachable.
4. A User's learning data, Portfolio, and Settings are scoped to that User.
5. A Trade never creates or destroys real money.
6. A Certificate is issued only after verified Graduation.
7. Koin Points have no external value or transferability.
8. Brokerage content is neutral and not promotional.
9. Analytics Events contain no PII beyond User identity.
