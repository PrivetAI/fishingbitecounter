import SwiftUI

struct HoleDetailView: View {
    @ObservedObject var dataManager = DataManager.shared
    @Environment(\.dismiss) var dismiss
    
    let hole: Hole
    
    @State private var depth: String = ""
    @State private var bait: String = ""
    @State private var notes: String = ""
    @State private var showingDeleteAlert = false
    @State private var showingResetAlert = false
    
    private var currentHole: Hole? {
        dataManager.currentSession.holes.first { $0.id == hole.id }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0D0D1A")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Stats Section
                        statsSection
                        
                        // Details Section
                        detailsSection
                        
                        // Bite History Section
                        biteHistorySection
                        
                        // Actions Section
                        actionsSection
                    }
                    .padding(16)
                }
            }
            .navigationTitle(currentHole?.name ?? hole.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveChanges()
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "1E88E5"))
                }
            }
            .onAppear {
                loadHoleData()
            }
            .alert("Delete Hole", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deleteHole()
                }
            } message: {
                Text("Are you sure you want to delete this hole? This action cannot be undone.")
            }
            .alert("Reset Counter", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    resetHole()
                }
            } message: {
                Text("This will reset all bite and catch counters to zero.")
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Sections
    
    private var statsSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Bites stat
                VStack(spacing: 8) {
                    Icons.BiteIcon(size: 28, color: .yellow)
                    Text("\(currentHole?.biteCount ?? 0)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Bites")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "1A1A2E"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                        )
                )
                
                // Fish stat
                VStack(spacing: 8) {
                    Icons.FishIcon(size: 28, color: Color(hex: "4CAF50"))
                    Text("\(currentHole?.fishCaughtCount ?? 0)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Caught")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "1A1A2E"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "4CAF50").opacity(0.3), lineWidth: 1)
                        )
                )
            }
            
            // Created time
            HStack {
                Icons.HistoryIcon(size: 16, color: .gray)
                Text("Created: \(formatDate(currentHole?.createdAt ?? hole.createdAt))")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if let lastBite = currentHole?.lastBiteAt {
                    Text("Last bite: \(formatRelativeTime(lastBite))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .font(.headline)
                .foregroundColor(.white)
            
            // Depth
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Icons.DepthIcon(size: 18, color: .cyan)
                    Text("Depth (metres)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                TextField("e.g. 3.5", text: $depth)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            // Bait
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Icons.BaitIcon(size: 18, color: .orange)
                    Text("Bait")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                TextField("e.g. Bloodworm, Maggot", text: $bait)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            // Notes
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Icons.NotesIcon(size: 18, color: .white)
                    Text("Notes")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                TextEditor(text: $notes)
                    .frame(minHeight: 80)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "1A1A2E"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "1E88E5").opacity(0.3), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1A1A2E").opacity(0.5))
        )
    }
    
    private var biteHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bite History")
                .font(.headline)
                .foregroundColor(.white)
            
            let bites = currentHole?.biteHistory ?? []
            
            if bites.isEmpty {
                Text("No bites recorded yet")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(bites.reversed().prefix(10)) { bite in
                    HStack {
                        if bite.wasCaught {
                            Icons.FishIcon(size: 16, color: Color(hex: "4CAF50"))
                            Text("Catch")
                                .foregroundColor(Color(hex: "4CAF50"))
                        } else {
                            Icons.BiteIcon(size: 16, color: .yellow)
                            Text("Bite")
                                .foregroundColor(.yellow)
                        }
                        
                        Spacer()
                        
                        Text(formatTime(bite.timestamp))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .font(.subheadline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "1A1A2E"))
                    )
                }
                
                if bites.count > 10 {
                    Text("+ \(bites.count - 10) more")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1A1A2E").opacity(0.5))
        )
    }
    
    private var actionsSection: some View {
        VStack(spacing: 12) {
            // Reset button
            Button(action: { showingResetAlert = true }) {
                HStack(spacing: 8) {
                    Icons.ResetIcon(size: 20, color: .orange)
                    Text("Reset Counter")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange, lineWidth: 1)
                )
            }
            .buttonStyle(ScaleButtonStyle())
            
            // Delete button
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 8) {
                    Icons.TrashIcon(size: 20, color: .red)
                    Text("Delete Hole")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red, lineWidth: 1)
                )
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.top, 8)
    }
    
    // MARK: - Helpers
    
    private func loadHoleData() {
        if let hole = currentHole {
            depth = hole.depth.map { String($0) } ?? ""
            bait = hole.bait ?? ""
            notes = hole.notes ?? ""
        }
    }
    
    private func saveChanges() {
        guard var updatedHole = currentHole else { return }
        updatedHole.depth = Double(depth)
        updatedHole.bait = bait.isEmpty ? nil : bait
        updatedHole.notes = notes.isEmpty ? nil : notes
        dataManager.updateHole(updatedHole)
    }
    
    private func resetHole() {
        dataManager.resetHole(hole.id)
    }
    
    private func deleteHole() {
        dataManager.deleteHole(hole)
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatRelativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
