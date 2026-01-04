//
//  QuizView.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import SwiftUI

struct QuizView: View {
    @ObservedObject var quizManager: QuizManager
    @State private var showingQuitAlert = false

    var body: some View {
        VStack(spacing: 0) {
            if let currentQuestion = quizManager.currentQuestion {
                // Header with quit button and question counter
                HStack {
                    // Quit button
                    Button(action: {
                        showingQuitAlert = true
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                            Text("Quit")
                        }
                        .font(.body)
                        .foregroundColor(.blue)
                    }

                    Spacer()

                    // Question counter
                    Text("Question \(quizManager.currentQuestionIndex + 1) of \(quizManager.questions.count)")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Spacer()

                    // Invisible placeholder for balance
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Quit")
                    }
                    .font(.body)
                    .opacity(0)
                }
                .padding()

                // Scrollable content area
                ScrollView {
                    VStack(spacing: 30) {
                        // Question text
                        Text(currentQuestion.question)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding()

                        // Answer choices
                        VStack(spacing: 15) {
                            ForEach(Array(currentQuestion.choices.enumerated()), id: \.offset) { index, choice in
                                ChoiceButton(
                                    text: choice,
                                    index: index,
                                    isSelected: quizManager.selectedAnswerIndex == index,
                                    isCorrect: index == currentQuestion.correctAnswerIndex,
                                    showFeedback: quizManager.selectedAnswerIndex != nil
                                ) {
                                    if quizManager.selectedAnswerIndex == nil {
                                        quizManager.selectAnswer(index)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Explanation (appears after answer is selected)
                        if quizManager.selectedAnswerIndex != nil, let explanation = currentQuestion.explanation {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(.blue)
                                    Text("Explanation")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                }
                                Text(explanation)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding(.bottom, 20)
                }

                // Fixed Next button at bottom
                VStack(spacing: 0) {
                    Divider()

                    Button(action: {
                        quizManager.nextQuestion()
                    }) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    .opacity(quizManager.selectedAnswerIndex != nil ? 1 : 0)
                    .disabled(quizManager.selectedAnswerIndex == nil)
                }
                .background(Color(UIColor.systemBackground))
            } else {
                Text("No questions available")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .animation(.easeInOut, value: quizManager.selectedAnswerIndex)
        .alert("Quit Quiz?", isPresented: $showingQuitAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Quit and Save", role: .destructive) {
                // Just return to start screen, progress is already saved
                quizManager.quizStarted = false
            }
        } message: {
            Text("Your progress will be saved and you can resume later from the start screen.")
        }
    }
}

struct ChoiceButton: View {
    let text: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let showFeedback: Bool
    let action: () -> Void

    var backgroundColor: Color {
        if showFeedback && isSelected {
            return isCorrect ? Color.green.opacity(0.3) : Color.red.opacity(0.3)
        } else if isSelected {
            return Color.blue.opacity(0.2)
        } else {
            return Color.gray.opacity(0.1)
        }
    }

    var borderColor: Color {
        if showFeedback && isSelected {
            return isCorrect ? Color.green : Color.red
        } else if isSelected {
            return Color.blue
        } else {
            return Color.gray.opacity(0.3)
        }
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                Spacer()
                if showFeedback && isSelected {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .disabled(showFeedback)
    }
}

#Preview {
    QuizView(quizManager: QuizManager.shared)
}
