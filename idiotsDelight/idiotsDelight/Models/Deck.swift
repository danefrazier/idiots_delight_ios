import Foundation

struct Deck {
    private(set) var cards: [Card] = []

    init() {
        build()
        cards.shuffle()
        cards.shuffle()
        cards.shuffle()
    }

    mutating func drawOne() -> Card? {
        guard !cards.isEmpty else { return nil }
        return cards.removeLast()
    }

    var count: Int { cards.count }

    private mutating func build() {
        for suit in Suit.allCases {
            for n in 2...10 {
                cards.append(Card(suit: suit, value: .number(n)))
            }
            cards.append(Card(suit: suit, value: .jack))
            cards.append(Card(suit: suit, value: .queen))
            cards.append(Card(suit: suit, value: .king))
            cards.append(Card(suit: suit, value: .ace))
        }
    }
}
