import SwiftUI

public struct WorkoutDetailView: View {
    let workout: Workout

    public init(workout: Workout) {
        self.workout = workout
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(workout.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack {
                        Image(systemName: workout.type.icon)
                            .foregroundColor(.blue)

                        Text(workout.type.rawValue.capitalized)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                // Date and time
                VStack(alignment: .leading, spacing: 5) {
                    Text("Date & Time")
                        .font(.headline)

                    Text(workout.date, style: .date)
                        .font(.subheadline)

                    Text(workout.date, style: .time)
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)

                // Stats
                HStack(spacing: 15) {
                    StatCard(
                        title: "Duration",
                        value: formatDuration(workout.duration),
                        icon: "clock",
                        color: .blue
                    )

                    StatCard(
                        title: "Calories",
                        value: "\(Int(workout.caloriesBurned))",
                        icon: "flame.fill",
                        color: .orange
                    )
                }
                .padding(.horizontal)

                // Additional info (placeholder)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Notes")
                        .font(.headline)

                    Text("This was a great workout session!")
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Workout Details")
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
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

