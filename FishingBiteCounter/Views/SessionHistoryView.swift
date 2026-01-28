import SwiftUI

struct SessionHistoryView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var selectedSession: FishingSession?
    @State private var showingClearAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0D0D1A")
                    .ignoresSafeArea()
                
                if dataManager.sessionHistory.isEmpty {
                    emptyStateView
                } else {
                    sessionsList
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Group {
                if !dataManager.sessionHistory.isEmpty {
                    Button(action: { showingClearAlert = true }) {
                        Icons.TrashIcon(size: 20, color: .red)
                    }
                }
            })
            .sheet(item: $selectedSession) { session in
                SessionDetailView(session: session)
            }
            .alert("Clear History", isPresented: $showingClearAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Clear All", role: .destructive) {
                    dataManager.clearHistory()
                }
            } message: {
                Text("This will permanently delete all session history.")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.dark)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Icons.HistoryIcon(size: 60, color: Color(hex: "1E88E5").opacity(0.5))
            
            Text("No History Yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Completed fishing sessions will appear here")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var sessionsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(dataManager.sessionHistory) { session in
                    SessionRowView(session: session) {
                        selectedSession = session
                    }
                }
            }
            .padding(16)
        }
    }
}

// MARK: - Session Row

struct SessionRowView: View {
    let session: FishingSession
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Date and duration
                HStack {
                    Text(session.formattedDate)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(session.formattedDuration)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Stats
                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        Icons.HoleIcon(size: 16, color: Color(hex: "1E88E5"))
                        Text("\(session.holes.count)")
                            .foregroundColor(.white)
                        Text("holes")
                            .foregroundColor(.gray)
                    }
                    .font(.subheadline)
                    
                    HStack(spacing: 6) {
                        Icons.BiteIcon(size: 16, color: .yellow)
                        Text("\(session.totalBites)")
                            .foregroundColor(.white)
                        Text("bites")
                            .foregroundColor(.gray)
                    }
                    .font(.subheadline)
                    
                    HStack(spacing: 6) {
                        Icons.FishIcon(size: 16, color: Color(hex: "4CAF50"))
                        Text("\(session.totalFish)")
                            .foregroundColor(.white)
                        Text("caught")
                            .foregroundColor(.gray)
                    }
                    .font(.subheadline)
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1A1A2E"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "1E88E5").opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Session Detail View

struct SessionDetailView: View {
    @Environment(\.dismiss) var dismiss
    let session: FishingSession
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0D0D1A")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Session info
                        VStack(spacing: 8) {
                            Text("Session Details")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(session.formattedDate)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Duration: \(session.formattedDuration)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "1A1A2E"))
                        )
                        
                        // Stats
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            miniStatCard(title: "Holes", value: "\(session.holes.count)", icon: AnyView(Icons.HoleIcon(size: 16, color: Color(hex: "1E88E5"))))
                            miniStatCard(title: "Bites", value: "\(session.totalBites)", icon: AnyView(Icons.BiteIcon(size: 16, color: .yellow)))
                            miniStatCard(title: "Caught", value: "\(session.totalFish)", icon: AnyView(Icons.FishIcon(size: 16, color: Color(hex: "4CAF50"))))
                        }
                        
                        // Holes list
                        if !session.holes.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Holes")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                ForEach(session.holes) { hole in
                                    HStack {
                                        Text(hole.name)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 12) {
                                            HStack(spacing: 4) {
                                                Icons.BiteIcon(size: 14, color: .yellow)
                                                Text("\(hole.biteCount)")
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Icons.FishIcon(size: 14, color: Color(hex: "4CAF50"))
                                                Text("\(hole.fishCaughtCount)")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .font(.subheadline)
                                    }
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: "1A1A2E"))
                                    )
                                }
                            }
                        }
                        
                        // Chart
                        HourlyChart(data: session.hourlyBiteDistribution)
                    }
                    .padding(16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "1E88E5"))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func miniStatCard(title: String, value: String, icon: AnyView) -> some View {
        VStack(spacing: 6) {
            icon
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "1A1A2E"))
        )
    }
}
