import SwiftUI

struct BaitPerformanceView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var performances: [DataManager.BaitPerformance] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0D0D1A")
                    .ignoresSafeArea()
                
                if performances.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header Stats
                            if let best = performances.first {
                                bestBaitCard(best)
                            }
                            
                            // List
                            VStack(alignment: .leading, spacing: 12) {
                                Text("All Baits")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                
                                ForEach(performances) { perf in
                                    baitRow(perf)
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Bait Lab")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                refreshData()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.dark)
    }
    
    private func refreshData() {
        performances = dataManager.getBaitPerformance()
    }
    
    // MARK: - Views
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            Icons.BaitIcon(size: 60, color: Color(hex: "1E88E5").opacity(0.5))
            
            Text("No Bait Data")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Enter bait details in your fishing holes to see analytics here.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
    
    private func bestBaitCard(_ perf: DataManager.BaitPerformance) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Icons.FishIcon(size: 20, color: .yellow)
                Text("Most Productive")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                Spacer()
            }
            
            Text(perf.name)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Catches")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(perf.catches)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "4CAF50"))
                }
                
                Divider().frame(height: 24).background(Color.white.opacity(0.2))
                
                VStack(alignment: .leading) {
                    Text("Efficiency")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(String(format: "%.0f%%", perf.efficiency))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "1E88E5").opacity(0.2), Color(hex: "1A1A2E")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "1E88E5").opacity(0.4), lineWidth: 1)
                )
        )
    }
    
    private func baitRow(_ perf: DataManager.BaitPerformance) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(perf.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(perf.bites) bites recorded")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Catch count badge
                HStack(spacing: 4) {
                    Icons.FishIcon(size: 14, color: Color(hex: "4CAF50"))
                    Text("\(perf.catches)")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color(hex: "4CAF50").opacity(0.2))
                .cornerRadius(8)
                
                // Efficiency badge
                Text(String(format: "%.0f%%", perf.efficiency))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(Color.cyan)
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "1A1A2E"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
        )
    }
}
