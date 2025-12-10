//
//  ContentView.swift
//  Quizlet
//
//  Created by Jon Fabris on 12/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var quizManager = QuizManager()

    var body: some View {
        if !quizManager.quizStarted {
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
