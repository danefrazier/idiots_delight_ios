import SwiftUI

struct GameView: View {
    @Bindable var game: GameState
    @State private var showStats = false
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var isLandscape: Bool { verticalSizeClass == .compact }
    private var portraitCardSize: CGSize { CGSize(width: 75, height: 105) }
    private var landscapeCardSize: CGSize { CGSize(width: 58, height: 81) }

    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.45, blue: 0.18)
                .ignoresSafeArea()

            if isLandscape {
                landscapeLayout
            } else {
                portraitLayout
            }

            // Ace Killer overlay (both orientations)
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
        .sheet(isPresented: $showStats) { StatsView() }
    }

    // MARK: - Portrait

    private var portraitLayout: some View {
        VStack(spacing: 24) {
            headerBar
                .padding(.top, 24)
                .padding(.horizontal, 20)

            stacksRow(cardSize: portraitCardSize)

            statusMessage

            dealButton

            Spacer()

            newGameButton
                .padding(.bottom, 16)
        }
    }

    // MARK: - Landscape

    private var landscapeLayout: some View {
        HStack(spacing: 20) {

            // Left panel: controls
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Idiot's Delight")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                    Text("Round \(game.roundNumber) of 13")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.65))
                    Text("\(game.deck.count) cards in deck")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.65))
                }

                HStack(spacing: 6) {
                    Toggle("", isOn: $game.hintMode)
                        .toggleStyle(.switch)
                        .tint(.yellow)
                        .labelsHidden()
                        .scaleEffect(0.85)
                    Text("Hints")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Button(action: { showStats = true }) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.white.opacity(0.75))
                    }
                }

                Spacer()

                Text(game.lastMessage)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .animation(.easeInOut(duration: 0.2), value: game.lastMessage)

                Spacer()

                newGameButton
            }
            .frame(width: 140)
            .padding(.vertical, 12)

            // Center: stacks
            VStack(spacing: 12) {
                Spacer()
                stacksRow(cardSize: landscapeCardSize)
                Spacer()
            }

            // Right: deal button
            VStack {
                Spacer()
                dealButton
                Spacer()
            }
            .frame(width: 130)
            .padding(.vertical, 12)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Shared subviews

    private var headerBar: some View {
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
            Toggle("Hints", isOn: $game.hintMode)
                .toggleStyle(.switch)
                .tint(.yellow)
                .labelsHidden()
            Text("Hints")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            Button(action: { showStats = true }) {
                Image(systemName: "chart.bar.fill")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.75))
                    .padding(8)
            }
        }
    }

    private func stacksRow(cardSize: CGSize) -> some View {
        HStack(spacing: 12) {
            ForEach(0..<4, id: \.self) { i in
                StackColumnView(
                    stackIndex: i,
                    stack: game.stacks[i],
                    isSelected: game.selectedStack == i,
                    isHinted: game.hintStackIndex == i,
                    isAceKiller: game.aceKillerStacks.contains(i),
                    cardSize: cardSize,
                    onTap: { game.tapStack(i) }
                )
            }
        }
    }

    private var statusMessage: some View {
        Text(game.lastMessage)
            .font(.footnote)
            .foregroundColor(.white.opacity(0.85))
            .multilineTextAlignment(.center)
            .frame(minHeight: 40)
            .padding(.horizontal, 24)
            .animation(.easeInOut(duration: 0.2), value: game.lastMessage)
    }

    private var dealButton: some View {
        Button(action: { game.dealRound() }) {
            Text("Deal Next Round")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 13)
                .background(game.canDeal ? Color.blue : Color.gray.opacity(0.4))
                .clipShape(Capsule())
        }
        .disabled(!game.canDeal)
        .animation(.easeInOut, value: game.canDeal)
    }

    private var newGameButton: some View {
        Button(action: { game.reset() }) {
            Text("New Game")
                .font(.subheadline.bold())
                .foregroundColor(.white.opacity(0.85))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.3))
                .clipShape(Capsule())
        }
    }
}

#Preview {
    GameView(game: GameState())
}
