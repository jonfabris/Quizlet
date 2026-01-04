//
//  StartView.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var quizManager: QuizManager

    var body: some View {
        VStack(spacing: 30) {
            // Header with history button
            HStack {
                Spacer()
                Button(action: {
                    quizManager.showHistory()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chart.bar.fill")
                        Text("History")
                    }
                    .font(.body)
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)

            Spacer()

            // App icon or logo
            Image(systemName: "car.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.blue)

            // Title
            Text("NC Road Quiz")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Subtitle
            Text("\(quizManager.totalQuestionCount) Practice Questions")
                .font(.title3)
                .foregroundColor(.secondary)

            Spacer()

            // Info text
            VStack(spacing: 15) {
                InfoRow(icon: "shuffle", text: "Questions randomized each time")
                InfoRow(icon: "checkmark.circle", text: "Instant feedback on answers")
                InfoRow(icon: "chart.bar", text: "Track your progress")
            }
            .padding()

            Spacer()

            // Buttons
            VStack(spacing: 15) {
                // Resume button (only shown if there's saved progress)
                if quizManager.hasSavedProgress {
                    Button(action: {
                        quizManager.resumeQuiz()
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                            Text("Resume Quiz")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                    }

                    // Progress info
                    if let progress = quizManager.savedProgressInfo {
                        VStack(spacing: 5) {
                            Text("Question \(progress.currentQuestion) of \(progress.totalQuestions)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Current Score: \(progress.score)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // Start new quiz button
                Button(action: {
                    quizManager.showQuizConfig()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise.circle.fill")
                        Text(quizManager.hasSavedProgress ? "Start New Quiz" : "Start Quiz")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

struct InfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(text)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

#Preview {
    StartView(quizManager: QuizManager.shared)
}
