import Foundation

struct GameStats: Codable {
    var gamesPlayed: Int = 0
    var gamesWon: Int = 0
    var gamesLost: Int = 0
    var cardsRemainingOnLoss: [Int] = []
    var aceKillerLosses: Int = 0

    var winRate: Double {
        gamesPlayed > 0 ? Double(gamesWon) / Double(gamesPlayed) : 0
    }

    var avgCardsRemainingOnLoss: Double {
        guard !cardsRemainingOnLoss.isEmpty else { return 0 }
        return Double(cardsRemainingOnLoss.reduce(0, +)) / Double(cardsRemainingOnLoss.count)
    }
}

class StatsStore {
    static let shared = StatsStore()
    private let key = "idiotsDelight.gameStats"

    func load() -> GameStats {
        guard let data = UserDefaults.standard.data(forKey: key),
              let stats = try? JSONDecoder().decode(GameStats.self, from: data) else {
            return GameStats()
        }
        return stats
    }

    func recordWin() {
        var stats = load()
        stats.gamesPlayed += 1
        stats.gamesWon += 1
        save(stats)
    }

    func recordLoss(cardsRemaining: Int, hadAceKiller: Bool) {
        var stats = load()
        stats.gamesPlayed += 1
        stats.gamesLost += 1
        stats.cardsRemainingOnLoss.append(cardsRemaining)
        if hadAceKiller { stats.aceKillerLosses += 1 }
        save(stats)
    }

    func resetStats() {
        save(GameStats())
    }

    private func save(_ stats: GameStats) {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
