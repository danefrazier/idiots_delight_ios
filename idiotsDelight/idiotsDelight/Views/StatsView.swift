import SwiftUI

struct StatsView: View {
    @State private var stats: GameStats = StatsStore.shared.load()
    @State private var showResetConfirm = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.1, green: 0.35, blue: 0.14)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    statSection("Results") {
                        statRow("Games Played", value: "\(stats.gamesPlayed)")
                        statRow("Games Won", value: "\(stats.gamesWon)")
                        statRow("Games Lost", value: "\(stats.gamesLost)")
                        statRow("Win Rate", value: stats.gamesPlayed > 0
                            ? String(format: "%.0f%%", stats.winRate * 100)
                            : "—")
                    }

                    statSection("Loss Detail") {
                        statRow("Avg Cards Remaining", value: stats.gamesLost > 0
                            ? String(format: "%.1f", stats.avgCardsRemainingOnLoss)
                            : "—")
                        aceKillerRow()
                    }

                    Spacer()

                    Button(role: .destructive) {
                        showResetConfirm = true
                    } label: {
                        Text("Reset All Stats")
                            .font(.subheadline)
                            .foregroundColor(.red.opacity(0.75))
                    }
                    .padding(.bottom, 32)
                    .confirmationDialog("Reset All Stats?", isPresented: $showResetConfirm, titleVisibility: .visible) {
                        Button("No, Keep My Stats", role: .cancel) {}
                        Button("Yes, Reset Everything", role: .destructive) {
                            StatsStore.shared.resetStats()
                            stats = StatsStore.shared.load()
                        }
                    } message: {
                        Text("This will permanently erase all game history. This cannot be undone.")
                    }
                }
                .padding(.top, 16)
            }
            .navigationTitle("Stats")
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

    private func statSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
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

    private func statRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.white.opacity(0.85))
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func aceKillerRow() -> some View {
        HStack {
            Image(systemName: "crown.fill")
                .foregroundColor(.orange)
                .font(.subheadline)
            Text("Ace Killers Encountered")
                .foregroundColor(.white.opacity(0.85))
            Spacer()
            Text("\(stats.aceKillerCount)")
                .font(.headline)
                .foregroundColor(stats.aceKillerCount > 0 ? .orange : .white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
