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
            Spacer()

            // App icon or logo
            Image(systemName: "car.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.blue)

            // Title
            Text("NC Driver's Test")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Subtitle
            Text("100 Practice Questions")
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

            // Start button
            Button(action: {
                quizManager.startQuiz()
            }) {
                Text("Start Quiz")
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
    StartView(quizManager: QuizManager())
}
