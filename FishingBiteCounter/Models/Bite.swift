import Foundation

struct Bite: Identifiable, Codable, Equatable {
    let id: UUID
    let timestamp: Date
    let wasCaught: Bool
    
    init(id: UUID = UUID(), timestamp: Date = Date(), wasCaught: Bool = false) {
        self.id = id
        self.timestamp = timestamp
        self.wasCaught = wasCaught
    }
}
