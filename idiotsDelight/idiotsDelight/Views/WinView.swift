import SwiftUI

struct WinView: View {
    var game: GameState

    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.45, blue: 0.18)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("You Win!")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundColor(.yellow)

                Text("Four aces. Well played.")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.85))

                HStack(spacing: 12) {
                    ForEach(0..<4, id: \.self) { i in
                        if let card = game.stacks[i].last {
                            CardView(card: card)
                        }
                    }
                }
                .padding(.vertical, 8)

                Button(action: { game.reset() }) {
                    Text("Play Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 44)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
        }
    }
}
