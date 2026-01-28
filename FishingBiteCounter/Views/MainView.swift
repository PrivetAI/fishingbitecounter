import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    
    // Hide standard tab bar by not using TabView standard style
    // Instead use a ZStack to swap views manually
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content Area
            Group {
                switch selectedTab {
                case 0:
                    HolesListView()
                case 1:
                    StatisticsView()
                case 2:
                    SessionHistoryView()
                case 3:
                    BaitPerformanceView()
                default:
                    HolesListView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 60) // Space for custom tab bar
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
                .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color(hex: "0D0D1A").ignoresSafeArea())
    }
}
