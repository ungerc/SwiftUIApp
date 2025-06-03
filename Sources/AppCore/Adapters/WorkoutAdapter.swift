import Foundation
import FitnessTracker

// This adapter exposes the WorkoutServiceProtocol to other modules
// without them needing to import FitnessTracker directly
public class WorkoutAdapter {
    private let workoutService: WorkoutServiceProtocol
    
    public init(workoutService: WorkoutServiceProtocol) {
        self.workoutService = workoutService
    }
    
    public func fetchWorkouts() async throws -> [Workout] {
        return try await workoutService.fetchWorkouts()
    }
    
    public func addWorkout(_ workout: Workout) async throws -> Workout {
        return try await workoutService.addWorkout(workout)
    }
}
