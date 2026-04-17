import Foundation

enum Suit: String, CaseIterable {
    case spades   = "Spades"
    case clubs    = "Clubs"
    case hearts   = "Hearts"
    case diamonds = "Diamonds"

    var isRed: Bool { self == .hearts || self == .diamonds }

    var symbol: String {
        switch self {
        case .spades:   return "suit.spade.fill"
        case .clubs:    return "suit.club.fill"
        case .hearts:   return "suit.heart.fill"
        case .diamonds: return "suit.diamond.fill"
        }
    }
}

enum CardValue: Equatable {
    case number(Int)
    case jack
    case queen
    case king
    case ace

    var numericValue: Int {
        switch self {
        case .number(let n): return n
        case .jack:          return 11
        case .queen:         return 12
        case .king:          return 13
        case .ace:           return 14
        }
    }

    var displayString: String {
        switch self {
        case .number(let n): return "\(n)"
        case .jack:          return "J"
        case .queen:         return "Q"
        case .king:          return "K"
        case .ace:           return "A"
        }
    }

    var spokenName: String {
        switch self {
        case .number(let n): return "\(n)"
        case .jack:          return "Jack"
        case .queen:         return "Queen"
        case .king:          return "King"
        case .ace:           return "Ace"
        }
    }
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let suit: Suit
    let value: CardValue

    var isAce: Bool { value == .ace }
    var displayString: String { "\(value.displayString) of \(suit.rawValue)" }
    var accessibilityName: String { "\(value.spokenName) of \(suit.rawValue)" }
}
