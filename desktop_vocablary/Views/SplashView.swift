//
//  SplashView.swift
//  desktop_vocablary
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "text.book.closed.fill")
                .font(.system(size: 64))
                .foregroundStyle(.tint)

            Text("今日の一語")
                .font(.system(size: 28, weight: .bold, design: .rounded))
        }
    }
}

#Preview {
    SplashView()
}
