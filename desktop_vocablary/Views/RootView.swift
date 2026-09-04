//
//  RootView.swift
//  desktop_vocablary
//

import SwiftUI

struct RootView: View {
    @State private var isSplashFinished = false

    private let splashDuration: TimeInterval = 1.5

    var body: some View {
        ZStack {
            if isSplashFinished {
                ContentView()
                    .transition(.opacity)
            } else {
                SplashView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isSplashFinished)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
                isSplashFinished = true
            }
        }
    }
}

#Preview {
    RootView()
}
