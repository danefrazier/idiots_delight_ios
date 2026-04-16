import SwiftUI

struct LoseView: View {
    var game: GameState

    var body: some View {
        ZStack {
            Color(red: 0.22, green: 0.08, blue: 0.08)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Game Over")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)

                let remaining = game.stacks.reduce(0) { $0 + $1.count }
                Text("\(remaining) card\(remaining == 1 ? "" : "s") remain in the stacks.")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.75))

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
        }
    }
}
