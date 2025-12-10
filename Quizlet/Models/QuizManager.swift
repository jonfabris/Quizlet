//
//  QuizManager.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import Foundation

class QuizManager: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var score: Int = 0
    @Published var selectedAnswerIndex: Int? = nil
    @Published var showingResults: Bool = false
    @Published var quizStarted: Bool = false

    private let defaults = UserDefaults.standard
    private let questionIDsKey = "savedQuestionIDs"
    private let currentIndexKey = "savedCurrentIndex"
    private let scoreKey = "savedScore"
    private let quizStartedKey = "savedQuizStarted"

    private var allQuestions: [Question] = []

    init() {
        loadAllQuestions()
        restoreProgress()
    }

    private func loadAllQuestions() {
        guard let url = Bundle.main.url(forResource: "nc-drivers-test", withExtension: "json") else {
            print("Error: Could not find nc-drivers-test.json in bundle")
            loadDefaultQuestions()
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            allQuestions = try decoder.decode([Question].self, from: data)
        } catch {
            print("Error loading questions: \(error)")
            loadDefaultQuestions()
        }
    }

    private func loadDefaultQuestions() {
        allQuestions = [
            Question(question: "What is the capital of France?",
                    choices: ["London", "Berlin", "Paris", "Madrid"],
                    correctAnswerIndex: 2),
            Question(question: "Which planet is known as the Red Planet?",
                    choices: ["Venus", "Mars", "Jupiter", "Saturn"],
                    correctAnswerIndex: 1)
        ]
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

    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var isAnswerCorrect: Bool {
        guard let selectedAnswerIndex = selectedAnswerIndex,
              let currentQuestion = currentQuestion else { return false }
        return selectedAnswerIndex == currentQuestion.correctAnswerIndex
    }

    func startQuiz() {
        // Shuffle questions for random order
        questions = allQuestions.shuffled()
        currentQuestionIndex = 0
        score = 0
        selectedAnswerIndex = nil
        showingResults = false
        quizStarted = true
        saveProgress()
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
            saveProgress()
        }
    }

    func restartQuiz() {
        clearProgress()
        startQuiz()
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
}
