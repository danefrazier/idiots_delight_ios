import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.1, green: 0.35, blue: 0.14)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        helpSection("Removing Cards") {
                            helpRow(
                                icon: "hand.tap.fill",
                                title: "Tap the lowest card of the same suit",
                                body: "When two or more cards of the same suit are showing across the stacks, tap the lower one to remove it. A card can only be removed if a higher card of the same suit is visible on another stack."
                            )
                        }

                        helpSection("Moving Aces") {
                            helpRow(
                                icon: "arrow.right.circle.fill",
                                title: "Only aces can move to empty stacks",
                                body: "Tap an ace to select it (it will highlight), then tap any empty stack to move it there. Aces cannot be removed — only relocated. Keeping aces in open stacks is key to winning."
                            )
                        }

                        helpSection("Hint Mode") {
                            helpRow(
                                icon: "lightbulb.fill",
                                title: "The Hints toggle shows your next move",
                                body: "Flip the Hints switch in the top bar and the best card to tap will pulse with a yellow glow. Turn it off any time — the glow stops immediately."
                            )
                        }

                        helpSection("Winning & Losing") {
                            helpRow(
                                icon: "trophy.fill",
                                title: "Win",
                                body: "Leave exactly one ace on each of the four stacks."
                            )
                            helpRow(
                                icon: "xmark.circle.fill",
                                title: "Lose",
                                body: "The deck runs out, or no legal moves remain with no cards left to deal."
                            )
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("How to Play")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(red: 0.1, green: 0.35, blue: 0.14), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func helpSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
                .padding(.horizontal, 24)
                .padding(.bottom, 6)

            VStack(spacing: 0) {
                content()
            }
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
        }
        .padding(.top, 20)
    }

    private func helpRow(icon: String, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 28)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text(body)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(3)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    HelpView()
}
