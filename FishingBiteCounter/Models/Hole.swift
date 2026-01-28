import Foundation

struct Hole: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var biteCount: Int
    var fishCaughtCount: Int
    var depth: Double?
    var bait: String?
    var notes: String?
    let createdAt: Date
    var lastBiteAt: Date?
    var biteHistory: [Bite]
    
    init(
        id: UUID = UUID(),
        name: String,
        biteCount: Int = 0,
        fishCaughtCount: Int = 0,
        depth: Double? = nil,
        bait: String? = nil,
        notes: String? = nil,
        createdAt: Date = Date(),
        lastBiteAt: Date? = nil,
        biteHistory: [Bite] = []
    ) {
        self.id = id
        self.name = name
        self.biteCount = biteCount
        self.fishCaughtCount = fishCaughtCount
        self.depth = depth
        self.bait = bait
        self.notes = notes
        self.createdAt = createdAt
        self.lastBiteAt = lastBiteAt
        self.biteHistory = biteHistory
    }
    
    mutating func addBite(wasCaught: Bool) {
        let bite = Bite(wasCaught: wasCaught)
        biteHistory.append(bite)
        biteCount += 1
        lastBiteAt = bite.timestamp
        if wasCaught {
            fishCaughtCount += 1
        }
    }
    
    mutating func reset() {
        biteCount = 0
        fishCaughtCount = 0
        lastBiteAt = nil
        biteHistory = []
    }
}
