import Foundation

extension DataManager {
    // Analytics struct for a specific bait
    struct BaitPerformance: Identifiable, Equatable {
        let id = UUID()
        let name: String
        var bites: Int
        var catches: Int
        var sessionsCount: Int
        
        var efficiency: Double {
            guard bites > 0 else { return 0 }
            return Double(catches) / Double(bites) * 100
        }
    }
    
    // Calculate performance for all baits across all history including current session
    func getBaitPerformance() -> [BaitPerformance] {
        var performances: [String: BaitPerformance] = [:]
        
        // Helper to process a session
        let processSession = { (session: FishingSession) in
            for hole in session.holes {
                guard let baitName = hole.bait, !baitName.isEmpty else { continue }
                
                // Normalize string (trim whitespace, lowercase for key)
                let key = baitName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                // Display name (keep original casing of first encounter or capitalized)
                let displayName = baitName.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if var perf = performances[key] {
                    perf.bites += hole.biteCount
                    perf.catches += hole.fishCaughtCount
                    performances[key] = perf
                } else {
                    performances[key] = BaitPerformance(
                        name: displayName,
                        bites: hole.biteCount,
                        catches: hole.fishCaughtCount,
                        sessionsCount: 0 // Will count later if needed, simple for now
                    )
                }
            }
        }
        
        // Process history
        for session in sessionHistory {
            processSession(session)
        }
        
        // Process current session
        processSession(currentSession)
        
        // Sort by catches (most successful first)
        return Array(performances.values).sorted { $0.catches > $1.catches }
    }
}
