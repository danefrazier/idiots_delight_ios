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

    // Hint mode
    var hintMode: Bool = false

    var hintStackIndex: Int? {
        guard hintMode else { return nil }
        // Prefer optimal move (lowest of suit — no advisory)
        for i in 0..<4 {
            let (ok, advisory) = canRemove(stackIndex: i)
            if ok && advisory.isEmpty { return i }
        }
        // Fall back to any legal move
        for i in 0..<4 {
            if canRemove(stackIndex: i).0 { return i }
        }
        // Moveable ace — only hint if the ace has cards beneath it (sole ace has no best destination)
        let hasEmptyStack = stacks.contains { $0.isEmpty }
        if hasEmptyStack {
            for (i, stack) in stacks.enumerated() {
                if let top = stack.last, top.isAce, stack.count > 1 { return i }
            }
        }
        return nil
    }

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

    // MARK: - Available moves

    var hasAvailableMoves: Bool {
        for i in 0..<4 {
            if canRemove(stackIndex: i).0 { return true }
        }
        let hasEmptyStack = stacks.contains { $0.isEmpty }
        if hasEmptyStack {
            for stack in stacks {
                if let top = stack.last, top.isAce { return true }
            }
        }
        return false
    }

    // MARK: - Win check

    var isWon: Bool {
        stacks.allSatisfy { $0.count == 1 && $0.last?.isAce == true }
    }

    // MARK: - Removal validation

    // Returns (legal, advisory).
    // legal=false means the move is not allowed.
    // legal=true with non-empty advisory means allowed but not optimal (hint mode shows advisory).
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
        // Legal if at least one same-suit card showing is higher
        guard sameSuit.contains(where: { $0.value.numericValue > card.value.numericValue }) else {
            return (false, "\(card.displayString) is the highest \(card.suit.rawValue) showing — cannot remove")
        }
        // Advisory: a lower same-suit card is also showing (not the optimal move)
        if let lower = sameSuit.filter({ $0.value.numericValue < card.value.numericValue })
            .min(by: { $0.value.numericValue < $1.value.numericValue }) {
            return (true, "\(card.displayString) is a legal move, but \(lower.displayString) is lower — you may want to consider that card")
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
            lastMessage = "\(card.displayString) selected — tap an empty stack to move"
        } else {
            let (ok, advisory) = canRemove(stackIndex: index)
            if ok {
                let removed = stacks[index].removeLast()
                lastMessage = "Removed \(removed.displayString)"
                checkWin()
                checkAvailableMoves()
            } else {
                lastMessage = advisory
            }
        }
    }

    // MARK: - Deal

    var canDeal: Bool { deck.count > 0 && phase == .playing }

    func dealRound() {
        guard deck.count > 0 else {
            lastMessage = "No cards left — game over"
            let remaining = stacks.reduce(0) { $0 + $1.count }
            StatsStore.shared.recordLoss(cardsRemaining: remaining, hadAceKiller: hadAceKiller)
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(2))
                guard phase == .playing else { return }
                phase = .lost
            }
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
        checkAvailableMoves()
    }

    // MARK: - Private helpers

    private func performAceMove(from: Int, to: Int) {
        guard let card = stacks[from].last, card.isAce else {
            selectedStack = nil
            lastMessage = "No ace to move"
            return
        }
        guard stacks[to].isEmpty else {
            lastMessage = "Aces can only be moved to empty stacks"
            return
        }
        stacks[from].removeLast()
        stacks[to].append(card)
        selectedStack = nil
        lastMessage = "Moved \(card.displayString) to stack \(to + 1)"
        checkWin()
        checkAvailableMoves()
    }

    private func checkWin() {
        if isWon {
            lastMessage = "You win! Four aces."
            StatsStore.shared.recordWin()
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(2))
                guard phase == .playing else { return }
                phase = .won
            }
        }
    }

    private func checkAvailableMoves() {
        guard phase == .playing else { return }
        guard !hasAvailableMoves && deck.count == 0 else { return }
        lastMessage = "No further moves — game over"
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            guard phase == .playing else { return }
            phase = .lost
            let remaining = stacks.reduce(0) { $0 + $1.count }
            StatsStore.shared.recordLoss(cardsRemaining: remaining, hadAceKiller: hadAceKiller)
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
            StatsStore.shared.recordAceKiller()
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(2))
                showAceKillerAlert = true
            }
        }
    }
}
