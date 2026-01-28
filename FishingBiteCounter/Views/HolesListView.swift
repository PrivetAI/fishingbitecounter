import SwiftUI
import AudioToolbox

struct HolesListView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var showingAddHole = false
    @State private var newHoleName = ""
    @State private var newHoleBait = ""
    @State private var selectedHole: Hole?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(hex: "0D0D1A")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Content
                    if dataManager.currentSession.holes.isEmpty {
                        emptyStateView
                    } else {
                        holesListView
                    }
                }
                
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        addHoleButton
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddHole) {
                addHoleSheet
            }
            .sheet(item: $selectedHole) { hole in
                HoleDetailView(hole: hole)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Fishing Session")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("\(dataManager.currentSession.holes.count) holes active")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Quick stats
                HStack(spacing: 16) {
                    VStack(spacing: 2) {
                        Text("\(dataManager.currentSession.totalBites)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                        Text("bites")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(spacing: 2) {
                        Text("\(dataManager.currentSession.totalFish)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "4CAF50"))
                        Text("fish")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
        }
        .background(Color(hex: "0D0D1A"))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Icons.HoleIcon(size: 60, color: Color(hex: "1E88E5").opacity(0.5))
            
            Text("No Holes Yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Tap the button below to add your first fishing hole")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var holesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(dataManager.currentSession.holes) { hole in
                    HoleCardView(
                        hole: hole,
                        onAddBite: {
                            addBite(to: hole, wasCaught: false)
                        },
                        onAddFish: {
                            addBite(to: hole, wasCaught: true)
                        },
                        onTap: {
                            selectedHole = hole
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100) // Space for floating button
        }
    }
    
    private var addHoleButton: some View {
        Button(action: { showingAddHole = true }) {
            HStack(spacing: 8) {
                Icons.PlusIcon(size: 20, color: .white)
                Text("New Hole")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "1E88E5"), Color(hex: "1565C0")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .shadow(color: Color(hex: "1E88E5").opacity(0.4), radius: 8, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var addHoleSheet: some View {
        NavigationView {
            ZStack {
                Color(hex: "0D0D1A")
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Icons.HoleIcon(size: 50, color: Color(hex: "1E88E5"))
                        .padding(.top, 20)
                    
                    Text("Add New Hole")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    VStack(spacing: 16) {
                        TextField("Hole name", text: $newHoleName)
                            .textFieldStyle(CustomTextFieldStyle())
                        
                        HStack(spacing: 8) {
                            Icons.BaitIcon(size: 20, color: .orange)
                            TextField("Bait (optional)", text: $newHoleBait)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Text("e.g. Bloodworm, Maggot, Mormyshka")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    CustomButton(
                        title: "Add Hole",
                        icon: AnyView(Icons.PlusIcon(size: 18, color: .white)),
                        isLarge: true
                    ) {
                        addNewHole()
                    }
                    .disabled(newHoleName.isEmpty)
                    .opacity(newHoleName.isEmpty ? 0.5 : 1)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                showingAddHole = false
                newHoleName = ""
                newHoleBait = ""
            }
            .foregroundColor(Color(hex: "1E88E5")))
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Actions
    
    private func addNewHole() {
        guard !newHoleName.isEmpty else { return }
        let bait = newHoleBait.isEmpty ? nil : newHoleBait
        dataManager.addHole(name: newHoleName, bait: bait)
        newHoleName = ""
        newHoleBait = ""
        showingAddHole = false
    }
    
    private func addBite(to hole: Hole, wasCaught: Bool) {
        dataManager.addBite(to: hole.id, wasCaught: wasCaught)
        // Play sound
        AudioServicesPlaySystemSound(1104)
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

// MARK: - Custom TextField Style

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "1A1A2E"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "1E88E5").opacity(0.3), lineWidth: 1)
                    )
            )
            .foregroundColor(.white)
    }
}
