import Foundation

// MARK: - HabitTemplate

struct HabitTemplate: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let category: HabitCategory
    let duration: Int
    let difficulty: String
    let whyItMatters: String
    let todayInstruction: String
    let reflectionPrompt: String
    let iconName: String

    init(
        name: String,
        description: String,
        category: HabitCategory,
        duration: Int,
        difficulty: String = "medium",
        whyItMatters: String,
        todayInstruction: String,
        reflectionPrompt: String,
        iconName: String
    ) {
        self.id               = UUID()
        self.name             = name
        self.description      = description
        self.category         = category
        self.duration         = duration
        self.difficulty       = difficulty
        self.whyItMatters     = whyItMatters
        self.todayInstruction = todayInstruction
        self.reflectionPrompt = reflectionPrompt
        self.iconName         = iconName
    }

    func toHabit() -> Habit {
        Habit(
            name:             name,
            habitDescription: description,
            category:         category.rawValue,
            duration:         duration,
            difficulty:       difficulty,
            colorHex:         category.color.hexString,
            iconName:         iconName,
            isFromLibrary:    true,
            whyItMatters:     whyItMatters,
            todayInstruction: todayInstruction,
            reflectionPrompt: reflectionPrompt
        )
    }
}

// MARK: - Library Data

enum HabitLibraryData {

    static let all: [HabitTemplate] =
        mind + body + learning + productivity + communication + purpose + discipline + reflection

    // MARK: Mind

    static let mind: [HabitTemplate] = [
        HabitTemplate(
            name: "5 Minutes of Stillness",
            description: "Sit quietly, close your eyes, and observe your breath.",
            category: .mind, duration: 5,
            whyItMatters: "Training your attention is the foundation of every other skill. Even five minutes daily reduces mental noise over time.",
            todayInstruction: "Find a quiet spot. Set a timer for 5 minutes. Breathe slowly and observe your thoughts without reacting to them.",
            reflectionPrompt: "Did your mind slow down, even briefly?",
            iconName: "brain.head.profile"
        ),
        HabitTemplate(
            name: "Write 3 Thoughts",
            description: "Record three thoughts that are on your mind right now.",
            category: .mind, duration: 5,
            whyItMatters: "Externalizing thoughts frees mental space and reduces anxiety. What's written down no longer occupies background processing.",
            todayInstruction: "Open your journal or a piece of paper. Write three things currently occupying your mind — anything at all.",
            reflectionPrompt: "Do you feel lighter after writing them down?",
            iconName: "pencil.and.outline"
        ),
        HabitTemplate(
            name: "Visualize Today's Goal",
            description: "Spend a few minutes imagining yourself completing your main goal today.",
            category: .mind, duration: 5,
            whyItMatters: "Mental rehearsal primes your brain to recognize and act on opportunities aligned with your goals.",
            todayInstruction: "Close your eyes. Picture yourself successfully completing your most important task today. Feel what it feels like to finish it.",
            reflectionPrompt: "Was the visualization clear and positive?",
            iconName: "eye.fill"
        ),
        HabitTemplate(
            name: "Identify One Limiting Thought",
            description: "Notice one belief that is holding you back and write it down.",
            category: .mind, duration: 5,
            whyItMatters: "Awareness is the first step to change. You cannot replace a thought you have not yet recognized.",
            todayInstruction: "Ask yourself: what is one thought I have repeatedly that slows me down? Write it down without judgment.",
            reflectionPrompt: "Is this thought based on fact, or is it a story you tell yourself?",
            iconName: "exclamationmark.bubble"
        ),
        HabitTemplate(
            name: "Focused Breathing",
            description: "Practice deliberate breathing to reset your nervous system.",
            category: .mind, duration: 5,
            whyItMatters: "Controlled breathing directly regulates your stress response and improves focus and decision-making.",
            todayInstruction: "Inhale for 4 counts, hold for 4 counts, exhale for 6 counts. Repeat 5–8 times.",
            reflectionPrompt: "Did you feel a shift in how calm or focused you are?",
            iconName: "wind"
        )
    ]

    // MARK: Body

    static let body: [HabitTemplate] = [
        HabitTemplate(
            name: "Drink Water First",
            description: "Drink a full glass of water within 10 minutes of waking.",
            category: .body, duration: 2, difficulty: "easy",
            whyItMatters: "Your body is mildly dehydrated after sleep. Hydrating early starts your metabolism and improves morning energy.",
            todayInstruction: "Before coffee, before your phone — drink a full glass (250–500 ml) of water.",
            reflectionPrompt: "Did you notice a difference in your morning energy?",
            iconName: "drop.fill"
        ),
        HabitTemplate(
            name: "20-Minute Walk",
            description: "Walk outside or on a treadmill for at least 20 minutes.",
            category: .body, duration: 20,
            whyItMatters: "Walking clears mental fog, boosts mood through endorphins, and is the most sustainable daily physical activity.",
            todayInstruction: "Put on shoes and walk. No destination required. Do not check your phone.",
            reflectionPrompt: "Did you return feeling clearer than when you left?",
            iconName: "figure.walk"
        ),
        HabitTemplate(
            name: "Workout",
            description: "Complete a structured physical training session.",
            category: .body, duration: 30, difficulty: "hard",
            whyItMatters: "Physical discipline directly builds mental discipline. Exercise is the single most proven intervention for mood, cognition, and longevity.",
            todayInstruction: "Complete your planned workout. If you have no plan, do 20 push-ups, 20 squats, and a 10-minute jog.",
            reflectionPrompt: "Did you push past the first moment of resistance?",
            iconName: "dumbbell.fill"
        ),
        HabitTemplate(
            name: "Stretch for 10 Minutes",
            description: "Spend 10 minutes on full-body stretching.",
            category: .body, duration: 10, difficulty: "easy",
            whyItMatters: "Flexibility and mobility are neglected health markers. Regular stretching reduces injury risk and physical tension caused by stress.",
            todayInstruction: "Focus on hips, shoulders, and spine. Hold each stretch for at least 30 seconds.",
            reflectionPrompt: "Where in your body is most tension held?",
            iconName: "figure.flexibility"
        ),
        HabitTemplate(
            name: "Sleep at a Planned Time",
            description: "Go to bed at the same time as yesterday's plan.",
            category: .body, duration: 0,
            whyItMatters: "Sleep consistency, not just sleep duration, regulates your circadian rhythm and determines energy and mood the next day.",
            todayInstruction: "Set a bedtime alarm 30 minutes before your target sleep time. Begin winding down when it rings.",
            reflectionPrompt: "What are you doing in the final hour before sleep?",
            iconName: "moon.zzz.fill"
        )
    ]

    // MARK: Learning

    static let learning: [HabitTemplate] = [
        HabitTemplate(
            name: "Read 10 Pages",
            description: "Read 10 pages of a meaningful non-fiction or educational book.",
            category: .learning, duration: 15,
            whyItMatters: "Ten pages daily is 3,650 pages per year — roughly 12–18 books. Consistent reading compounds into significant knowledge over time.",
            todayInstruction: "Pick up your book. Read exactly 10 pages — no more pressure than that. Focus on understanding, not speed.",
            reflectionPrompt: "What is the single most useful idea you read today?",
            iconName: "book.fill"
        ),
        HabitTemplate(
            name: "Learn 5 New Words",
            description: "Learn the meaning and usage of 5 words you don't know well.",
            category: .learning, duration: 10, difficulty: "easy",
            whyItMatters: "Vocabulary directly expands your ability to think precisely and communicate with more nuance and authority.",
            todayInstruction: "Look up 5 words. Read their definitions and example sentences. Use one in a sentence you write yourself.",
            reflectionPrompt: "Can you use any of these words naturally in conversation today?",
            iconName: "textformat.abc"
        ),
        HabitTemplate(
            name: "Study One Difficult Concept",
            description: "Pick one topic you find difficult and study it with full attention.",
            category: .learning, duration: 20, difficulty: "hard",
            whyItMatters: "Most people avoid difficulty. Deliberately studying hard concepts builds real expertise and mental resilience.",
            todayInstruction: "Choose one concept you find confusing. Read, watch, or listen to material about it. Take notes in your own words.",
            reflectionPrompt: "Did you move from confused to slightly less confused?",
            iconName: "puzzlepiece.fill"
        ),
        HabitTemplate(
            name: "Teach Something You Learned",
            description: "Explain a concept you recently learned to someone or write it as if explaining to a beginner.",
            category: .learning, duration: 10,
            whyItMatters: "Teaching is the highest form of learning. Explaining an idea forces you to identify and fill your own gaps in understanding.",
            todayInstruction: "Pick something you learned this week. Explain it — out loud, in writing, or to another person — as if they have never heard of it.",
            reflectionPrompt: "Where in the explanation did you hesitate or struggle?",
            iconName: "person.wave.2.fill"
        ),
        HabitTemplate(
            name: "Deliberate Practice Session",
            description: "Practice a specific skill with focused, intentional effort.",
            category: .learning, duration: 20, difficulty: "hard",
            whyItMatters: "Unfocused repetition creates habit, not mastery. Deliberate practice — focused on weaknesses — is how expertise is actually built.",
            todayInstruction: "Choose one skill you are developing. Identify one specific weakness within it. Practice that weakness only, with full attention.",
            reflectionPrompt: "Did you practice your weakness or your strength?",
            iconName: "chart.line.uptrend.xyaxis"
        )
    ]

    // MARK: Productivity

    static let productivity: [HabitTemplate] = [
        HabitTemplate(
            name: "Define Your One Thing",
            description: "Write down the single most important task for today.",
            category: .productivity, duration: 3, difficulty: "easy",
            whyItMatters: "Clarity about your most important task protects you from being busy without being productive. One clear priority outperforms ten vague ones.",
            todayInstruction: "Ask yourself: what is the one thing that, if completed today, would make everything else easier or unnecessary? Write it down.",
            reflectionPrompt: "Did you actually do your One Thing, or did other tasks take over?",
            iconName: "target"
        ),
        HabitTemplate(
            name: "Important Task Before Entertainment",
            description: "Complete one meaningful task before consuming social media or entertainment.",
            category: .productivity, duration: 0,
            whyItMatters: "Willpower and cognitive energy are highest in the morning. Using them first on important work — before depleting them on consumption — produces significantly better output.",
            todayInstruction: "Before you open any social app, video, or podcast today — complete one task from your important list.",
            reflectionPrompt: "How did it feel to make progress before consuming anything?",
            iconName: "clock.badge.checkmark.fill"
        ),
        HabitTemplate(
            name: "25-Minute Focused Block",
            description: "Work on one task for 25 uninterrupted minutes.",
            category: .productivity, duration: 25,
            whyItMatters: "Interruptions fragment attention and require up to 23 minutes to recover from. One uninterrupted block often produces more than three distracted hours.",
            todayInstruction: "Set a 25-minute timer. Close all tabs unrelated to your task. Phone on silent. Work on one thing only until the timer ends.",
            reflectionPrompt: "How many times did you feel the urge to check something else?",
            iconName: "timer"
        ),
        HabitTemplate(
            name: "Eliminate One Unnecessary Task",
            description: "Identify and remove one commitment from your to-do list that doesn't serve your goals.",
            category: .productivity, duration: 5, difficulty: "easy",
            whyItMatters: "Saying no to unimportant tasks is how you protect space for important ones. Every commitment you remove adds capacity.",
            todayInstruction: "Review today's task list. Find one item that could be deleted, delegated, or postponed. Remove it intentionally.",
            reflectionPrompt: "Did removing it create any real problem, or was it never truly important?",
            iconName: "trash.slash.fill"
        ),
        HabitTemplate(
            name: "Plan Tomorrow's Priority",
            description: "Before ending your day, write one priority for tomorrow.",
            category: .productivity, duration: 3, difficulty: "easy",
            whyItMatters: "Ending the day with a clear next priority reduces morning decision fatigue and ensures momentum continues across days.",
            todayInstruction: "Before you close your workspace today, write one sentence: 'Tomorrow, the most important thing is ___.'",
            reflectionPrompt: "Is this truly tomorrow's priority, or just its most urgent task?",
            iconName: "arrow.right.circle.fill"
        )
    ]

    // MARK: Communication

    static let communication: [HabitTemplate] = [
        HabitTemplate(
            name: "Practice Active Listening",
            description: "In one conversation today, focus entirely on understanding — not on responding.",
            category: .communication, duration: 0,
            whyItMatters: "Most people listen to reply. Listening to understand makes people feel respected and produces dramatically better outcomes in relationships and work.",
            todayInstruction: "In your next real conversation, resist the urge to prepare your response while the other person is speaking. Just listen. Ask one follow-up question before sharing your view.",
            reflectionPrompt: "Did you learn something new about the person because you listened more carefully?",
            iconName: "ear.fill"
        ),
        HabitTemplate(
            name: "Maintain Eye Contact",
            description: "Practice comfortable, natural eye contact in one conversation.",
            category: .communication, duration: 0, difficulty: "easy",
            whyItMatters: "Eye contact signals confidence, respect, and presence. People who maintain appropriate eye contact are consistently perceived as more trustworthy and capable.",
            todayInstruction: "In one conversation, consciously maintain comfortable eye contact. Do not stare, but do not look at your phone or away frequently.",
            reflectionPrompt: "Did the quality of the conversation feel different when you were fully present?",
            iconName: "eyes"
        ),
        HabitTemplate(
            name: "Ask One Thoughtful Question",
            description: "Ask a question that goes deeper than small talk.",
            category: .communication, duration: 0, difficulty: "easy",
            whyItMatters: "Thoughtful questions demonstrate genuine curiosity and transform interactions from transactional to meaningful.",
            todayInstruction: "Before your next significant conversation, prepare one question that goes beyond the obvious. Ask it today.",
            reflectionPrompt: "How did the other person respond to a deeper question?",
            iconName: "questionmark.bubble.fill"
        ),
        HabitTemplate(
            name: "Speak With Clarity",
            description: "Practice making your point in fewer, more precise words.",
            category: .communication, duration: 5,
            whyItMatters: "Clarity of expression is a direct reflection of clarity of thinking. Eliminating filler words and vague language makes you a significantly more effective communicator.",
            todayInstruction: "In a meeting or conversation today, make your point in three sentences or fewer. Remove qualifiers like 'kind of', 'sort of', 'maybe'. Be direct.",
            reflectionPrompt: "Did saying less actually communicate more?",
            iconName: "mic.fill"
        ),
        HabitTemplate(
            name: "Observe Body Language",
            description: "Spend a few minutes observing how people express themselves non-verbally.",
            category: .communication, duration: 5, difficulty: "easy",
            whyItMatters: "A significant portion of communication is non-verbal. Developing awareness of body language improves your ability to understand people's true states.",
            todayInstruction: "In one interaction or public setting today, observe posture, gestures, and facial expressions. Notice what they communicate without words.",
            reflectionPrompt: "Did what you observed align with what was said?",
            iconName: "figure.stand"
        )
    ]

    // MARK: Purpose

    static let purpose: [HabitTemplate] = [
        HabitTemplate(
            name: "Write Meaning Into Today",
            description: "Write one sentence about why today's work matters.",
            category: .purpose, duration: 3, difficulty: "easy",
            whyItMatters: "Meaning is not found — it is created. Connecting daily tasks to a larger purpose transforms routine into motivation.",
            todayInstruction: "Write: 'Today's work matters because ___.' Be honest. If you cannot complete the sentence, that is important information.",
            reflectionPrompt: "Did you feel the meaning you wrote, or just write the words?",
            iconName: "star.fill"
        ),
        HabitTemplate(
            name: "Review Your Long-Term Goal",
            description: "Read or rewrite your most important long-term goal.",
            category: .purpose, duration: 3, difficulty: "easy",
            whyItMatters: "Goals that are reviewed regularly stay active in your thinking. Goals that are written once and forgotten fade.",
            todayInstruction: "Read your long-term goal. Ask: what is one thing I can do today that moves in this direction? Do that one thing.",
            reflectionPrompt: "Is this still the right goal, or has your direction shifted?",
            iconName: "scope"
        ),
        HabitTemplate(
            name: "Act on Your Values",
            description: "Identify one action today that is aligned with what you believe in.",
            category: .purpose, duration: 3,
            whyItMatters: "The gap between stated values and daily behavior is the source of much inner conflict. Closing that gap — even slightly — builds integrity.",
            todayInstruction: "Name one of your core values. Name one action today that expresses it. Do that action.",
            reflectionPrompt: "Did your actions today reflect who you say you want to be?",
            iconName: "heart.fill"
        ),
        HabitTemplate(
            name: "Gratitude Practice",
            description: "Write one thing you are genuinely grateful for today.",
            category: .purpose, duration: 3, difficulty: "easy",
            whyItMatters: "Gratitude is not naive optimism. It is the discipline of noticing what is already working, which naturally shifts attention away from scarcity.",
            todayInstruction: "Write one specific thing you are grateful for today. Not abstract — specific. Why does it matter to you?",
            reflectionPrompt: "Did this feel like a genuine recognition, or just an exercise?",
            iconName: "hands.sparkles.fill"
        ),
        HabitTemplate(
            name: "Ask 'Why Am I Doing This?'",
            description: "Pause on your current main activity and ask why you are doing it.",
            category: .purpose, duration: 3,
            whyItMatters: "Awareness of motivation protects you from unconscious autopilot. Knowing your 'why' sustains effort when motivation drops.",
            todayInstruction: "At some point today, stop what you are doing and ask: 'Why am I doing this?' Write your honest answer.",
            reflectionPrompt: "Was the answer satisfying, or did it reveal something you need to reconsider?",
            iconName: "questionmark.circle.fill"
        )
    ]

    // MARK: Discipline

    static let discipline: [HabitTemplate] = [
        HabitTemplate(
            name: "Do One Uncomfortable Task",
            description: "Identify and complete one task you have been avoiding.",
            category: .discipline, duration: 0, difficulty: "hard",
            whyItMatters: "Discomfort avoidance is the primary cause of stagnation. Each time you act despite discomfort, you expand the range of what you can handle.",
            todayInstruction: "Choose the task you are most tempted to avoid. Do it first. Do not negotiate with yourself.",
            reflectionPrompt: "Was the discomfort in anticipation worse than the actual doing?",
            iconName: "flame.fill"
        ),
        HabitTemplate(
            name: "Delay One Impulse",
            description: "When you feel an urge to do something unnecessary, wait before acting on it.",
            category: .discipline, duration: 0,
            whyItMatters: "The space between impulse and action is where self-control lives. Practicing the pause — even once — strengthens that gap.",
            todayInstruction: "When you feel a strong impulse today (to check your phone, eat something unnecessary, procrastinate), wait 10 minutes before acting. Then decide.",
            reflectionPrompt: "Did the urge pass, or did you still act on it after waiting?",
            iconName: "pause.circle.fill"
        ),
        HabitTemplate(
            name: "Keep One Promise to Yourself",
            description: "Make one commitment to yourself this morning and honor it today.",
            category: .discipline, duration: 0,
            whyItMatters: "Self-trust is built by keeping promises to yourself, not just to others. Each broken promise erodes confidence. Each kept promise builds it.",
            todayInstruction: "State one specific promise to yourself this morning: 'Today I will ___.' Make it small enough to guarantee success. Then do it.",
            reflectionPrompt: "Did you keep the promise? If not, what got in the way?",
            iconName: "checkmark.seal.fill"
        ),
        HabitTemplate(
            name: "Avoid One Named Distraction",
            description: "Identify one specific distraction and consciously avoid it today.",
            category: .discipline, duration: 0,
            whyItMatters: "Willpower is not unlimited. Designing your environment to remove specific distractions is more effective than relying on constant resistance.",
            todayInstruction: "Name the one distraction that most reliably pulls you off course. Decide in advance how you will handle it today. Stick to the decision.",
            reflectionPrompt: "Did you avoid it? If not, what triggered the behavior?",
            iconName: "xmark.shield.fill"
        ),
        HabitTemplate(
            name: "Finish What You Started",
            description: "Complete one task today before starting another.",
            category: .discipline, duration: 0,
            whyItMatters: "Half-finished tasks accumulate as mental debt. Completing what you begin — even imperfectly — builds momentum and reduces cognitive load.",
            todayInstruction: "Choose one task on your list and finish it completely before opening anything else. Done and imperfect beats perfect and unfinished.",
            reflectionPrompt: "Did finishing feel different from the usual experience of leaving things incomplete?",
            iconName: "checkmark.rectangle.stack.fill"
        )
    ]

    // MARK: Reflection

    static let reflection: [HabitTemplate] = [
        HabitTemplate(
            name: "What Went Well Today?",
            description: "Write 2–3 things that actually worked in your favor today.",
            category: .reflection, duration: 5, difficulty: "easy",
            whyItMatters: "Most people naturally recall failures and overlook progress. Deliberately noting what worked builds realistic confidence and reinforces effective behavior.",
            todayInstruction: "Write 2–3 specific things that went well today. Not 'everything was fine' — specific wins, however small.",
            reflectionPrompt: "Did you underestimate how much actually went well?",
            iconName: "hand.thumbsup.fill"
        ),
        HabitTemplate(
            name: "What Did I Avoid Today?",
            description: "Honestly identify one thing you avoided or postponed.",
            category: .reflection, duration: 5,
            whyItMatters: "Avoidance is invisible unless you name it. Making it explicit transforms unconscious resistance into a conscious choice.",
            todayInstruction: "Write one thing you avoided today. Then write one sentence about why. No judgment — just honest observation.",
            reflectionPrompt: "Is this avoidance a pattern, or was today an exception?",
            iconName: "eye.slash.fill"
        ),
        HabitTemplate(
            name: "What Did I Learn?",
            description: "Write the most important thing you learned today.",
            category: .reflection, duration: 5, difficulty: "easy",
            whyItMatters: "Learning requires consolidation. Writing down what you learned within the same day doubles the chance of retaining and applying it.",
            todayInstruction: "Write the single most useful thing you encountered or realized today. One sentence is enough.",
            reflectionPrompt: "How might you apply this tomorrow?",
            iconName: "lightbulb.fill"
        ),
        HabitTemplate(
            name: "What Will I Improve Tomorrow?",
            description: "Identify one specific behavior to do differently tomorrow.",
            category: .reflection, duration: 5, difficulty: "easy",
            whyItMatters: "Improvement requires a decision, not just good intentions. A specific, named change is more likely to happen than a vague aspiration.",
            todayInstruction: "Write one concrete behavior you will do differently tomorrow. Be specific: not 'be more focused' but 'work for 25 minutes without touching my phone.'",
            reflectionPrompt: "Is this a genuine intention or just what you think you should write?",
            iconName: "arrow.up.circle.fill"
        ),
        HabitTemplate(
            name: "What Was Meaningful Today?",
            description: "Write one moment or action from today that felt genuinely meaningful.",
            category: .reflection, duration: 5, difficulty: "easy",
            whyItMatters: "Meaning is found in retrospect when we pay attention to it. This practice trains you to notice and value significance in ordinary days.",
            todayInstruction: "Think back across today. Find one moment — however small — that mattered. Write what it was and why it felt meaningful.",
            reflectionPrompt: "Are there more moments like this in your days than you typically notice?",
            iconName: "sparkles"
        )
    ]

    // MARK: - Helpers

    static func templates(for category: HabitCategory) -> [HabitTemplate] {
        all.filter { $0.category == category }
    }
}
