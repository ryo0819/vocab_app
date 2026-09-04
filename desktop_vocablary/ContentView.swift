//
//  ContentView.swift
//  desktop_vocablary
//

import SwiftUI

struct ContentView: View {
    @State private var term: TechTerm
    @State private var wordOpacity: Double = 0
    @State private var explanationOpacity: Double = 0
    @State private var barProgress: Double = 1
    @State private var loopTask: Task<Void, Never>?

    private let wordFadeDuration: Double = 0.6
    private let explanationDelay: Double = 0.4
    private let explanationFadeDuration: Double = 0.6
    private let holdDuration: Double = 10.0
    private let fadeOutDuration: Double = 0.8
    private let pauseBetweenCycles: Double = 0.3

    // バーは「単語が消え始めるタイミング」でちょうど空になるようにする
    private var barCountdownDuration: Double {
        explanationDelay + explanationFadeDuration + holdDuration
    }

    init() {
        _term = State(initialValue: TechTermRepository.randomTerm())
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(term.term)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .opacity(wordOpacity)

            Divider()
                .frame(width: 60)
                .opacity(wordOpacity)

            Text(term.explanation)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .opacity(explanationOpacity)

            Spacer()
            Spacer()

            countdownBar
                .opacity(wordOpacity)
                .padding(.horizontal, 40)
        }
        .padding()
        .onAppear { startLoop() }
        .onDisappear { loopTask?.cancel() }
    }

    private var countdownBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.2))
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: geometry.size.width * barProgress)
            }
        }
        .frame(height: 4)
    }

    private func startLoop() {
        loopTask?.cancel()
        loopTask = Task {
            while !Task.isCancelled {
                await runSingleCycle()
            }
        }
    }

    private func runSingleCycle() async {
        term = TechTermRepository.randomTerm(excluding: term.id)
        wordOpacity = 0
        explanationOpacity = 0
        barProgress = 1

        withAnimation(.easeOut(duration: wordFadeDuration)) {
            wordOpacity = 1
        }
        withAnimation(.linear(duration: barCountdownDuration)) {
            barProgress = 0
        }

        try? await Task.sleep(for: .seconds(explanationDelay))
        guard !Task.isCancelled else { return }

        withAnimation(.easeOut(duration: explanationFadeDuration)) {
            explanationOpacity = 1
        }

        try? await Task.sleep(for: .seconds(explanationFadeDuration + holdDuration))
        guard !Task.isCancelled else { return }

        withAnimation(.easeIn(duration: fadeOutDuration)) {
            wordOpacity = 0
            explanationOpacity = 0
        }

        try? await Task.sleep(for: .seconds(fadeOutDuration + pauseBetweenCycles))
    }
}

#Preview {
    ContentView()
}
