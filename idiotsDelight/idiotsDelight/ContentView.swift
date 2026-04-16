//
//  ContentView.swift
//  idiotsDelight
//
//  Created by Dane Frazier on 4/16/26.
//

import SwiftUI

struct ContentView: View {
    @State private var game = GameState()

    var body: some View {
        switch game.phase {
        case .playing:
            GameView(game: game)
        case .won:
            WinView(game: game)
        case .lost:
            LoseView(game: game)
        }
    }
}

#Preview {
    ContentView()
}
