import SwiftUI

// MARK: - Custom Icons (drawn without SF Symbols)
struct Icons {
    
    // Fish icon
    struct FishIcon: View {
        var size: CGFloat = 24
        var color: Color = .white
        
        var body: some View {
            Canvas { context, canvasSize in
                let scale = size / 24
                
                // Fish body
                var bodyPath = Path()
                bodyPath.move(to: CGPoint(x: 4 * scale, y: 12 * scale))
                bodyPath.addQuadCurve(
                    to: CGPoint(x: 18 * scale, y: 12 * scale),
                    control: CGPoint(x: 11 * scale, y: 4 * scale)
                )
                bodyPath.addQuadCurve(
                    to: CGPoint(x: 4 * scale, y: 12 * scale),
                    control: CGPoint(x: 11 * scale, y: 20 * scale)
                )
                
                // Tail
                var tailPath = Path()
                tailPath.move(to: CGPoint(x: 4 * scale, y: 12 * scale))
                tailPath.addLine(to: CGPoint(x: 1 * scale, y: 6 * scale))
                tailPath.addLine(to: CGPoint(x: 1 * scale, y: 18 * scale))
                tailPath.closeSubpath()
                
                context.fill(bodyPath, with: .color(color))
                context.fill(tailPath, with: .color(color))
                
                // Eye
                let eyeRect = CGRect(x: 15 * scale, y: 10 * scale, width: 2 * scale, height: 2 * scale)
                context.fill(Path(ellipseIn: eyeRect), with: .color(.black))
            }
            .frame(width: size, height: size)
        }
    }
    
    // Hole/Circle icon
    struct HoleIcon: View {
        var size: CGFloat = 24
        var color: Color = .white
        
        var body: some View {
            ZStack {
                Circle()
                    .stroke(color, lineWidth: 2)
                    .frame(width: size, height: size)
                
                Circle()
                    .fill(color.opacity(0.3))
                    .frame(width: size * 0.6, height: size * 0.6)
            }
        }
    }
    
    // Plus icon
    struct PlusIcon: View {
        var size: CGFloat = 24
        var color: Color = .white
        var lineWidth: CGFloat = 3
        
        var body: some View {
            Canvas { context, _ in
                let center = size / 2
                let length = size * 0.6
                
                var path = Path()
                path.move(to: CGPoint(x: center, y: center - length / 2))
                path.addLine(to: CGPoint(x: center, y: center + length / 2))
                path.move(to: CGPoint(x: center - length / 2, y: center))
                path.addLine(to: CGPoint(x: center + length / 2, y: center))
                
                context.stroke(path, with: .color(color), lineWidth: lineWidth)
            }
            .frame(width: size, height: size)
        }
    }
    
    // Chart/Stats icon
    struct ChartIcon: View {
        var size: CGFloat = 24
        var color: Color = .white
        
        var body: some View {
            Canvas { context, _ in
                let scale = size / 24
                
                // Bars
                let bar1 = CGRect(x: 4 * scale, y: 14 * scale, width: 4 * scale, height: 6 * scale)
                let bar2 = CGRect(x: 10 * scale, y: 8 * scale, width: 4 * scale, height: 12 * scale)
                let bar3 = CGRect(x: 16 * scale, y: 4 * scale, width: 4 * scale, height: 16 * scale)
                
                context.fill(Path(roundedRect: bar1, cornerRadius: 1), with: .color(color))
                context.fill(Path(roundedRect: bar2, cornerRadius: 1), with: .color(color))
                context.fill(Path(roundedRect: bar3, cornerRadius: 1), with: .color(color))
            }
            .frame(width: size, height: size)
        }
    }
    
    // History/Clock icon
    struct HistoryIcon: View {
        var size: CGFloat = 24
        var color: Color = .white
        
        var body: some View {
            Canvas { context, _ in
                let center = size / 2
                let radius = size * 0.4
                
                // Circle
                let circleRect = CGRect(x: center - radius, y: center - radius, width: radius * 2, height: radius * 2)
                context.stroke(Path(ellipseIn: circleRect), with: .color(color), lineWidth: 2)
                
                // Hands
                var handsPath = Path()
                handsPath.move(to: CGPoint(x: center, y: center))
                handsPath.addLine(to: CGPoint(x: center, y: center - radius * 0.6))
                handsPath.move(to: CGPoint(x: center, y: center))
                handsPath.addLine(to: CGPoint(x: center + radius * 0.4, y: center))
                
                context.stroke(handsPath, with: .color(color), lineWidth: 2)
            }
            .frame(width: size, height: size)
        }
    }
    
    // Trash/Delete icon
    struct TrashIcon: View {
        var size: CGFloat = 24
        var color: Color = .red
        
        var body: some View {
            Canvas { context, _ in
                let scale = size / 24
                
                // Lid
                var lidPath = Path()
                lidPath.move(to: CGPoint(x: 5 * scale, y: 6 * scale))
                lidPath.addLine(to: CGPoint(x: 19 * scale, y: 6 * scale))
                
                // Handle
                lidPath.move(to: CGPoint(x: 9 * scale, y: 6 * scale))
                lidPath.addLine(to: CGPoint(x: 9 * scale, y: 4 * scale))
                lidPath.addLine(to: CGPoint(x: 15 * scale, y: 4 * scale))
                lidPath.addLine(to: CGPoint(x: 15 * scale, y: 6 * scale))
                
                context.stroke(lidPath, with: .color(color), lineWidth: 2)
                
                // Body
                var bodyPath = Path()
                bodyPath.move(to: CGPoint(x: 6 * scale, y: 8 * scale))
                bodyPath.addLine(to: CGPoint(x: 7 * scale, y: 20 * scale))
                bodyPath.addLine(to: CGPoint(x: 17 * scale, y: 20 * scale))
                bodyPath.addLine(to: CGPoint(x: 18 * scale, y: 8 * scale))
                
                context.stroke(bodyPath, with: .color(color), lineWidth: 2)
                
                // Lines
                var linesPath = Path()
                linesPath.move(to: CGPoint(x: 10 * scale, y: 10 * scale))
                linesPath.addLine(to: CGPoint(x: 10 * scale, y: 17 * scale))
                linesPath.move(to: CGPoint(x: 14 * scale, y: 10 * scale))
                linesPath.addLine(to: CGPoint(x: 14 * scale, y: 17 * scale))
                
                context.stroke(linesPath, with: .color(color), lineWidth: 1.5)
            }
            .frame(width: size, height: size)
        }
    }
    
    // Reset icon
    struct ResetIcon: View {
        var size: CGFloat = 24
        var color: Color = .orange
        
        var body: some View {
            Canvas { context, _ in
                let center = size / 2
                let radius = size * 0.35
                
                // Arc
                var arcPath = Path()
                arcPath.addArc(
                    center: CGPoint(x: center, y: center),
                    radius: radius,
                    startAngle: .degrees(-60),
                    endAngle: .degrees(200),
                    clockwise: false
                )
                
                context.stroke(arcPath, with: .color(color), lineWidth: 2.5)
                
                // Arrow
                var arrowPath = Path()
                let arrowTip = CGPoint(x: center + radius * cos(.pi * 200 / 180), y: center + radius * sin(.pi * 200 / 180))
                arrowPath.move(to: CGPoint(x: arrowTip.x - 4, y: arrowTip.y - 4))
                arrowPath.addLine(to: arrowTip)
                arrowPath.addLine(to: CGPoint(x: arrowTip.x + 4, y: arrowTip.y - 2))
                
                context.stroke(arrowPath, with: .color(color), lineWidth: 2.5)
            }
            .frame(width: size, height: size)
        }
    }
    
    // Bite/Lightning icon
    struct BiteIcon: View {
        var size: CGFloat = 24
        var color: Color = .yellow
        
        var body: some View {
            Canvas { context, _ in
                let scale = size / 24
                
                var path = Path()
                path.move(to: CGPoint(x: 14 * scale, y: 2 * scale))
                path.addLine(to: CGPoint(x: 8 * scale, y: 12 * scale))
                path.addLine(to: CGPoint(x: 12 * scale, y: 12 * scale))
                path.addLine(to: CGPoint(x: 10 * scale, y: 22 * scale))
                path.addLine(to: CGPoint(x: 16 * scale, y: 10 * scale))
                path.addLine(to: CGPoint(x: 12 * scale, y: 10 * scale))
                path.closeSubpath()
                
                context.fill(path, with: .color(color))
            }
            .frame(width: size, height: size)
        }
    }
    
    // Depth icon (waves)
    struct DepthIcon: View {
        var size: CGFloat = 24
        var color: Color = .cyan
        
        var body: some View {
            Canvas { context, _ in
                let scale = size / 24
                
                for i in 0..<3 {
                    let y = CGFloat(8 + i * 5) * scale
                    var wavePath = Path()
                    wavePath.move(to: CGPoint(x: 4 * scale, y: y))
                    wavePath.addQuadCurve(
                        to: CGPoint(x: 12 * scale, y: y),
                        control: CGPoint(x: 8 * scale, y: y - 3 * scale)
                    )
                    wavePath.addQuadCurve(
                        to: CGPoint(x: 20 * scale, y: y),
                        control: CGPoint(x: 16 * scale, y: y + 3 * scale)
                    )
                    
                    context.stroke(wavePath, with: .color(color.opacity(1 - Double(i) * 0.25)), lineWidth: 2)
                }
            }
            .frame(width: size, height: size)
        }
    }
    
    // Bait/Hook icon
    struct BaitIcon: View {
        var size: CGFloat = 24
        var color: Color = .orange
        
        var body: some View {
            Canvas { context, _ in
                let scale = size / 24
                
                // Line
                var linePath = Path()
                linePath.move(to: CGPoint(x: 12 * scale, y: 2 * scale))
                linePath.addLine(to: CGPoint(x: 12 * scale, y: 8 * scale))
                
                context.stroke(linePath, with: .color(.gray), lineWidth: 1.5)
                
                // Hook
                var hookPath = Path()
                hookPath.move(to: CGPoint(x: 12 * scale, y: 8 * scale))
                hookPath.addQuadCurve(
                    to: CGPoint(x: 8 * scale, y: 16 * scale),
                    control: CGPoint(x: 6 * scale, y: 10 * scale)
                )
                hookPath.addQuadCurve(
                    to: CGPoint(x: 14 * scale, y: 18 * scale),
                    control: CGPoint(x: 8 * scale, y: 22 * scale)
                )
                
                context.stroke(hookPath, with: .color(color), lineWidth: 2)
                
                // Point
                var pointPath = Path()
                pointPath.move(to: CGPoint(x: 14 * scale, y: 18 * scale))
                pointPath.addLine(to: CGPoint(x: 16 * scale, y: 16 * scale))
                
                context.stroke(pointPath, with: .color(color), lineWidth: 2)
            }
            .frame(width: size, height: size)
        }
    }
    
    // Notes icon
    struct NotesIcon: View {
        var size: CGFloat = 24
        var color: Color = .white
        
        var body: some View {
            Canvas { context, _ in
                let scale = size / 24
                
                // Paper
                let paperRect = CGRect(x: 5 * scale, y: 3 * scale, width: 14 * scale, height: 18 * scale)
                context.stroke(Path(roundedRect: paperRect, cornerRadius: 2), with: .color(color), lineWidth: 2)
                
                // Lines
                var linesPath = Path()
                for i in 0..<3 {
                    let y = CGFloat(8 + i * 4) * scale
                    linesPath.move(to: CGPoint(x: 8 * scale, y: y))
                    linesPath.addLine(to: CGPoint(x: 16 * scale, y: y))
                }
                
                context.stroke(linesPath, with: .color(color.opacity(0.6)), lineWidth: 1.5)
            }
            .frame(width: size, height: size)
        }
    }
}
