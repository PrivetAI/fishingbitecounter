import Foundation
import SwiftUI

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let currentSessionKey = "currentSession"
    private let sessionHistoryKey = "sessionHistory"
    
    @Published var currentSession: FishingSession
    @Published var sessionHistory: [FishingSession]
    
    private init() {
        // Load current session
        if let data = UserDefaults.standard.data(forKey: currentSessionKey),
           let session = try? JSONDecoder().decode(FishingSession.self, from: data) {
            self.currentSession = session
        } else {
            self.currentSession = FishingSession()
        }
        
        // Load session history
        if let data = UserDefaults.standard.data(forKey: sessionHistoryKey),
           let history = try? JSONDecoder().decode([FishingSession].self, from: data) {
            self.sessionHistory = history
        } else {
            self.sessionHistory = []
        }
    }
    
    // MARK: - Persistence
    
    func saveCurrentSession() {
        if let data = try? JSONEncoder().encode(currentSession) {
            UserDefaults.standard.set(data, forKey: currentSessionKey)
        }
    }
    
    func saveSessionHistory() {
        if let data = try? JSONEncoder().encode(sessionHistory) {
            UserDefaults.standard.set(data, forKey: sessionHistoryKey)
        }
    }
    
    // MARK: - Hole Operations
    
    func addHole(name: String) {
        let hole = Hole(name: name)
        currentSession.holes.append(hole)
        saveCurrentSession()
    }
    
    func updateHole(_ hole: Hole) {
        if let index = currentSession.holes.firstIndex(where: { $0.id == hole.id }) {
            currentSession.holes[index] = hole
            saveCurrentSession()
        }
    }
    
    func deleteHole(_ hole: Hole) {
        currentSession.holes.removeAll { $0.id == hole.id }
        saveCurrentSession()
    }
    
    func addBite(to holeId: UUID, wasCaught: Bool) {
        if let index = currentSession.holes.firstIndex(where: { $0.id == holeId }) {
            currentSession.holes[index].addBite(wasCaught: wasCaught)
            saveCurrentSession()
        }
    }
    
    func resetHole(_ holeId: UUID) {
        if let index = currentSession.holes.firstIndex(where: { $0.id == holeId }) {
            currentSession.holes[index].reset()
            saveCurrentSession()
        }
    }
    
    // MARK: - Session Operations
    
    func endCurrentSession() {
        guard !currentSession.holes.isEmpty else { return }
        
        var endedSession = currentSession
        endedSession.endedAt = Date()
        sessionHistory.insert(endedSession, at: 0)
        saveSessionHistory()
        
        // Start new session
        currentSession = FishingSession()
        saveCurrentSession()
    }
    
    func deleteHistorySession(_ session: FishingSession) {
        sessionHistory.removeAll { $0.id == session.id }
        saveSessionHistory()
    }
    
    func clearHistory() {
        sessionHistory = []
        saveSessionHistory()
    }
}
