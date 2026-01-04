//
//  HistoryView.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var quizManager: QuizManager

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    quizManager.hideHistory()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.body)
                    .foregroundColor(.blue)
                }

                Spacer()

                Text("Quiz History")
                    .font(.headline)

                Spacer()

                // Invisible placeholder for balance
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .font(.body)
                .opacity(0)
            }
            .padding()
            .background(Color(.systemBackground))

            Divider()

            if quizManager.quizHistory.isEmpty {
                // Empty state
                VStack(spacing: 20) {
                    Spacer()
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No Quiz History")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Complete a quiz to see your scores here")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding()
            } else {
                // Quiz history list
                ScrollView {
                    VStack(spacing: 15) {
                        // Statistics summary
                        StatsSummaryView(history: quizManager.quizHistory)
                            .padding()

                        Divider()

                        // History list
                        ForEach(quizManager.quizHistory) { result in
                            QuizResultRow(result: result)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

struct StatsSummaryView: View {
    let history: [QuizResult]

    var totalQuizzes: Int {
        history.count
    }

    var averageScore: Int {
        guard !history.isEmpty else { return 0 }
        let total = history.reduce(0) { $0 + $1.percentage }
        return total / history.count
    }

    var bestScore: Int {
        history.map { $0.percentage }.max() ?? 0
    }

    var body: some View {
        VStack(spacing: 15) {
            Text("Statistics")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 20) {
                StatBox(title: "Total", value: "\(totalQuizzes)", color: .blue)
                StatBox(title: "Average", value: "\(averageScore)%", color: .orange)
                StatBox(title: "Best", value: "\(bestScore)%", color: .green)
            }
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct QuizResultRow: View {
    let result: QuizResult

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var performanceColor: Color {
        switch result.percentage {
        case 90...100:
            return .green
        case 70..<90:
            return .blue
        case 50..<70:
            return .orange
        default:
            return .red
        }
    }

    var performanceIcon: String {
        switch result.percentage {
        case 90...100:
            return "star.fill"
        case 70..<90:
            return "checkmark.circle.fill"
        case 50..<70:
            return "exclamationmark.circle.fill"
        default:
            return "xmark.circle.fill"
        }
    }

    var body: some View {
        HStack(spacing: 15) {
            // Performance icon
            Image(systemName: performanceIcon)
                .font(.system(size: 30))
                .foregroundColor(performanceColor)
                .frame(width: 40)

            // Quiz info
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("\(result.score)/\(result.totalQuestions)")
                        .font(.headline)
                    Text("(\(result.percentage)%)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text(dateFormatter.string(from: result.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Percentage badge
            Text("\(result.percentage)%")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(performanceColor)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    let manager = QuizManager.shared
    manager.quizHistory = [
        QuizResult(date: Date(), score: 85, totalQuestions: 100),
        QuizResult(date: Date().addingTimeInterval(-86400), score: 72, totalQuestions: 100),
        QuizResult(date: Date().addingTimeInterval(-172800), score: 90, totalQuestions: 100)
    ]
    return HistoryView(quizManager: manager)
}
