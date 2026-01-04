//
//  ResultsView.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import SwiftUI

struct ResultsView: View {
    @ObservedObject var quizManager: QuizManager

    var percentage: Int {
        guard quizManager.questions.count > 0 else { return 0 }
        return Int((Double(quizManager.score) / Double(quizManager.questions.count)) * 100)
    }

    var performanceMessage: String {
        switch percentage {
        case 90...100:
            return "Excellent! You're a quiz master!"
        case 70..<80:
            return "Great job! You passed!"
        default:
            return "You did not pass. Keep practicing! You'll do better next time."
        }
    }

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Trophy or celebration icon
            Image(systemName: percentage >= 70 ? "trophy.fill" : "star.fill")
                .font(.system(size: 80))
                .foregroundColor(percentage >= 70 ? .yellow : .blue)

            // Title
            Text("Quiz Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Score display
            VStack(spacing: 10) {
                Text("Your Score")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text("\(quizManager.score) out of \(quizManager.questions.count)")
                    .font(.system(size: 50, weight: .bold))

                Text("\(percentage)%")
                    .font(.title)
                    .foregroundColor(.secondary)
            }

            // Performance message
            Text(performanceMessage)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Spacer()

            // Action buttons
            VStack(spacing: 15) {
                // Restart button
                Button(action: {
                    quizManager.restartQuiz()
                }) {
                    Text("Restart Quiz")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                // Return to start button
                Button(action: {
                    quizManager.returnToStart()
                }) {
                    Text("Return to Start")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    let manager = QuizManager.shared
    manager.score = 8
    manager.showingResults = true
    return ResultsView(quizManager: manager)
}
