import SwiftUI

/// A row view for displaying workout information in a list.
/// Shows workout type icon, name, date, calories, and duration.
struct WorkoutRow: View {
    /// The workout data to display
    let workout: Workout

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: workout.type.icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.headline)
                
                Text(workout.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(workout.caloriesBurned)) cal")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                
                Text(formatDuration(workout.duration))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
