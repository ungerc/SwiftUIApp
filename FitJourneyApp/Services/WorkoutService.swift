import Foundation
import AppCore

// This is now a wrapper around the ApplicationWorkoutAdapter
public class WorkoutService {
    private let workoutAdapter: ApplicationWorkoutAdapter
    
    init(workoutAdapter: ApplicationWorkoutAdapter) {
        self.workoutAdapter = workoutAdapter
    }
    
    public func fetchWorkouts() async throws -> [Workout] {
        return try await workoutAdapter.fetchWorkouts()
    }
    
    public func addWorkout(_ workout: Workout) async throws -> Workout {
        return try await workoutAdapter.addWorkout(
            name: workout.name,
            type: workout.type,
            duration: workout.duration,
            caloriesBurned: workout.caloriesBurned,
            date: workout.date
        )
    }
    
    // Convenience method to delete a workout
    public func deleteWorkout(id: String) async throws {
        try await workoutAdapter.deleteWorkout(id: id)
    }
}

// Using the types from AppCore
public typealias Workout = AppCore.Workout
public typealias WorkoutType = AppCore.WorkoutType
