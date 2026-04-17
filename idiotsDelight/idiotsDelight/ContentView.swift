import SwiftUI

struct ContentView: View {
    @State private var game = GameState()

    var body: some View {
        ZStack {
            GameView(game: game)

            if game.phase == .won {
                WinView(game: game)
                    .transition(.opacity)
            } else if game.phase == .lost {
                LoseView(game: game)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: game.phase)
    }
}

#Preview {
    ContentView()
}
