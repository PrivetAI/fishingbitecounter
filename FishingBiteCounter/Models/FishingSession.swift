import Foundation

struct FishingSession: Identifiable, Codable, Equatable {
    let id: UUID
    let startedAt: Date
    var endedAt: Date?
    var holes: [Hole]
    
    init(
        id: UUID = UUID(),
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        holes: [Hole] = []
    ) {
        self.id = id
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.holes = holes
    }
    
    var totalBites: Int {
        holes.reduce(0) { $0 + $1.biteCount }
    }
    
    var totalFish: Int {
        holes.reduce(0) { $0 + $1.fishCaughtCount }
    }
    
    var mostProductiveHole: Hole? {
        holes.max(by: { $0.biteCount < $1.biteCount })
    }
    
    var duration: TimeInterval {
        let endTime = endedAt ?? Date()
        return endTime.timeIntervalSince(startedAt)
    }
    
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: startedAt)
    }
    
    // Get hourly bite distribution for chart
    var hourlyBiteDistribution: [Int: Int] {
        var distribution: [Int: Int] = [:]
        for hole in holes {
            for bite in hole.biteHistory {
                let hour = Calendar.current.component(.hour, from: bite.timestamp)
                distribution[hour, default: 0] += 1
            }
        }
        return distribution
    }
}
