import SwiftUI

struct StackColumnView: View {
    let stackIndex: Int
    let stack: [Card]
    let isSelected: Bool
    let isHinted: Bool
    let isAceKiller: Bool
    let cardSize: CGSize
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            Text("Stack \(stackIndex + 1)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.75))

            Button(action: onTap) {
                ZStack(alignment: .bottomTrailing) {
                    if let top = stack.last {
                        CardView(card: top, isSelected: isSelected, isHinted: isHinted, size: cardSize)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        EmptyStackView(size: cardSize)
                    }

                    if isAceKiller {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.orange)
                            .padding(5)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Circle())
                            .offset(x: 6, y: 6)
                    }
                }
            }
            .buttonStyle(.plain)

            Text(stack.isEmpty ? "empty" : "\(stack.count) card\(stack.count == 1 ? "" : "s")")
                .font(.caption2)
                .foregroundColor(isAceKiller ? .orange.opacity(0.85) : .white.opacity(0.55))
        }
        .animation(.spring(duration: 0.3), value: stack.count)
    }
}
