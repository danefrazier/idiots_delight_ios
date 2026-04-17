import SwiftUI

struct WinView: View {
    var game: GameState

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("You Win!")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundColor(.yellow)
                    .shadow(color: .black.opacity(0.6), radius: 6, x: 0, y: 3)

                Text("Four aces. Well played.")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.5), radius: 4)

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
            .padding(32)
            .background(Color.black.opacity(0.35))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal, 24)
        }
    }
}
