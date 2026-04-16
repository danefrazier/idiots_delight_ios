import SwiftUI

struct GameView: View {
    @Bindable var game: GameState
    @State private var showStats = false

    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.45, blue: 0.18)
                .ignoresSafeArea()

            VStack(spacing: 28) {

                // Title + round info
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Idiot's Delight")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        Text("Round \(game.roundNumber) of 13  ·  \(game.deck.count) cards in deck")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.65))
                    }
                    Spacer()
                    Button(action: { showStats = true }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.75))
                            .padding(8)
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal, 20)

                // The four stacks
                HStack(spacing: 16) {
                    ForEach(0..<4, id: \.self) { i in
                        StackColumnView(
                            stackIndex: i,
                            stack: game.stacks[i],
                            isSelected: game.selectedStack == i,
                            isAceKiller: game.aceKillerStacks.contains(i),
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

                HStack {
                    Button(action: { game.reset() }) {
                        Text("New Game")
                            .font(.subheadline.bold())
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Capsule())
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }

            // Ace Killer overlay
            if game.showAceKillerAlert, let suit = game.aceKillerSuit {
                AceKillerOverlay(
                    suit: suit,
                    onKeepPlaying: { game.dismissAceKillerAlert() },
                    onStartOver: { game.reset() }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: game.showAceKillerAlert)
        .sheet(isPresented: $showStats) {
            StatsView()
        }
        .alert("No Further Plays", isPresented: $game.showNoMovesAlert) {
            Button("Deal Next Round") { game.dealRound() }
            Button("New Game", role: .destructive) { game.reset() }
        } message: {
            Text("There are no valid moves available. Deal the next round or start a new game.")
        }
    }
}

#Preview {
    GameView(game: GameState())
}
