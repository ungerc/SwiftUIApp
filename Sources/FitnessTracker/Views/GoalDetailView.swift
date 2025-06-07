import SwiftUI

// Simple confetti animation view
struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50) { index in
                ConfettiPiece()
                    .offset(y: animate ? 600 : -100)
                    .animation(
                        Animation.linear(duration: Double.random(in: 2...3))
                            .repeatCount(1, autoreverses: false)
                            .delay(Double.random(in: 0...0.5)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    private let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    private let size = Double.random(in: 8...16)
    private let xPosition = Double.random(in: -200...200)
    private let xMovement = Double.random(in: -100...100)
    private let rotation = Double.random(in: 0...360)
    
    var body: some View {
        Rectangle()
            .fill(colors.randomElement()!)
            .frame(width: size, height: size)
            .offset(x: xPosition + xMovement)
            .rotationEffect(.degrees(rotation))
    }
}

struct GoalDetailView: View {
    let goal: Goal
    @State private var updatedValue: Double
    @State private var showingConfetti = false
    @Environment(GoalViewModel.self) private var goalViewModel

    init(goal: Goal) {
        self.goal = goal
        self._updatedValue = State(initialValue: goal.currentValue)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(goal.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: goal.type.icon)
                            .foregroundColor(.blue)
                        
                        Text(goal.type.rawValue.capitalized)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Progress
                VStack(alignment: .leading, spacing: 10) {
                    Text("Progress")
                        .font(.headline)
                    
                    ProgressView(value: goal.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                    
                    HStack {
                        Text("\(Int(goal.currentValue)) / \(Int(goal.targetValue)) \(goal.unit)")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("\(Int(goal.progress * 100))%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(progressColor)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Deadline
                if let deadline = goal.deadline {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Deadline")
                            .font(.headline)
                        
                        Text(deadline, style: .date)
                            .font(.subheadline)
                        
                        let daysRemaining = Calendar.current.dateComponents([.day], from: Date(), to: deadline).day ?? 0
                        
                        if daysRemaining > 0 {
                            Text("\(daysRemaining) days remaining")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if daysRemaining == 0 {
                            Text("Due today")
                                .font(.caption)
                                .foregroundColor(.orange)
                        } else {
                            Text("Overdue by \(abs(daysRemaining)) days")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Update progress
                VStack(alignment: .leading, spacing: 10) {
                    Text("Update Progress")
                        .font(.headline)
                    
                    VStack {
                        Slider(value: $updatedValue, in: 0...goal.targetValue * 1.2, step: 1)
                        
                        HStack {
                            Text("Current Value: \(Int(updatedValue)) \(goal.unit)")
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Button("Update") {
                                updateGoalProgress()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(updatedValue == goal.currentValue)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Goal Details")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .overlay {
            if showingConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
            }
        }
    }
    
    private var progressColor: Color {
        if goal.progress >= 1.0 {
            return .green
        } else if goal.progress >= 0.7 {
            return .blue
        } else if goal.progress >= 0.3 {
            return .orange
        } else {
            return .red
        }
    }
    
    private func updateGoalProgress() {
        Task {
            await goalViewModel.updateGoalProgress(id: goal.id, newValue: updatedValue)
            
            // Show confetti if goal is completed
            if updatedValue >= goal.targetValue && goal.currentValue < goal.targetValue {
                showingConfetti = true
                
                // Hide confetti after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showingConfetti = false
                }
            }
        }
    }
}
