import Foundation
import SwiftUI

@Observable
@MainActor
class WorkoutViewModel {
    private let workoutService: WorkoutService
    
    init(workoutService: WorkoutService) {
        self.workoutService = workoutService
    }
    
    var workouts: [Workout] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    func fetchWorkouts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedWorkouts = try await workoutService.fetchWorkouts()
            workouts = fetchedWorkouts
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch workouts: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func addWorkout(_ workout: Workout) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let newWorkout = try await workoutService.addWorkout(workout)
            workouts.append(newWorkout)
            workouts.sort { $0.date > $1.date }
            isLoading = false
        } catch {
            errorMessage = "Failed to add workout: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // Helper computed properties
    var totalCaloriesBurned: Double {
        workouts.reduce(0) { $0 + $1.caloriesBurned }
    }
    
    var totalWorkoutDuration: TimeInterval {
        workouts.reduce(0) { $0 + $1.duration }
    }
    
    var workoutsByType: [WorkoutType: [Workout]] {
        Dictionary(grouping: workouts) { $0.type }
    }
}
import Foundation
import SwiftUI

@MainActor
class WorkoutViewModel: ObservableObject {
    private let workoutService: WorkoutService
    
    init(workoutService: WorkoutService) {
        self.workoutService = workoutService
    }
    
    @Published var workouts: [Workout] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchWorkouts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedWorkouts = try await workoutService.fetchWorkouts()
            workouts = fetchedWorkouts
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch workouts: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func addWorkout(_ workout: Workout) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let newWorkout = try await workoutService.addWorkout(workout)
            workouts.append(newWorkout)
            workouts.sort { $0.date > $1.date }
            isLoading = false
        } catch {
            errorMessage = "Failed to add workout: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // Helper computed properties
    var totalCaloriesBurned: Double {
        workouts.reduce(0) { $0 + $1.caloriesBurned }
    }
    
    var totalWorkoutDuration: TimeInterval {
        workouts.reduce(0) { $0 + $1.duration }
    }
    
    var workoutsByType: [WorkoutType: [Workout]] {
        Dictionary(grouping: workouts) { $0.type }
    }
}
