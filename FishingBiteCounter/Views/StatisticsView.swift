import SwiftUI

struct StatisticsView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var showingEndSessionAlert = false
    
    private var session: FishingSession {
        dataManager.currentSession
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0D0D1A")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Session duration
                        durationCard
                        
                        // Stats grid
                        statsGrid
                        
                        // Best hole
                        if let bestHole = session.mostProductiveHole, bestHole.biteCount > 0 {
                            bestHoleCard(bestHole)
                        }
                        
                        // Hourly chart
                        HourlyChart(data: session.hourlyBiteDistribution)
                        
                        // End session button
                        if !session.holes.isEmpty {
                            endSessionButton
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
            .alert("End Session", isPresented: $showingEndSessionAlert) {
                Button("Cancel", role: .cancel) {}
                Button("End Session", role: .destructive) {
                    dataManager.endCurrentSession()
                }
            } message: {
                Text("This will save the current session to history and start a new one.")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Subviews
    
    private var durationCard: some View {
        VStack(spacing: 8) {
            Text("Session Duration")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(session.formattedDuration)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Started: \(formatTime(session.startedAt))")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "1E88E5").opacity(0.3), Color(hex: "1A1A2E")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "1E88E5").opacity(0.5), lineWidth: 1)
                )
        )
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            StatCard(
                title: "Total Holes",
                value: "\(session.holes.count)",
                icon: AnyView(Icons.HoleIcon(size: 18, color: Color(hex: "1E88E5")))
            )
            
            StatCard(
                title: "Total Bites",
                value: "\(session.totalBites)",
                icon: AnyView(Icons.BiteIcon(size: 18, color: .yellow)),
                accentColor: .yellow
            )
            
            StatCard(
                title: "Fish Caught",
                value: "\(session.totalFish)",
                icon: AnyView(Icons.FishIcon(size: 18, color: Color(hex: "4CAF50"))),
                accentColor: Color(hex: "4CAF50")
            )
            
            StatCard(
                title: "Catch Rate",
                value: catchRateText,
                icon: AnyView(Icons.ChartIcon(size: 18, color: .cyan)),
                accentColor: .cyan
            )
        }
    }
    
    private var catchRateText: String {
        guard session.totalBites > 0 else { return "0%" }
        let rate = Double(session.totalFish) / Double(session.totalBites) * 100
        return String(format: "%.0f%%", rate)
    }
    
    private func bestHoleCard(_ hole: Hole) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Icons.FishIcon(size: 20, color: .yellow)
                Text("Most Productive Hole")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(hole.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("\(hole.biteCount) bites · \(hole.fishCaughtCount) fish caught")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Icons.HoleIcon(size: 40, color: Color(hex: "1E88E5"))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1A1A2E"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var endSessionButton: some View {
        Button(action: { showingEndSessionAlert = true }) {
            HStack(spacing: 8) {
                Icons.HistoryIcon(size: 20, color: .white)
                Text("End Session & Save")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "E53935"))
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.top, 8)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
