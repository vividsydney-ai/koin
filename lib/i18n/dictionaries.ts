import type { Locale } from "./types";

export interface Dictionary {
  // Bottom navigation
  "nav.home": string;
  "nav.learn": string;
  "nav.trade": string;
  "nav.friends": string;
  "nav.library": string;
  "nav.profile": string;

  // Auth
  "auth.loading": string;
  "auth.loadingErrorTitle": string;
  "auth.retry": string;
  "auth.goToSignIn": string;

  // Lesson player chrome
  "lesson.step.intro": string;
  "lesson.step.concept": string;
  "lesson.step.example": string;
  "lesson.step.quiz": string;
  "lesson.step.source": string;
  "lesson.lessonWord": string;
  "lesson.of": string;
  "lesson.exit": string;
  "lesson.continue": string;
  "lesson.finish": string;
  "lesson.loading": string;
  "lesson.loadError": string;
  "lesson.errorTitle": string;
  "lesson.tryAgain": string;
  "lesson.backToLearn": string;
  "lesson.notFoundTitle": string;
  "lesson.notFoundBody": string;
  "lesson.completionError": string;
  "lesson.errorTooFast": string;
  "lesson.minutes": string;
  "lesson.theConcept": string;
  "lesson.theIdea": string;
  "lesson.simplerExplanation": string;
  "lesson.backToMainExplanation": string;
  "lesson.indonesianExample": string;
  "lesson.exampleHeading": string;
  "lesson.realExample": string;
  "lesson.seeAnotherExample": string;
  "lesson.backToMainExample": string;
  "lesson.commonMistake": string;
  "lesson.whyItMatters": string;
  "lesson.tryThis": string;
  "lesson.quickCheck": string;
  "lesson.quizHeading": string;
  "lesson.tryAnotherQuestion": string;
  "lesson.noQuestionAvailable": string;
  "lesson.sourceTrust": string;
  "lesson.sourceHeading": string;
  "lesson.sourceBody": string;
  "lesson.noSources": string;
  "lesson.primarySource": string;
  "lesson.supportingSources": string;
  "lesson.furtherReading": string;
  "lesson.complete": string;
  "lesson.tier": string;
  "lesson.verified": string;
  "lesson.needsReview": string;
  "lesson.readSource": string;
  "sources.readOnWikipedia": string;
  "sources.originalUnavailable": string;
  "lesson.quizBonus": string;
  "lesson.streak": string;
  "lesson.baseXp": string;
  "lesson.badgeEarned": string;
  "lesson.nextLesson": string;
  "lesson.replayNotice": string;
  "lesson.replayCompleteTitle": string;
  "lesson.noNewXp": string;
  "lesson.alreadyEarned": string;
  "lesson.alreadyEarnedValue": string;
  "lesson.chapterLabel": string;
  "lesson.chapterCompleteTitle": string;
  "lesson.chapterCompleteBody": string;
  "lesson.chapterCompleteFinalBody": string;
  "lesson.chapterCompleteContinue": string;
  "learn.missionRequired": string;
  "learn.startMission": string;
  "learn.missionComplete": string;
  "mission.kicker": string;
  "mission.title": string;
  "mission.body": string;
  "mission.nextCheck": string;
  "mission.checkProgress": string;
  "mission.passTitle": string;
  "mission.passBody": string;
  "mission.retryTitle": string;
  "mission.retryBody": string;
  "mission.retry": string;
  "mission.backToLearn": string;
  "mission.locked": string;
  "mission.loadError": string;

  // Daily Focus
  "focus.restingTitle": string;
  "focus.restingBody": string;
  "focus.backHome": string;
  "focus.kicker": string;
  "focus.title": string;
  "focus.subtitle": string;
  "focus.howItWorks": string;
  "focus.yourFocus": string;
  "focus.wrongAnswer": string;
  "focus.progressAria": string;
  "focus.complete": string;
  "focus.question": string;
  "focus.correctCount": string;
  "focus.check": string;
  "focus.correctFeedback": string;
  "focus.incorrectFeedback": string;
  "focus.nextQuestion": string;
  "focus.selectAll": string;
  "focus.weeklyMissions": string;
  "focus.fourthUnlocked": string;
  "focus.missionsCompleted": string;
  "focus.missionsBody": string;
  "focus.exhaustedTitle": string;
  "focus.exhaustedBody": string;
  "focus.refill": string;
  "focus.refilling": string;
  "focus.refillUsed": string;
  "focus.continueLearning": string;
  "focus.completeTitle": string;
  "focus.completeBody": string;
  "focus.fourthReady": string;
  "focus.pipsRemaining": string;
  "focus.answerError": string;
  "focus.refillError": string;

  // Quiz engine
  "quiz.correctAnswer": string;
  "quiz.chartCheck": string;
  "quiz.chartPracticeLabel": string;
  "quiz.chartPracticeCaption": string;
  "quiz.true": string;
  "quiz.false": string;
  "quiz.yes": string;
  "quiz.no": string;
  "quiz.checkAnswer": string;
  "quiz.typeAnswer": string;
  "quiz.chooseAnswer": string;
  "quiz.tapTwoItems": string;
  "quiz.tapDefinition": string;
  "quiz.notSupported": string;

  // Home page
  "home.greeting": string;
  "home.share": string;
  "home.streak.label": string;
  "home.streak.keepLearning": string;
  "home.streak.broken": string;
  "home.streak.frozen": string;
  "home.streak.atRisk": string;
  "home.continueLesson": string;
  "home.startTodaysLesson": string;
  "home.allLessonsCompleted": string;
  "home.allLessonsCompletedBody": string;
  "home.browseLibrary": string;
  "home.level": string;
  "home.totalXp": string;
  "home.nextLevel": string;
  "home.xpProgress": string;
  "home.koinPoints": string;
  "home.koinPointsBody": string;
  "home.noBadges": string;
  "home.noBadgesBody": string;
  "home.startLearning": string;
  "home.latestBadge": string;
  "home.portfolio": string;
  "home.startPaperTrading": string;
  "home.portfolioEmptyBody": string;
  "home.goToTrade": string;
  "home.weeklyLeaderboard": string;
  "home.weeklyXp": string;
  "home.noFriendsOnBoard": string;
  "home.inviteFriendsBody": string;
  "home.inviteFriends": string;
  "home.recommendedForYou": string;
  "home.dismissRecommendation": string;
  "home.chapterLessonLabel": string;

  // Learn page
  "learn.title": string;
  "learn.subtitle": string;
  "learn.startLesson": string;
  "learn.startSideQuest": string;
  "learn.sideQuest": string;
  "learn.goalBody": string;
  "learn.needFoundation": string;
  "learn.readyForMore": string;
  "learn.startFrom": string;
  "learn.foundationPath": string;
  "learn.tailoredPath": string;
  "learn.completedOf": string;
  "learn.minutesShort": string;

  // Chapter titles (mapped from DB English titles)
  "chapter.foundation": string;
  "chapter.moneyBasics": string;
  "chapter.moneyLifeSkills": string;
  "chapter.protectYourself": string;
  "chapter.letsTalkAboutDebt": string;
  "chapter.planYourMoney": string;
  "chapter.growYourMoney": string;
  "chapter.investingInIndonesia": string;
  "chapter.cryptocurrency101": string;
  "chapter.readingTradingCharts": string;
  "chapter.decisionAnalysisLab": string;
  "chapter.uncategorized": string;

  // Profile page
  "profile.loading": string;
  "profile.edit": string;
  "profile.streak": string;
  "profile.paperPortfolio": string;
  "profile.totalValue": string;
  "profile.cash": string;
  "profile.return": string;
  "profile.noPortfolio": string;
  "profile.badges": string;
  "profile.logout": string;
  "profile.replayOnboarding": string;
  "profile.xp": string;
  "profile.koin": string;
  "profile.noBadgesYet": string;
  "profile.noBadgesBody": string;
  "profile.startLearning": string;

  // Settings section
  "settings.title": string;
  "settings.language": string;

  // Friends / leaderboard
  "friends.you": string;
  "friends.inviteTitle": string;
  "friends.inviteBody": string;
  "friends.share": string;
  "friends.scanQr": string;
  "friends.copyLink": string;
  "friends.linkCopied": string;
  "friends.acceptTitle": string;
  "friends.acceptBody": string;
  "friends.acceptButton": string;
  "friends.accepted": string;
  "friends.requestSent": string;
  "friends.userNotFound": string;
  "friends.cohorts": string;
  "friends.createCohort": string;
  "friends.cohortName": string;
  "friends.create": string;
  "friends.created": string;
  "friends.cohortLimitFree": string;
  "friends.upgradeToPro": string;
  "friends.joinCohort": string;
  "friends.cohortCode": string;
  "friends.join": string;
  "friends.cohortNotFound": string;
  "friends.alreadyMember": string;
  "friends.joinedCohort": string;
  "friends.friendsTitle": string;
  "friends.pending": string;
  "friends.requestSentStatus": string;
  "friends.requestReceived": string;
  "friends.friend": string;
  "friends.weeklyLeaderboard": string;
  "friends.scanQrTitle": string;
  "friends.close": string;
  "friends.pasteInviteLink": string;
  "friends.add": string;
  "friends.creating": string;
  "friends.cancel": string;
  "friends.joinedAt": string;
  "friends.cameraNotAvailable": string;
  "friends.cameraError": string;
  "friends.createError": string;
  "friends.copyInviteCode": string;
  "friends.copyInviteLink": string;
  "friends.inviteLinkCopied": string;
  "friends.inviteFriend": string;
  "friends.inviteFriendToCohort": string;
  "friends.cohortLimitPro": string;
  "friends.invitedFriend": string;
  "friends.alreadyInCohort": string;
  "friends.inviteError": string;

  // Trade / price chart
  "trade.simulatedPrices": string;
  "trade.simulatedBody": string;

  // Library filters
  "library.allSources": string;
  "library.allTiers": string;
  "library.allTypes": string;
  "library.allLanguages": string;

  // Library source card
  "library.synopsis": string;
  "library.relevance": string;
  "library.readMore": string;
  "library.showLess": string;

  // Badges
  "profile.locked": string;
  "profile.keepLearning": string;
}

// Note: a few lesson-player strings were originally Indonesian in the old
// mixed-language UI ("Lihat contoh lain" etc.). Per product direction, "en"
// is fully English and "id" is fully Indonesian — each locale is consistent.
export const dictionaries: Record<Locale, Dictionary> = {
  en: {
    "nav.home": "Home",
    "nav.learn": "Learn",
    "nav.trade": "Trade",
    "nav.friends": "Friends",
    "nav.library": "Library",
    "nav.profile": "Profile",

    "auth.loading": "Loading…",
    "auth.loadingErrorTitle": "Sign-in check timed out",
    "auth.retry": "Try again",
    "auth.goToSignIn": "Go to sign in",

    "lesson.step.intro": "Intro",
    "lesson.step.concept": "Concept",
    "lesson.step.example": "Example",
    "lesson.step.quiz": "Quiz",
    "lesson.step.source": "Source",
    "lesson.lessonWord": "Lesson",
    "lesson.of": "of",
    "lesson.exit": "Exit",
    "lesson.continue": "Continue",
    "lesson.finish": "Finish lesson",
    "lesson.loading": "Loading lesson…",
    "lesson.loadError": "We couldn't load this lesson. Please try again.",
    "lesson.errorTitle": "Something went wrong",
    "lesson.tryAgain": "Try again",
    "lesson.backToLearn": "Back to Learn",
    "lesson.notFoundTitle": "Lesson not found",
    "lesson.notFoundBody": "This topic is not available yet.",
    "lesson.completionError":
      "We couldn't save your progress. Please check your connection and try again.",
    "lesson.errorTooFast":
      "Please spend at least a few more moments on this lesson before finishing.",
    "lesson.minutes": "minutes",
    "lesson.theConcept": "The concept",
    "lesson.theIdea": "The idea",
    "lesson.simplerExplanation": "Simpler explanation",
    "lesson.backToMainExplanation": "Back to main explanation",
    "lesson.indonesianExample": "Indonesian example",
    "lesson.exampleHeading": "How this plays out",
    "lesson.realExample": "Real example",
    "lesson.seeAnotherExample": "See another example",
    "lesson.backToMainExample": "Back to main example",
    "lesson.commonMistake": "Common mistake",
    "lesson.whyItMatters": "Why it matters",
    "lesson.tryThis": "Try this",
    "lesson.quickCheck": "Quick check",
    "lesson.quizHeading": "Test your understanding",
    "lesson.tryAnotherQuestion": "Try another question",
    "lesson.noQuestionAvailable": "No question is available for this lesson.",
    "lesson.sourceTrust": "Source trust",
    "lesson.sourceHeading": "Where this comes from",
    "lesson.sourceBody":
      "Koin only teaches from licensed Indonesian regulators and verified institutions. If you see unsourced advice, question it.",
    "lesson.noSources": "No source listed for this lesson.",
    "lesson.primarySource": "Primary source",
    "lesson.supportingSources": "Supporting sources",
    "lesson.furtherReading": "Further reading",
    "lesson.complete": "Lesson complete",
    "lesson.tier": "Tier",
    "lesson.verified": "Verified",
    "lesson.needsReview": "Needs review",
    "lesson.readSource": "Read source",
    "sources.readOnWikipedia": "Read on Wikipedia",
    "sources.originalUnavailable": "Original link unavailable",
    "lesson.quizBonus": "Includes +{bonus} quiz bonus",
    "lesson.streak": "Streak",
    "lesson.baseXp": "Base XP",
    "lesson.badgeEarned": "Badge earned",
    "lesson.nextLesson": "Next lesson",
    "lesson.replayNotice":
      "You've already completed this lesson. Replaying is great practice, but you won't earn XP again.",
    "lesson.replayCompleteTitle": "Practice complete",
    "lesson.noNewXp": "No new XP — you already earned the XP for this lesson.",
    "lesson.alreadyEarned": "Already earned",
    "lesson.alreadyEarnedValue": "0",
    "lesson.chapterLabel": "Chapter {chapterNumber} · Lesson {lessonNumber} of {total}",
    "lesson.chapterCompleteTitle": "Chapter {chapterNumber} complete!",
    "lesson.chapterCompleteBody": "Chapter {nextChapterNumber} is now unlocked.",
    "lesson.chapterCompleteFinalBody": "You have completed every chapter.",
    "lesson.chapterCompleteContinue": "Keep going",
    "learn.missionRequired": "Complete the Money Mission to unlock the next chapter.",
    "learn.startMission": "Start Money Mission",
    "learn.missionComplete": "Money Mission complete",
    "mission.kicker": "Money Mission",
    "mission.title": "Show what you know",
    "mission.body": "Three chapter questions. Get them all right to unlock what is next. You can retry whenever you like.",
    "mission.nextCheck": "Next check",
    "mission.checkProgress": "Check {current} of {total}",
    "mission.passTitle": "Chapter {chapterNumber} complete!",
    "mission.passBody": "Your next chapter is now unlocked.",
    "mission.retryTitle": "Almost there",
    "mission.retryBody": "Review the explanations, then try another set whenever you are ready.",
    "mission.retry": "Try again",
    "mission.backToLearn": "Back to Learn",
    "mission.locked": "Finish every lesson in this chapter before starting its Money Mission.",
    "mission.loadError": "We could not prepare your Money Mission. Please try again.",

    "focus.restingTitle": "Daily Focus is resting",
    "focus.restingBody": "We could not load today’s challenge. Please try again in a moment.",
    "focus.backHome": "Back home",
    "focus.kicker": "Optional daily practice",
    "focus.title": "Daily Focus",
    "focus.subtitle": "Five quick money checks. Lessons always stay unlimited.",
    "focus.howItWorks": "How Daily Focus works",
    "focus.yourFocus": "Your Focus",
    "focus.wrongAnswer": "A wrong answer uses one. Core lessons never do.",
    "focus.progressAria": "Daily Focus question progress",
    "focus.complete": "Complete",
    "focus.question": "Question",
    "focus.correctCount": "correct",
    "focus.check": "Focus check",
    "focus.correctFeedback": "Nice work — your Focus is intact.",
    "focus.incorrectFeedback": "Not quite — one Focus was used.",
    "focus.nextQuestion": "Next question",
    "focus.selectAll": "Select all that apply:",
    "focus.weeklyMissions": "Weekly Money Missions",
    "focus.fourthUnlocked": "Fourth Focus unlocked",
    "focus.missionsCompleted": "completed",
    "focus.missionsBody": "Finish Daily Focus five times in one local week to permanently gain a fourth Focus.",
    "focus.exhaustedTitle": "Focus spent for today",
    "focus.exhaustedBody": "You can return tomorrow, or use your one optional refill. Your lessons are still open anytime.",
    "focus.refill": "Refill Focus · 50 Koin Points",
    "focus.refilling": "Refilling…",
    "focus.refillUsed": "Today’s refill has already been used.",
    "focus.continueLearning": "Continue learning",
    "focus.completeTitle": "Focus complete",
    "focus.completeBody": "You earned 20 Koin Points and completed one Money Mission. Come back tomorrow for a new set.",
    "focus.fourthReady": "Your fourth Focus is ready for tomorrow.",
    "focus.pipsRemaining": "{remaining} of {max} Focus remaining",
    "focus.answerError": "We could not record that answer. Please try again.",
    "focus.refillError": "We could not refill Focus right now.",

    "quiz.correctAnswer": "Correct answer:",
    "quiz.chartCheck": "Chart check",
    "quiz.chartPracticeLabel": "Practice candlestick chart",
    "quiz.chartPracticeCaption": "Practice data only — not a price forecast.",
    "quiz.true": "True",
    "quiz.false": "False",
    "quiz.yes": "Yes",
    "quiz.no": "No",
    "quiz.checkAnswer": "Check answer",
    "quiz.typeAnswer": "Type your answer",
    "quiz.chooseAnswer": "Choose the best answer",
    "quiz.tapTwoItems": "Tap two items to swap their positions.",
    "quiz.tapDefinition": "Tap a definition to match it with each term.",
    "quiz.notSupported": "This question type ({type}) is not supported yet.",

    "home.greeting": "Good to see you,",
    "home.share": "Share",
    "home.streak.label": "Streak",
    "home.streak.keepLearning": "Keep learning daily to build it.",
    "home.streak.broken": "Streak lost. Start a new one today!",
    "home.streak.frozen": "Freeze used — you're still in the game.",
    "home.streak.atRisk": "Complete a lesson today to keep it alive.",
    "home.continueLesson": "Continue lesson",
    "home.startTodaysLesson": "Start today's lesson",
    "home.allLessonsCompleted": "All lessons completed",
    "home.allLessonsCompletedBody":
      "You've finished every available lesson. Check the Library for more trusted sources, or replay a favorite lesson.",
    "home.browseLibrary": "Browse Library",
    "home.level": "Level",
    "home.totalXp": "{xp} Lifetime XP",
    "home.nextLevel": "Next: {name}",
    "home.xpProgress": "{current} / {target} XP",
    "home.koinPoints": "Koin Points",
    "home.koinPointsBody": "Earn more by ranking up.",
    "home.noBadges": "No badges yet",
    "home.noBadgesBody":
      "Finish a lesson, hit a streak, or make your first trade to earn your first badge.",
    "home.startLearning": "Start learning",
    "home.latestBadge": "Latest badge",
    "home.portfolio": "Portfolio",
    "home.startPaperTrading": "Start paper trading",
    "home.portfolioEmptyBody":
      "Your portfolio snapshot will appear here once you unlock paper trading from the Trade tab.",
    "home.goToTrade": "Go to Trade",
    "home.weeklyLeaderboard": "Weekly leaderboard",
    "home.weeklyXp": "Weekly XP",
    "home.noFriendsOnBoard": "No friends on the board",
    "home.inviteFriendsBody":
      "Invite friends to see who tops the weekly XP and Koin Points boards.",
    "home.inviteFriends": "Invite friends",
    "home.recommendedForYou": "Recommended for you",
    "home.dismissRecommendation": "Dismiss recommendation",
    "home.chapterLessonLabel": "Chapter {chapterNumber} | Lesson {lessonNumber}",

    "learn.title": "Learn",
    "learn.subtitle": "Bite-sized money lessons, one concept at a time.",
    "learn.startLesson": "Start lesson",
    "learn.startSideQuest": "Start side quest",
    "learn.sideQuest": "Side quest",
    "learn.goalBody":
      "This lesson supports one of the financial goals you chose during onboarding.",
    "learn.needFoundation": "You need to strengthen the basics",
    "learn.readyForMore": "You're ready for more",
    "learn.startFrom": "Start from {title}",
    "learn.foundationPath":
      "Based on your assessment, we'll start with the most basic money concepts.",
    "learn.tailoredPath":
      "Based on your assessment, you can start from the lesson that fits you best.",
    "learn.completedOf": "{completed} of {total} completed",
    "learn.minutesShort": "min",

    "chapter.foundation": "Foundation",
    "chapter.moneyBasics": "Money Basics",
    "chapter.moneyLifeSkills": "Money Life Skills",
    "chapter.protectYourself": "Protect Yourself",
    "chapter.letsTalkAboutDebt": "Let's Talk About Debt",
    "chapter.planYourMoney": "Plan Your Money",
    "chapter.growYourMoney": "Grow Your Money",
    "chapter.investingInIndonesia": "Investing in Indonesia",
    "chapter.cryptocurrency101": "Cryptocurrency 101",
    "chapter.readingTradingCharts": "Reading Trading Charts",
    "chapter.decisionAnalysisLab": "Decision Analysis Lab",
    "chapter.uncategorized": "Uncategorized",

    "profile.loading": "Loading profile…",
    "profile.edit": "Edit",
    "profile.streak": "Streak",
    "profile.paperPortfolio": "Paper Portfolio",
    "profile.totalValue": "Total value",
    "profile.cash": "Cash",
    "profile.return": "Return",
    "profile.noPortfolio": "No portfolio yet. Start paper trading from the Trade tab.",
    "profile.badges": "Badges",
    "profile.logout": "Log out",
    "profile.replayOnboarding": "Replay onboarding",
    "profile.xp": "Lifetime XP",
    "profile.koin": "Koin",
    "profile.noBadgesYet": "No badges yet",
    "profile.noBadgesBody":
      "Complete lessons, hit streaks, and make your first trade to earn badges.",
    "profile.startLearning": "Start learning",

    "settings.title": "Settings",
    "settings.language": "Language",

    "friends.you": "You",
    "friends.inviteTitle": "Invite friends",
    "friends.inviteBody": "Share your card so friends can add you on Koin.",
    "friends.share": "Share",
    "friends.scanQr": "Scan QR",
    "friends.copyLink": "Copy invite link",
    "friends.linkCopied": "Invite link copied!",
    "friends.acceptTitle": "Add friend",
    "friends.acceptBody": "wants to learn with you on Koin.",
    "friends.acceptButton": "Accept friend request",
    "friends.accepted": "You're now friends!",
    "friends.requestSent": "Friend request sent.",
    "friends.userNotFound": "User not found. The invite link may be invalid.",
    "friends.cohorts": "Cohorts",
    "friends.createCohort": "Create a cohort",
    "friends.cohortName": "Cohort name",
    "friends.create": "Create",
    "friends.created": "Cohort created",
    "friends.cohortLimitFree":
      "Free users can create 1 cohort. Upgrade to Pro to create more.",
    "friends.upgradeToPro": "Upgrade to Pro",
    "friends.joinCohort": "Join a cohort",
    "friends.cohortCode": "Cohort code",
    "friends.join": "Join",
    "friends.cohortNotFound": "Cohort not found. Check the code and try again.",
    "friends.alreadyMember": "You're already in this cohort.",
    "friends.joinedCohort": "Joined!",
    "friends.friendsTitle": "Friends",
    "friends.pending": "Pending",
    "friends.requestSentStatus": "Request sent",
    "friends.requestReceived": "Request received",
    "friends.friend": "Friend",
    "friends.weeklyLeaderboard": "Weekly leaderboard",
    "friends.scanQrTitle": "Scan friend's QR",
    "friends.close": "Close",
    "friends.pasteInviteLink": "Or paste invite link",
    "friends.add": "Add",
    "friends.creating": "Creating…",
    "friends.cancel": "Cancel",
    "friends.joinedAt": "Joined {date}",
    "friends.cameraNotAvailable": "Camera not available in this browser. You can enter an invite link below.",
    "friends.cameraError": "Could not access camera. You can enter an invite link below.",
    "friends.createError": "Could not create cohort. Try again.",
    "friends.copyInviteCode": "Copy invite code",
    "friends.copyInviteLink": "Copy invite link",
    "friends.inviteLinkCopied": "Invite link copied!",
    "friends.inviteFriend": "Invite friend",
    "friends.inviteFriendToCohort": "Invite friend to cohort",
    "friends.cohortLimitPro": "Pro users can create up to 10 cohorts.",
    "friends.invitedFriend": "Invited!",
    "friends.alreadyInCohort": "Already in this cohort.",
    "friends.inviteError": "Could not invite friend. Try again.",

    "trade.simulatedPrices": "Simulated prices",
    "trade.simulatedBody":
      "some data points are generated when official IDX data is unavailable. For paper-trading practice only.",
    "library.allSources": "All sources",
    "library.allTiers": "All tiers",
    "library.allTypes": "All types",
    "library.allLanguages": "All languages",
    "library.synopsis": "What this source covers",
    "library.relevance": "Why it matters to you",
    "library.readMore": "See summary",
    "library.showLess": "Show less",
    "profile.locked": "Locked",
    "profile.keepLearning": "Keep learning to unlock.",
  },
  id: {
    "nav.home": "Beranda",
    "nav.learn": "Belajar",
    "nav.trade": "Trading",
    "nav.friends": "Teman",
    "nav.library": "Pustaka",
    "nav.profile": "Profil",

    "auth.loading": "Memuat…",
    "auth.loadingErrorTitle": "Pemeriksaan masuk habis waktu",
    "auth.retry": "Coba lagi",
    "auth.goToSignIn": "Ke halaman masuk",

    "lesson.step.intro": "Intro",
    "lesson.step.concept": "Konsep",
    "lesson.step.example": "Contoh",
    "lesson.step.quiz": "Kuis",
    "lesson.step.source": "Sumber",
    "lesson.lessonWord": "Pelajaran",
    "lesson.of": "dari",
    "lesson.exit": "Keluar",
    "lesson.continue": "Lanjut",
    "lesson.finish": "Selesaikan pelajaran",
    "lesson.loading": "Memuat pelajaran…",
    "lesson.loadError": "Kami tidak dapat memuat pelajaran ini. Silakan coba lagi.",
    "lesson.errorTitle": "Terjadi kesalahan",
    "lesson.tryAgain": "Coba lagi",
    "lesson.backToLearn": "Kembali ke Belajar",
    "lesson.notFoundTitle": "Pelajaran tidak ditemukan",
    "lesson.notFoundBody": "Topik ini belum tersedia.",
    "lesson.completionError":
      "Kami tidak dapat menyimpan progresmu. Periksa koneksimu dan coba lagi.",
    "lesson.errorTooFast":
      "Silakan luangkan waktu sebentar lagi untuk pelajaran ini sebelum menyelesaikannya.",
    "lesson.minutes": "menit",
    "lesson.theConcept": "Konsepnya",
    "lesson.theIdea": "Intinya",
    "lesson.simplerExplanation": "Penjelasan lebih sederhana",
    "lesson.backToMainExplanation": "Kembali ke penjelasan utama",
    "lesson.indonesianExample": "Contoh Indonesia",
    "lesson.exampleHeading": "Begini penerapannya",
    "lesson.realExample": "Contoh nyata",
    "lesson.seeAnotherExample": "Lihat contoh lain",
    "lesson.backToMainExample": "Kembali ke contoh utama",
    "lesson.commonMistake": "Kesalahan umum",
    "lesson.whyItMatters": "Mengapa penting",
    "lesson.tryThis": "Coba ini",
    "lesson.quickCheck": "Cek cepat",
    "lesson.quizHeading": "Uji pemahamanmu",
    "lesson.tryAnotherQuestion": "Coba soal lain",
    "lesson.noQuestionAvailable": "Belum ada soal untuk pelajaran ini.",
    "lesson.sourceTrust": "Keandalan sumber",
    "lesson.sourceHeading": "Dari mana asalnya",
    "lesson.sourceBody":
      "Koin hanya mengajar dari regulator Indonesia berlisensi dan institusi terverifikasi. Jika kamu melihat saran tanpa sumber, pertanyakan.",
    "lesson.noSources": "Belum ada sumber untuk pelajaran ini.",
    "lesson.primarySource": "Sumber utama",
    "lesson.supportingSources": "Sumber pendukung",
    "lesson.furtherReading": "Bacaan lanjutan",
    "lesson.complete": "Pelajaran selesai",
    "lesson.tier": "Tingkat",
    "lesson.verified": "Terverifikasi",
    "lesson.needsReview": "Perlu ditinjau",
    "lesson.readSource": "Baca sumber",
    "sources.readOnWikipedia": "Baca di Wikipedia",
    "sources.originalUnavailable": "Tautan asli tidak tersedia",
    "lesson.quizBonus": "Termasuk +{bonus} bonus kuis",
    "lesson.streak": "Streak",
    "lesson.baseXp": "XP dasar",
    "lesson.badgeEarned": "Lencana didapat",
    "lesson.nextLesson": "Pelajaran berikutnya",
    "lesson.replayNotice":
      "Kamu sudah menyelesaikan pelajaran ini. Mengulang bagus untuk latihan, tapi XP tidak bertambah lagi.",
    "lesson.replayCompleteTitle": "Latihan selesai",
    "lesson.noNewXp": "Tidak ada XP baru — kamu sudah mendapat XP untuk pelajaran ini.",
    "lesson.alreadyEarned": "Sudah didapat",
    "lesson.alreadyEarnedValue": "0",
    "lesson.chapterLabel": "Bab {chapterNumber} · Pelajaran {lessonNumber} dari {total}",
    "lesson.chapterCompleteTitle": "Bab {chapterNumber} selesai!",
    "lesson.chapterCompleteBody": "Bab {nextChapterNumber} sekarang terbuka.",
    "lesson.chapterCompleteFinalBody": "Kamu telah menyelesaikan semua bab.",
    "lesson.chapterCompleteContinue": "Lanjutkan",
    "learn.missionRequired": "Selesaikan Misi Uang untuk membuka bab berikutnya.",
    "learn.startMission": "Mulai Misi Uang",
    "learn.missionComplete": "Misi Uang selesai",
    "mission.kicker": "Misi Uang",
    "mission.title": "Tunjukkan yang kamu pahami",
    "mission.body": "Tiga soal bab. Jawab semuanya benar untuk membuka langkah berikutnya. Kamu boleh mencoba lagi kapan pun.",
    "mission.nextCheck": "Soal berikutnya",
    "mission.checkProgress": "Soal {current} dari {total}",
    "mission.passTitle": "Bab {chapterNumber} selesai!",
    "mission.passBody": "Bab berikutnya sekarang terbuka.",
    "mission.retryTitle": "Hampir berhasil",
    "mission.retryBody": "Tinjau penjelasannya, lalu coba set soal lain saat kamu siap.",
    "mission.retry": "Coba lagi",
    "mission.backToLearn": "Kembali ke Belajar",
    "mission.locked": "Selesaikan semua pelajaran dalam bab ini sebelum memulai Misi Uang.",
    "mission.loadError": "Kami belum bisa menyiapkan Misi Uangmu. Coba lagi.",

    "focus.restingTitle": "Daily Focus sedang beristirahat",
    "focus.restingBody": "Kami tidak dapat memuat tantangan hari ini. Coba lagi sebentar lagi.",
    "focus.backHome": "Kembali ke beranda",
    "focus.kicker": "Latihan harian opsional",
    "focus.title": "Daily Focus",
    "focus.subtitle": "Lima cek singkat tentang uang. Pelajaran tetap bisa diulang tanpa batas.",
    "focus.howItWorks": "Cara kerja Daily Focus",
    "focus.yourFocus": "Focus kamu",
    "focus.wrongAnswer": "Jawaban salah memakai satu Focus. Pelajaran utama tidak pernah menguranginya.",
    "focus.progressAria": "Progres pertanyaan Daily Focus",
    "focus.complete": "Selesai",
    "focus.question": "Pertanyaan",
    "focus.correctCount": "benar",
    "focus.check": "Cek Focus",
    "focus.correctFeedback": "Mantap — Focus kamu tetap utuh.",
    "focus.incorrectFeedback": "Belum tepat — satu Focus terpakai.",
    "focus.nextQuestion": "Pertanyaan berikutnya",
    "focus.selectAll": "Pilih semua yang benar:",
    "focus.weeklyMissions": "Misi Uang Mingguan",
    "focus.fourthUnlocked": "Focus keempat terbuka",
    "focus.missionsCompleted": "selesai",
    "focus.missionsBody": "Selesaikan Daily Focus lima kali dalam satu minggu lokal untuk mendapatkan Focus keempat secara permanen.",
    "focus.exhaustedTitle": "Focus hari ini sudah habis",
    "focus.exhaustedBody": "Kamu bisa kembali besok, atau memakai satu kali isi ulang opsional. Pelajaran tetap bisa dipelajari kapan saja.",
    "focus.refill": "Isi ulang Focus · 50 Koin Points",
    "focus.refilling": "Mengisi ulang…",
    "focus.refillUsed": "Isi ulang hari ini sudah digunakan.",
    "focus.continueLearning": "Lanjut belajar",
    "focus.completeTitle": "Focus selesai",
    "focus.completeBody": "Kamu mendapatkan 20 Koin Points dan menyelesaikan satu Misi Uang. Kembali besok untuk set pertanyaan baru.",
    "focus.fourthReady": "Focus keempatmu siap digunakan besok.",
    "focus.pipsRemaining": "{remaining} dari {max} Focus tersisa",
    "focus.answerError": "Kami tidak dapat mencatat jawaban itu. Coba lagi.",
    "focus.refillError": "Kami tidak dapat mengisi ulang Focus sekarang.",

    "quiz.correctAnswer": "Jawaban benar:",
    "quiz.chartCheck": "Cek grafik",
    "quiz.chartPracticeLabel": "Grafik candlestick untuk latihan",
    "quiz.chartPracticeCaption": "Data latihan saja — bukan perkiraan harga.",
    "quiz.true": "Benar",
    "quiz.false": "Salah",
    "quiz.yes": "Ya",
    "quiz.no": "Tidak",
    "quiz.checkAnswer": "Periksa jawaban",
    "quiz.typeAnswer": "Ketik jawabanmu",
    "quiz.chooseAnswer": "Pilih jawaban yang paling tepat",
    "quiz.tapTwoItems": "Ketuk dua item untuk menukar posisinya.",
    "quiz.tapDefinition": "Ketuk definisi untuk mencocokkannya dengan setiap istilah.",
    "quiz.notSupported": "Tipe soal ({type}) belum didukung.",

    "home.greeting": "Senang melihatmu,",
    "home.share": "Bagikan",
    "home.streak.label": "Streak",
    "home.streak.keepLearning": "Terus belajar setiap hari untuk membangunnya.",
    "home.streak.broken": "Streak hilang. Mulai yang baru hari ini!",
    "home.streak.frozen": "Beku digunakan — kamu masih dalam permainan.",
    "home.streak.atRisk": "Selesaikan pelajaran hari ini untuk menjaganya.",
    "home.continueLesson": "Lanjutkan pelajaran",
    "home.startTodaysLesson": "Mulai pelajaran hari ini",
    "home.allLessonsCompleted": "Semua pelajaran selesai",
    "home.allLessonsCompletedBody":
      "Kamu sudah menyelesaikan semua pelajaran yang tersedia. Cek Pustaka untuk sumber tepercaya lainnya, atau ulangi pelajaran favoritmu.",
    "home.browseLibrary": "Jelajahi Pustaka",
    "home.level": "Level",
    "home.totalXp": "{xp} XP sepanjang masa",
    "home.nextLevel": "Berikutnya: {name}",
    "home.xpProgress": "{current} / {target} XP",
    "home.koinPoints": "Poin Koin",
    "home.koinPointsBody": "Dapatkan lebih banyak dengan naik level.",
    "home.noBadges": "Belum ada lencana",
    "home.noBadgesBody":
      "Selesaikan pelajaran, jaga streak, atau lakukan transaksi pertama untuk mendapatkan lencana pertamamu.",
    "home.startLearning": "Mulai belajar",
    "home.latestBadge": "Lencana terbaru",
    "home.portfolio": "Portofolio",
    "home.startPaperTrading": "Mulai trading simulasi",
    "home.portfolioEmptyBody":
      "Snapshot portofoliomu akan muncul di sini setelah kamu membuka kunci trading simulasi dari tab Trading.",
    "home.goToTrade": "Ke Trading",
    "home.weeklyLeaderboard": "Papan peringkat mingguan",
    "home.weeklyXp": "XP minggu ini",
    "home.noFriendsOnBoard": "Belum ada teman di papan peringkat",
    "home.inviteFriendsBody":
      "Undang teman untuk melihat siapa yang memuncaki papan XP dan Poin Koin mingguan.",
    "home.inviteFriends": "Undang teman",
    "home.recommendedForYou": "Direkomendasikan untukmu",
    "home.dismissRecommendation": "Tutup rekomendasi",
    "home.chapterLessonLabel": "Bab {chapterNumber} | Pelajaran {lessonNumber}",

    "learn.title": "Belajar",
    "learn.subtitle": "Pelajaran uang ringkas, satu konsep dalam satu waktu.",
    "learn.startLesson": "Mulai pelajaran",
    "learn.startSideQuest": "Mulai misi tambahan",
    "learn.sideQuest": "Misi tambahan",
    "learn.goalBody":
      "Pelajaran ini mendukung salah satu tujuan finansial yang kamu pilih saat onboarding.",
    "learn.needFoundation": "Kamu perlu memperkuat dasar",
    "learn.readyForMore": "Kamu sudah paham dasar",
    "learn.startFrom": "Mulai dari {title}",
    "learn.foundationPath":
      "Berdasarkan hasil asesmenmu, kami akan mulai dari konsep keuangan paling dasar terlebih dahulu.",
    "learn.tailoredPath":
      "Berdasarkan hasil asesmen, kamu bisa langsung mulai dari pelajaran yang paling sesuai.",
    "learn.completedOf": "{completed} dari {total} selesai",
    "learn.minutesShort": "mnt",

    "chapter.foundation": "Fondasi",
    "chapter.moneyBasics": "Dasar Uang",
    "chapter.moneyLifeSkills": "Keterampilan Keuangan",
    "chapter.protectYourself": "Lindungi Diri",
    "chapter.letsTalkAboutDebt": "Mari Bicara tentang Utang",
    "chapter.planYourMoney": "Rencanakan Uangmu",
    "chapter.growYourMoney": "Kembangkan Uangmu",
    "chapter.investingInIndonesia": "Berinvestasi di Indonesia",
    "chapter.cryptocurrency101": "Dasar-Dasar Kripto",
    "chapter.readingTradingCharts": "Membaca Grafik Trading",
    "chapter.decisionAnalysisLab": "Lab Analisis Keputusan",
    "chapter.uncategorized": "Tidak Berkategori",

    "profile.loading": "Memuat profil…",
    "profile.edit": "Ubah",
    "profile.streak": "Streak",
    "profile.paperPortfolio": "Portofolio Simulasi",
    "profile.totalValue": "Nilai total",
    "profile.cash": "Kas",
    "profile.return": "Imbal hasil",
    "profile.noPortfolio": "Belum ada portofolio. Mulai trading simulasi dari tab Trading.",
    "profile.badges": "Lencana",
    "profile.logout": "Keluar",
    "profile.replayOnboarding": "Ulangi pengenalan",
    "profile.xp": "XP sepanjang masa",
    "profile.koin": "Koin",
    "profile.noBadgesYet": "Belum ada lencana",
    "profile.noBadgesBody":
      "Selesaikan pelajaran, jaga streak, dan lakukan transaksi pertama untuk mendapatkan lencana.",
    "profile.startLearning": "Mulai belajar",

    "settings.title": "Pengaturan",
    "settings.language": "Bahasa",

    "friends.you": "Kamu",
    "friends.inviteTitle": "Undang teman",
    "friends.inviteBody": "Bagikan kartumu agar teman bisa menambahkanmu di Koin.",
    "friends.share": "Bagikan",
    "friends.scanQr": "Pindai QR",
    "friends.copyLink": "Salin tautan undangan",
    "friends.linkCopied": "Tautan undangan disalin!",
    "friends.acceptTitle": "Tambah teman",
    "friends.acceptBody": "ingin belajar bersamamu di Koin.",
    "friends.acceptButton": "Terima undangan teman",
    "friends.accepted": "Kalian sekarang berteman!",
    "friends.requestSent": "Undangan teman terkirim.",
    "friends.userNotFound": "Pengguna tidak ditemukan. Tautan undangan mungkin tidak valid.",
    "friends.cohorts": "Kelompok",
    "friends.createCohort": "Buat kelompok",
    "friends.cohortName": "Nama kelompok",
    "friends.create": "Buat",
    "friends.created": "Kelompok dibuat",
    "friends.cohortLimitFree":
      "Pengguna gratis bisa membuat 1 kelompok. Upgrade ke Pro untuk membuat lebih banyak.",
    "friends.upgradeToPro": "Upgrade ke Pro",
    "friends.joinCohort": "Gabung kelompok",
    "friends.cohortCode": "Kode kelompok",
    "friends.join": "Gabung",
    "friends.cohortNotFound": "Kelompok tidak ditemukan. Periksa kode dan coba lagi.",
    "friends.alreadyMember": "Kamu sudah bergabung di kelompok ini.",
    "friends.joinedCohort": "Bergabung!",
    "friends.friendsTitle": "Teman",
    "friends.pending": "Menunggu",
    "friends.requestSentStatus": "Permintaan terkirim",
    "friends.requestReceived": "Permintaan diterima",
    "friends.friend": "Teman",
    "friends.weeklyLeaderboard": "Papan peringkat mingguan",
    "friends.scanQrTitle": "Pindai QR teman",
    "friends.close": "Tutup",
    "friends.pasteInviteLink": "Atau tempel tautan undangan",
    "friends.add": "Tambah",
    "friends.creating": "Membuat…",
    "friends.cancel": "Batal",
    "friends.joinedAt": "Bergabung {date}",
    "friends.cameraNotAvailable": "Kamera tidak tersedia di browser ini. Kamu bisa memasukkan tautan undangan di bawah.",
    "friends.cameraError": "Tidak dapat mengakses kamera. Kamu bisa memasukkan tautan undangan di bawah.",
    "friends.createError": "Tidak dapat membuat kelompok. Coba lagi.",
    "friends.copyInviteCode": "Salin kode undangan",
    "friends.copyInviteLink": "Salin tautan undangan",
    "friends.inviteLinkCopied": "Tautan undangan disalin!",
    "friends.inviteFriend": "Undang teman",
    "friends.inviteFriendToCohort": "Undang teman ke kelompok",
    "friends.cohortLimitPro": "Pengguna Pro bisa membuat hingga 10 kelompok.",
    "friends.invitedFriend": "Diundang!",
    "friends.alreadyInCohort": "Sudah di kelompok ini.",
    "friends.inviteError": "Tidak dapat mengundang teman. Coba lagi.",

    "trade.simulatedPrices": "Harga simulasi",
    "trade.simulatedBody":
      "beberapa titik data dibuat saat data resmi IDX tidak tersedia. Hanya untuk latihan paper trading.",
    "library.allSources": "Semua sumber",
    "library.allTiers": "Semua tingkat",
    "library.allTypes": "Semua tipe",
    "library.allLanguages": "Semua bahasa",
    "library.synopsis": "Apa yang dibahas sumber ini",
    "library.relevance": "Mengapa ini penting bagimu",
    "library.readMore": "Lihat ringkasan",
    "library.showLess": "Tampilkan lebih sedikit",
    "profile.locked": "Terkunci",
    "profile.keepLearning": "Terus belajar untuk membuka.",
  },
};
