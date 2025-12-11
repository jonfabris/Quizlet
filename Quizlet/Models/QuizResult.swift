//
//  QuizResult.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import Foundation

struct QuizResult: Codable, Identifiable {
    let id: UUID
    let date: Date
    let score: Int
    let totalQuestions: Int

    var percentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(score) / Double(totalQuestions)) * 100)
    }

    init(id: UUID = UUID(), date: Date = Date(), score: Int, totalQuestions: Int) {
        self.id = id
        self.date = date
        self.score = score
        self.totalQuestions = totalQuestions
    }
}
