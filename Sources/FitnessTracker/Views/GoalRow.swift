import SwiftUI

struct GoalRow: View {
    let goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: goal.type.icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
                
                Text(goal.name)
                    .font(.headline)
                
                Spacer()
                
                if goal.progress >= 1.0 {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            ProgressView(value: goal.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
            
            HStack {
                Text("\(Int(goal.currentValue)) / \(Int(goal.targetValue)) \(goal.unit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let deadline = goal.deadline {
                    Text(deadline, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
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
}
