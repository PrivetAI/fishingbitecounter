import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    // Using a simpler approach: passing index directly
    // 0: Holes, 1: Stats, 2: History, 3: Baits
    
    var body: some View {
        HStack(spacing: 0) {
            // Tab 1: Holes
            TabBarButton(
                icon: Icons.HoleIcon(size: 24, color: selectedTab == 0 ? Color(hex: "1E88E5") : .gray),
                label: "Holes",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            // Tab 2: Stats
            TabBarButton(
                icon: Icons.ChartIcon(size: 24, color: selectedTab == 1 ? Color(hex: "1E88E5") : .gray),
                label: "Stats",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
            
            // Tab 3: History
            TabBarButton(
                icon: Icons.HistoryIcon(size: 24, color: selectedTab == 2 ? Color(hex: "1E88E5") : .gray),
                label: "History",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }
            
            // Tab 4: Baits (New)
            TabBarButton(
                icon: Icons.BaitIcon(size: 24, color: selectedTab == 3 ? Color(hex: "1E88E5") : .gray),
                label: "Baits",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 20)
        .background(Color(hex: "0D0D1A"))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(hex: "1E88E5").opacity(0.1)),
            alignment: .top
        )
    }
}

struct TabBarButton<Icon: View>: View {
    let icon: Icon
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                icon
                
                Text(label)
                    .font(.caption2)
                    .foregroundColor(isSelected ? Color(hex: "1E88E5") : .gray)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle()) // Make entire area tappable
        }
        .buttonStyle(PlainButtonStyle())
    }
}
