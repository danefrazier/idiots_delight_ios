import Foundation
import Observation

enum GamePhase {
    case playing, won, lost
}

@Observable
class GameState {
    private(set) var stacks: [[Card]]
    private(set) var deck: Deck
    private(set) var roundNumber: Int
    private(set) var phase: GamePhase
    private(set) var selectedStack: Int?
    private(set) var lastMessage: String

    // Ace killer state
    private(set) var aceKillerStacks: Set<Int>
    private(set) var aceKillerSuit: Suit?
    private(set) var hadAceKiller: Bool
    var showAceKillerAlert: Bool

    init() {
        stacks = [[], [], [], []]
        deck = Deck()
        roundNumber = 0
        phase = .playing
        selectedStack = nil
        lastMessage = ""
        aceKillerStacks = []
        aceKillerSuit = nil
        hadAceKiller = false
        showAceKillerAlert = false
        dealRound()
    }

    func reset() {
        stacks = [[], [], [], []]
        deck = Deck()
        roundNumber = 0
        phase = .playing
        selectedStack = nil
        lastMessage = ""
        aceKillerStacks = []
        aceKillerSuit = nil
        hadAceKiller = false
        showAceKillerAlert = false
        dealRound()
    }

    func dismissAceKillerAlert() {
        showAceKillerAlert = false
    }

    // MARK: - Win check

    var isWon: Bool {
        stacks.allSatisfy { $0.count == 1 && $0.last?.isAce == true }
    }

    // MARK: - Removal validation

    func canRemove(stackIndex: Int) -> (Bool, String) {
        guard let card = stacks[stackIndex].last else {
            return (false, "No card in this stack")
        }
        guard !card.isAce else {
            return (false, "Aces cannot be removed — tap to move instead")
        }
        let sameSuit: [Card] = stacks.enumerated().compactMap { i, stack in
            guard i != stackIndex, let top = stack.last, top.suit == card.suit else { return nil }
            return top
        }
        guard !sameSuit.isEmpty else {
            return (false, "No other \(card.suit.rawValue) showing")
        }
        if let lower = sameSuit.filter({ $0.value.numericValue < card.value.numericValue })
            .min(by: { $0.value.numericValue < $1.value.numericValue }) {
            return (false, "\(card.displayString) is not lowest — \(lower.displayString) is lower")
        }
        return (true, "")
    }

    // MARK: - Tap handler

    func tapStack(_ index: Int) {
        guard phase == .playing else { return }

        let topCard = stacks[index].last

        if let from = selectedStack {
            if from == index {
                selectedStack = nil
                lastMessage = ""
            } else {
                performAceMove(from: from, to: index)
            }
            return
        }

        if let card = topCard, card.isAce {
            selectedStack = index
            lastMessage = "\(card.displayString) selected — tap destination stack"
        } else {
            let (ok, msg) = canRemove(stackIndex: index)
            if ok {
                let removed = stacks[index].removeLast()
                lastMessage = "Removed \(removed.displayString)"
                checkWin()
            } else {
                lastMessage = msg
            }
        }
    }

    // MARK: - Deal

    var canDeal: Bool { deck.count > 0 && phase == .playing }

    func dealRound() {
        guard deck.count > 0 else {
            phase = .lost
            lastMessage = "No cards left — game over"
            let remaining = stacks.reduce(0) { $0 + $1.count }
            StatsStore.shared.recordLoss(cardsRemaining: remaining, hadAceKiller: hadAceKiller)
            return
        }
        roundNumber += 1
        selectedStack = nil
        for i in 0..<4 {
            if let card = deck.drawOne() {
                stacks[i].append(card)
            }
        }
        lastMessage = "Round \(roundNumber) of 13 — \(deck.count) cards remaining"
        checkAceKiller()
        checkWin()
    }

    // MARK: - Private helpers

    private func performAceMove(from: Int, to: Int) {
        guard let card = stacks[from].last, card.isAce else {
            selectedStack = nil
            lastMessage = "No ace to move"
            return
        }
        stacks[from].removeLast()
        stacks[to].append(card)
        selectedStack = nil
        lastMessage = "Moved \(card.displayString) to stack \(to + 1)"
        checkWin()
    }

    private func checkWin() {
        if isWon {
            phase = .won
            StatsStore.shared.recordWin()
        }
    }

    private func checkAceKiller() {
        var newKillerStacks = Set<Int>()
        var newKillerSuit: Suit?

        for (i, stack) in stacks.enumerated() {
            guard stack.count >= 2 else { continue }
            let top = stack[stack.count - 1]
            let under = stack[stack.count - 2]
            if top.value == .king && under.isAce && top.suit == under.suit {
                newKillerStacks.insert(i)
                if !aceKillerStacks.contains(i) {
                    newKillerSuit = top.suit
                }
            }
        }

        let hasNew = !newKillerStacks.subtracting(aceKillerStacks).isEmpty
        aceKillerStacks = newKillerStacks

        if hasNew, let suit = newKillerSuit {
            hadAceKiller = true
            aceKillerSuit = suit
            showAceKillerAlert = true
        }
    }
}
