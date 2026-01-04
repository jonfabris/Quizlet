//
//  QuizManager.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import Foundation

class QuizManager: ObservableObject {
    static let shared = QuizManager()

    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var score: Int = 0
    @Published var selectedAnswerIndex: Int? = nil
    @Published var showingResults: Bool = false
    @Published var quizStarted: Bool = false
    @Published var quizHistory: [QuizResult] = []
    @Published var showingHistory: Bool = false
    @Published var showingConfig: Bool = false
    @Published var errorMessage: String? = nil
    @Published var totalQuestionCount: Int = 0

    private let defaults = UserDefaults.standard
    private let questionIDsKey = "savedQuestionIDs"
    private let currentIndexKey = "savedCurrentIndex"
    private let scoreKey = "savedScore"
    private let quizStartedKey = "savedQuizStarted"
    private let historyKey = "quizHistory"

    private var allQuestions: [Question] = []

    init() {
        loadAllQuestions()
        loadQuizHistory()
    }

    private func loadAllQuestions() {
        guard let url = Bundle.main.url(forResource: "nc-drivers-test", withExtension: "json") else {
            print("Error: Could not find nc-drivers-test.json in bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            allQuestions = try decoder.decode([Question].self, from: data)
            totalQuestionCount = allQuestions.count
        } catch {
            print("Error loading questions: \(error)")
        }
    }

    private func restoreProgress() {
        let savedQuizStarted = defaults.bool(forKey: quizStartedKey)

        if savedQuizStarted, let savedIDs = defaults.array(forKey: questionIDsKey) as? [String] {
            // Restore the exact question order
            questions = savedIDs.compactMap { id in
                allQuestions.first { $0.id == id }
            }

            currentQuestionIndex = defaults.integer(forKey: currentIndexKey)
            score = defaults.integer(forKey: scoreKey)
            quizStarted = true

            // Check if quiz was completed
            if currentQuestionIndex >= questions.count {
                showingResults = true
            }
        }
    }

    private func saveProgress() {
        let questionIDs = questions.map { $0.id }
        defaults.set(questionIDs, forKey: questionIDsKey)
        defaults.set(currentQuestionIndex, forKey: currentIndexKey)
        defaults.set(score, forKey: scoreKey)
        defaults.set(quizStarted, forKey: quizStartedKey)
    }

    private func clearProgress() {
        defaults.removeObject(forKey: questionIDsKey)
        defaults.removeObject(forKey: currentIndexKey)
        defaults.removeObject(forKey: scoreKey)
        defaults.removeObject(forKey: quizStartedKey)
    }

    private func loadQuizHistory() {
        if let data = defaults.data(forKey: historyKey),
           let history = try? JSONDecoder().decode([QuizResult].self, from: data) {
            quizHistory = history.sorted { $0.date > $1.date }
        }
    }

    private func saveQuizResult() {
        let result = QuizResult(
            date: Date(),
            score: score,
            totalQuestions: questions.count
        )
        quizHistory.insert(result, at: 0) // Add to beginning for newest first

        if let encoded = try? JSONEncoder().encode(quizHistory) {
            defaults.set(encoded, forKey: historyKey)
        }
    }

    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var isAnswerCorrect: Bool {
        guard let selectedAnswerIndex = selectedAnswerIndex,
              let currentQuestion = currentQuestion else { return false }
        return selectedAnswerIndex == currentQuestion.correctAnswerIndex
    }

    var hasSavedProgress: Bool {
        // Check if there's an unfinished quiz saved
        let savedQuizStarted = defaults.bool(forKey: quizStartedKey)
        if savedQuizStarted, let savedIDs = defaults.array(forKey: questionIDsKey) as? [String] {
            let savedIndex = defaults.integer(forKey: currentIndexKey)
            // Has saved progress if quiz is started and not completed
            return savedIndex < savedIDs.count
        }
        return false
    }

    var savedProgressInfo: (currentQuestion: Int, totalQuestions: Int, score: Int)? {
        guard hasSavedProgress else { return nil }
        if let savedIDs = defaults.array(forKey: questionIDsKey) as? [String] {
            let savedIndex = defaults.integer(forKey: currentIndexKey)
            let savedScore = defaults.integer(forKey: scoreKey)
            return (savedIndex + 1, savedIDs.count, savedScore)
        }
        return nil
    }

    func resumeQuiz() {
        // Simply restore the saved state
        restoreProgress()
    }

    func showQuizConfig() {
        showingConfig = true
    }

    func startQuiz(withQuestionCount count: Int) {
        // Shuffle all questions first, then take requested count
        let shuffled = allQuestions.shuffled()
        questions = Array(shuffled.prefix(count))

        currentQuestionIndex = 0
        score = 0
        selectedAnswerIndex = nil
        showingResults = false
        showingConfig = false
        quizStarted = true
        saveProgress()
    }

    func cancelConfig() {
        showingConfig = false
    }

    func selectAnswer(_ index: Int) {
        selectedAnswerIndex = index
        if isAnswerCorrect {
            score += 1
        }
        saveProgress()
    }

    func nextQuestion() {
        selectedAnswerIndex = nil
        currentQuestionIndex += 1
        saveProgress()

        if currentQuestionIndex >= questions.count {
            showingResults = true
            saveQuizResult() // Save the completed quiz to history
            clearProgress() // Clear in-progress data since quiz is complete
        }
    }

    func restartQuiz() {
        clearProgress()
        showQuizConfig()
    }

    func returnToStart() {
        clearProgress()
        questions = []
        currentQuestionIndex = 0
        score = 0
        selectedAnswerIndex = nil
        showingResults = false
        quizStarted = false
    }

    func showHistory() {
        showingHistory = true
    }

    func hideHistory() {
        showingHistory = false
    }
}
