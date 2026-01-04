//
//  QuizConfigView.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import SwiftUI

struct QuizConfigView: View {
    @ObservedObject var quizManager: QuizManager
    @State private var selectedQuestionCount: Double

    private var minQuestions : Int {
        if quizManager.totalQuestionCount > 10 {
            return 10
        } else {
            return quizManager.totalQuestionCount
        }
    }
    
    init(quizManager: QuizManager) {
        self.quizManager = quizManager
        _selectedQuestionCount = State(initialValue: Double(quizManager.totalQuestionCount))
        print(selectedQuestionCount)
        print(quizManager.totalQuestionCount)
    }

    var body: some View {
        VStack(spacing: 30) {
            // Header with back button
            HStack {
                Button(action: {
                    quizManager.cancelConfig()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.body)
                    .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.horizontal)

            Spacer()

            // Icon
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 80))
                .foregroundColor(.blue)

            // Title
            Text("Quiz Configuration")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Description
            Text("Customize your quiz experience")
                .font(.title3)
                .foregroundColor(.secondary)

            Spacer()

            // Configuration section
            VStack(spacing: 25) {
                // Total questions available info
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.blue)
                    Text("Total Questions Available:")
                        .font(.body)
                    Spacer()
                    Text("\(quizManager.totalQuestionCount)")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)

                // Question count slider
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Number of Questions")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(selectedQuestionCount))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }

                    Slider(
                        value: $selectedQuestionCount,
                        in: Double(minQuestions)...Double(quizManager.totalQuestionCount),
                        step: 1
                    )
                    .accentColor(.blue)

                    HStack {
                        Text("\(minQuestions)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(quizManager.totalQuestionCount)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()

            // Begin quiz button
            Button(action: {
                quizManager.startQuiz(withQuestionCount: Int(selectedQuestionCount))
            }) {
                HStack {
                    Image(systemName: "play.circle.fill")
                    Text("Begin Quiz")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    QuizConfigView(quizManager: QuizManager.shared)
}
