//
//  ContentView.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var quizManager = QuizManager.shared

    var body: some View {
        if quizManager.showingHistory {
            HistoryView(quizManager: quizManager)
        } else if quizManager.showingConfig {
            QuizConfigView(quizManager: quizManager)
        } else if !quizManager.quizStarted {
            StartView(quizManager: quizManager)
        } else if quizManager.showingResults {
            ResultsView(quizManager: quizManager)
        } else {
            QuizView(quizManager: quizManager)
        }
    }
}

#Preview {
    ContentView()
}
