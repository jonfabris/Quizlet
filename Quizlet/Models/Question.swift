//
//  Question.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import Foundation

struct Question: Codable, Identifiable {
    let id: String
    let question: String
    let choices: [String]
    let correctAnswerIndex: Int
    let explanation: String?

    init(id: String = UUID().uuidString, question: String, choices: [String], correctAnswerIndex: Int, explanation: String? = nil) {
        self.id = id
        self.question = question
        self.choices = choices
        self.correctAnswerIndex = correctAnswerIndex
        self.explanation = explanation
    }
}
