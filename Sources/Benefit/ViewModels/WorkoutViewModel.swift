import SwiftUI

/// View model for managing workout data and UI state.
/// Handles fetching, adding, and deleting workouts while managing loading states.
@Observable
@MainActor
public class WorkoutViewModel {
    /// The underlying workout service
    private let workoutService: WorkoutServiceProtocol
    
    /// Array of workouts displayed in the UI
    public var workouts: [Workout] = []
    
    /// Indicates whether a workout operation is in progress
    public var isLoading = false
    
    /// Error message to display to the user, if any
    public var errorMessage: String?
    
    /// Calculates the total calories burned across all workouts.
    /// - Returns: Sum of calories burned from all workouts
    public var totalCaloriesBurned: Double {
        workouts.reduce(0) { $0 + $1.caloriesBurned }
    }
    
    /// Calculates the total duration of all workouts.
    /// - Returns: Sum of durations from all workouts in seconds
    public var totalDuration: TimeInterval {
        workouts.reduce(0) { $0 + $1.duration }
    }
    
    /// Creates a new WorkoutViewModel.
    /// - Parameter workoutService: The workout service to use for data operations
    public init(workoutService: WorkoutServiceProtocol) {
        self.workoutService = workoutService
    }
    
    public func fetchWorkouts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            workouts = try await workoutService.fetchWorkouts()
        } catch {
            errorMessage = "Failed to fetch workouts"
        }
        
        isLoading = false
    }
    
    public func addWorkout(name: String, type: WorkoutType, duration: TimeInterval, caloriesBurned: Double, date: Date) async {
        isLoading = true
        errorMessage = nil
        
        let newWorkout = Workout(
            id: UUID().uuidString,
            name: name,
            duration: duration,
            caloriesBurned: caloriesBurned,
            date: date,
            type: type
        )
        
        do {
            let addedWorkout = try await workoutService.addWorkout(newWorkout)
            workouts.append(addedWorkout)
        } catch {
            errorMessage = "Failed to add workout"
        }
        
        isLoading = false
    }
    
    public func deleteWorkout(id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await workoutService.deleteWorkout(id: id)
            workouts.removeAll { $0.id == id }
        } catch {
            errorMessage = "Failed to delete workout"
        }
        
        isLoading = false
    }
}
