import SwiftUI

struct HoleCardView: View {
    let hole: Hole
    let onAddBite: () -> Void
    let onAddFish: () -> Void
    let onTap: () -> Void
    
    private var lastBiteText: String {
        guard let lastBite = hole.lastBiteAt else {
            return "No bites yet"
        }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: lastBite, relativeTo: Date())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content - tappable
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 12) {
                    // Header
                    HStack {
                        HStack(spacing: 8) {
                            Icons.HoleIcon(size: 20, color: Color(hex: "1E88E5"))
                            Text(hole.name)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text(lastBiteText)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Bait badge (if set)
                    if let bait = hole.bait, !bait.isEmpty {
                        HStack(spacing: 6) {
                            Icons.BaitIcon(size: 14, color: .orange)
                            Text(bait)
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(8)
                    }
                    
                    // Stats
                    HStack(spacing: 16) {
                        // Bites
                        HStack(spacing: 6) {
                            Icons.BiteIcon(size: 18, color: .yellow)
                            Text("\(hole.biteCount)")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("bites")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Divider()
                            .frame(height: 24)
                            .background(Color.gray.opacity(0.3))
                        
                        // Fish
                        HStack(spacing: 6) {
                            Icons.FishIcon(size: 18, color: Color(hex: "4CAF50"))
                            Text("\(hole.fishCaughtCount)")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("caught")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .background(Color.gray.opacity(0.2))
            
            // Action buttons
            HStack(spacing: 0) {
                // Add Bite button
                Button(action: onAddBite) {
                    HStack(spacing: 6) {
                        Icons.PlusIcon(size: 16, color: .yellow)
                        Text("Bite")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.yellow)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.yellow.opacity(0.1))
                }
                .buttonStyle(ScaleButtonStyle())
                
                Divider()
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.2))
                
                // Add Fish button
                Button(action: onAddFish) {
                    HStack(spacing: 6) {
                        Icons.PlusIcon(size: 16, color: Color(hex: "4CAF50"))
                        Text("Catch")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "4CAF50"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(hex: "4CAF50").opacity(0.1))
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1A1A2E"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "1E88E5").opacity(0.2), lineWidth: 1)
        )
    }
}
