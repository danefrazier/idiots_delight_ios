import SwiftUI

struct StackColumnView: View {
    let stackIndex: Int
    let stack: [Card]
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text("Stack \(stackIndex + 1)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.75))

            Button(action: onTap) {
                if let top = stack.last {
                    CardView(card: top, isSelected: isSelected)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    EmptyStackView()
                }
            }
            .buttonStyle(.plain)

            Text(stack.isEmpty ? "empty" : "\(stack.count) card\(stack.count == 1 ? "" : "s")")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.55))
        }
        .animation(.spring(duration: 0.3), value: stack.count)
    }
}
