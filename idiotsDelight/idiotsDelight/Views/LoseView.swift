import SwiftUI

struct LoseView: View {
    var game: GameState

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Game Over")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.6), radius: 6, x: 0, y: 3)

                let remaining = game.stacks.reduce(0) { $0 + $1.count }
                Text("\(remaining) card\(remaining == 1 ? "" : "s") remain in the stacks.")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.85))
                    .shadow(color: .black.opacity(0.5), radius: 4)

                Button(action: { game.reset() }) {
                    Text("Try Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 44)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
            .padding(32)
            .background(Color.black.opacity(0.35))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal, 24)
        }
    }
}
