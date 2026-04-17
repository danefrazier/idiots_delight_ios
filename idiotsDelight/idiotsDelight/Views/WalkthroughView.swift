import SwiftUI

struct WalkthroughStep {
    let icon: String
    let title: String
    let body: String
}

private let steps: [WalkthroughStep] = [
    WalkthroughStep(
        icon: "suit.club.fill",
        title: "Welcome to Idiot's Delight",
        body: "A classic solitaire card game. Four stacks, one deck — can you finish with a single ace on each stack?"
    ),
    WalkthroughStep(
        icon: "hand.tap.fill",
        title: "Remove the Lowest Card",
        body: "When cards of the same suit appear across stacks, tap the lower one to remove it. A card can only be removed if a higher card of the same suit is showing."
    ),
    WalkthroughStep(
        icon: "arrow.right.circle.fill",
        title: "Move Aces to Empty Stacks",
        body: "Only aces can move — tap an ace to select it, then tap an empty stack to place it. Keeping aces accessible is the key to winning."
    ),
    WalkthroughStep(
        icon: "lightbulb.fill",
        title: "Use the Hints Toggle",
        body: "Flip the Hints switch in the top bar and the best card to tap will pulse with a yellow glow. Great when you're stuck."
    ),
    WalkthroughStep(
        icon: "trophy.fill",
        title: "You're Ready — Good Luck!",
        body: "Win by leaving exactly one ace on each of the four stacks. Deal the next round whenever you're ready."
    )
]

struct WalkthroughView: View {
    let onDismiss: () -> Void

    @State private var currentStep = 0

    private var isLast: Bool { currentStep == steps.count - 1 }

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Step card
                VStack(spacing: 20) {
                    Image(systemName: steps[currentStep].icon)
                        .font(.system(size: 44))
                        .foregroundColor(.white.opacity(0.9))

                    Text(steps[currentStep].title)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(steps[currentStep].body)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(32)
                .background(Color.black.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 32)

                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentStep ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 7, height: 7)
                    }
                }

                // Buttons
                HStack(spacing: 20) {
                    if !isLast {
                        Button("Skip") {
                            onDismiss()
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.55))
                    }

                    Button(isLast ? "Let's Play!" : "Next") {
                        if isLast {
                            onDismiss()
                        } else {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentStep += 1
                            }
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 13)
                    .background(Color(red: 0.1, green: 0.55, blue: 0.25))
                    .clipShape(Capsule())
                }

                Spacer()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: currentStep)
    }
}

#Preview {
    WalkthroughView(onDismiss: {})
        .background(Color(red: 0.13, green: 0.45, blue: 0.18))
}
