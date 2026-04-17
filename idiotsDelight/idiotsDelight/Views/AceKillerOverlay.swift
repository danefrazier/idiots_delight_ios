import SwiftUI

struct AceKillerOverlay: View {
    let suit: Suit
    let onKeepPlaying: () -> Void
    let onStartOver: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.orange)
                    .shadow(color: .black.opacity(0.6), radius: 6, x: 0, y: 3)

                Text("ACE KILLER")
                    .font(.system(size: 34, weight: .black))
                    .foregroundColor(.orange)
                    .tracking(2)
                    .shadow(color: .black.opacity(0.6), radius: 4)

                VStack(spacing: 6) {
                    Text("The King of \(suit.rawValue)")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Text("just buried your Ace of \(suit.rawValue).")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.85))
                }
                .multilineTextAlignment(.center)

                Image(systemName: suit.symbol)
                    .font(.system(size: 44))
                    .foregroundColor(suit.isRed ? .red : .white.opacity(0.9))
                    .padding(.vertical, 4)

                HStack(spacing: 16) {
                    Button(action: onStartOver) {
                        Text("Start Over")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 13)
                            .background(Color.red.opacity(0.85))
                            .clipShape(Capsule())
                    }

                    Button(action: onKeepPlaying) {
                        Text("Keep Playing")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 13)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(32)
            .background(Color.black.opacity(0.45))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(28)
        }
    }
}
