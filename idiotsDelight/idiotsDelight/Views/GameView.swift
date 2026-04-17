import SwiftUI

struct GameView: View {
    @Bindable var game: GameState
    @State private var showStats = false
    @State private var showAbout = false
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var isLandscape: Bool { verticalSizeClass == .compact }
    private var portraitCardSize: CGSize { CGSize(width: 75, height: 105) }

    // geometry is the full landscape GeometryReader proxy
    private func landscapeCardSize(in geometry: GeometryProxy) -> CGSize {
        // left 100 + right 110 + 2 gaps*16 + 2*padding*12 + safe insets
        let sideInsets = geometry.safeAreaInsets.leading + geometry.safeAreaInsets.trailing
        let usedWidth: CGFloat = 100 + 110 + 32 + 24 + sideInsets
        let availableWidth = geometry.size.width - usedWidth
        let cardW = floor((availableWidth - 3 * 12) / 4)
        let cardH = floor(cardW * 1.4)
        let maxH = (geometry.size.height - geometry.safeAreaInsets.top - geometry.safeAreaInsets.bottom) * 0.90
        let clampedH = min(cardH, maxH)
        let clampedW = floor(clampedH / 1.4)
        return CGSize(width: clampedW, height: clampedH)
    }

    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.45, blue: 0.18)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Persistent top bar — always visible in both orientations
                headerBar
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 10)

                Divider()
                    .background(Color.white.opacity(0.15))

                if isLandscape {
                    landscapeLayout
                } else {
                    portraitLayout
                }
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
        .sheet(isPresented: $showAbout) { AboutView() }
    }

    // MARK: - Portrait

    private var portraitLayout: some View {
        VStack(spacing: 24) {
            stacksRow(cardSize: portraitCardSize)
                .padding(.top, 16)

            statusMessage

            dealButton

            Spacer()

            newGameButton
                .padding(.bottom, 16)
        }
    }

    // MARK: - Landscape

    private var landscapeLayout: some View {
        GeometryReader { geo in
            HStack(spacing: 16) {

                // Left panel: status message + new game
                VStack(alignment: .leading, spacing: 10) {
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
                .frame(width: 100)
                .padding(.vertical, 12)

                // Center: stacks
                VStack(spacing: 12) {
                    Spacer()
                    stacksRow(cardSize: landscapeCardSize(in: geo))
                    Spacer()
                }

                // Right: deal button fills the panel width
                VStack {
                    Spacer()
                    landscapeDealButton
                    Spacer()
                }
                .frame(width: 110)
                .padding(.vertical, 12)
            }
            .padding(.horizontal, 12)
        }
    }

    // MARK: - Shared subviews

    private var headerBar: some View {
        HStack(spacing: 8) {
            Text("Idiot's Delight")
                .font(.headline.bold())
                .foregroundColor(.white)

            Spacer()

            Toggle("", isOn: $game.hintMode)
                .toggleStyle(.switch)
                .tint(.yellow)
                .labelsHidden()
                .scaleEffect(0.85)
            Text("Hints")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))

            Button(action: { showStats = true }) {
                Image(systemName: "chart.bar.fill")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.horizontal, 6)
            }
            Button(action: { showAbout = true }) {
                Image(systemName: "info.circle")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.leading, 2)
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

    private var landscapeDealButton: some View {
        Button(action: { game.dealRound() }) {
            Text("Deal\nNext\nRound")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(game.canDeal ? Color.blue : Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 16))
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
