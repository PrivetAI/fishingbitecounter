import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HolesListView()
                .tabItem {
                    VStack {
                        Icons.HoleIcon(size: 24, color: selectedTab == 0 ? Color(hex: "1E88E5") : .gray)
                        Text("Holes")
                    }
                }
                .tag(0)
            
            StatisticsView()
                .tabItem {
                    VStack {
                        Icons.ChartIcon(size: 24, color: selectedTab == 1 ? Color(hex: "1E88E5") : .gray)
                        Text("Stats")
                    }
                }
                .tag(1)
            
            SessionHistoryView()
                .tabItem {
                    VStack {
                        Icons.HistoryIcon(size: 24, color: selectedTab == 2 ? Color(hex: "1E88E5") : .gray)
                        Text("History")
                    }
                }
                .tag(2)
        }
        .accentColor(Color(hex: "1E88E5"))
        .preferredColorScheme(.dark)
        .onAppear {
            // Custom tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color(hex: "0D0D1A"))
            
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color(hex: "1E88E5"))
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color(hex: "1E88E5"))]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
