import SwiftUI

struct GameView: View {
    var game: GameState

    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.45, blue: 0.18)
                .ignoresSafeArea()

            VStack(spacing: 28) {

                // Title + round info
                VStack(spacing: 4) {
                    Text("Idiot's Delight")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text("Round \(game.roundNumber) of 13  ·  \(game.deck.count) cards in deck")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.65))
                }
                .padding(.top, 24)

                // The four stacks
                HStack(spacing: 16) {
                    ForEach(0..<4, id: \.self) { i in
                        StackColumnView(
                            stackIndex: i,
                            stack: game.stacks[i],
                            isSelected: game.selectedStack == i,
                            onTap: { game.tapStack(i) }
                        )
                    }
                }

                // Status message
                Text(game.lastMessage)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 40)
                    .padding(.horizontal, 24)
                    .animation(.easeInOut(duration: 0.2), value: game.lastMessage)

                // Deal button
                Button(action: { game.dealRound() }) {
                    Text("Deal Next Round")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(game.canDeal ? Color.blue : Color.gray.opacity(0.4))
                        .clipShape(Capsule())
                }
                .disabled(!game.canDeal)
                .animation(.easeInOut, value: game.canDeal)

                Spacer()
            }
        }
    }
}

#Preview {
    GameView(game: GameState())
}
