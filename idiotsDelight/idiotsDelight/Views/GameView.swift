import SwiftUI

struct GameView: View {
    @Bindable var game: GameState
    @State private var showStats = false
    @State private var showAbout = false
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var isLandscape: Bool { verticalSizeClass == .compact }


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
        GeometryReader { geo in
            let hPad: CGFloat = 16
            let spacing: CGFloat = 12
            let cardW = floor((geo.size.width - hPad * 2 - spacing * 3) / 4)
            let cardH = min(floor(cardW * 1.4), floor(geo.size.height * 0.4))
            let cardSize = CGSize(width: cardW, height: cardH)

            VStack(spacing: 24) {
                stacksRow(cardSize: cardSize)
                    .padding(.top, 16)
                    .padding(.horizontal, hPad)

                statusMessage

                dealButton

                Spacer()

                newGameButton
                    .padding(.bottom, 16)
            }
        }
    }

    // MARK: - Landscape

    private var landscapeLayout: some View {
        GeometryReader { geo in
            // 6 equal columns: status | card1 | card2 | card3 | card4 | deal button
            let colW = floor((geo.size.width - 16) / 6)  // 16pt total side buffer
            let cardW = colW - 8  // 4pt breathing room each side within column
            let safeH = geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom
            let cardH = min(floor(cardW * 1.4), floor(safeH * 0.88))
            let cardSize = CGSize(width: cardW, height: cardH)

            HStack(spacing: 0) {

                // Status + New Game
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
                .frame(width: colW)
                .padding(.vertical, 12)

                // 4 card columns — each identical width
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
                    .frame(width: colW)
                }

                // Deal button column
                VStack {
                    Spacer()
                    landscapeDealButton
                    Spacer()
                }
                .frame(width: colW)
                .padding(.vertical, 12)
            }
            .padding(.horizontal, 8)
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
