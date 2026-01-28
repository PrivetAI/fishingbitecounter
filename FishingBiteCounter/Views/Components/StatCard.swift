import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    var icon: AnyView
    var accentColor: Color = Color(hex: "1E88E5")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                icon
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1A1A2E"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(accentColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct HourlyChart: View {
    let data: [Int: Int]
    var accentColor: Color = Color(hex: "1E88E5")
    
    private var sortedData: [(hour: Int, count: Int)] {
        let allHours = data.map { ($0.key, $0.value) }
        return allHours.sorted { $0.0 < $1.0 }
    }
    
    private var maxValue: Int {
        data.values.max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bites by Hour")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if data.isEmpty {
                Text("No data yet")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                HStack(alignment: .bottom, spacing: 4) {
                    ForEach(sortedData, id: \.hour) { item in
                        VStack(spacing: 4) {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [accentColor, accentColor.opacity(0.5)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 20, height: CGFloat(item.count) / CGFloat(maxValue) * 60)
                                .cornerRadius(4)
                            
                            Text("\(item.hour)")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1A1A2E"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(accentColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}
