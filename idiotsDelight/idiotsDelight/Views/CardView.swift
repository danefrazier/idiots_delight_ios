import SwiftUI

struct CardView: View {
    let card: Card
    var isSelected: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 1, y: 2)

            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    isSelected ? Color.blue : Color.gray.opacity(0.3),
                    lineWidth: isSelected ? 3 : 1
                )

            VStack(spacing: 4) {
                Text(card.value.displayString)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Image(systemName: card.suit.symbol)
                    .font(.system(size: 20))
            }
            .foregroundColor(card.suit.isRed ? .red : .black)
        }
        .frame(width: 75, height: 105)
        .scaleEffect(isSelected ? 1.06 : 1.0)
        .animation(.spring(duration: 0.2), value: isSelected)
    }
}

struct EmptyStackView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .strokeBorder(
                Color.white.opacity(0.35),
                style: StrokeStyle(lineWidth: 2, dash: [6])
            )
            .frame(width: 75, height: 105)
            .contentShape(Rectangle())
    }
}

#Preview {
    HStack(spacing: 12) {
        CardView(card: Card(suit: .hearts, value: .ace), isSelected: true)
        CardView(card: Card(suit: .spades, value: .number(7)))
        CardView(card: Card(suit: .diamonds, value: .queen))
        EmptyStackView()
    }
    .padding()
    .background(Color(red: 0.13, green: 0.45, blue: 0.18))
}
