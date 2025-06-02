import Foundation
import FitnessTracker

class WorkoutViewModel: ObservableObject {
    private let workoutService: WorkoutService
    
    init(workoutService: WorkoutService) {
        self.workoutService = workoutService
    }
    
    @Published var workouts: [Workout] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchWorkouts() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let fetchedWorkouts = try await workoutService.fetchWorkouts()
            
            DispatchQueue.main.async {
                self.workouts = fetchedWorkouts
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch workouts: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func addWorkout(_ workout: Workout) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let newWorkout = try await workoutService.addWorkout(workout)
            
            DispatchQueue.main.async {
                self.workouts.append(newWorkout)
                self.workouts.sort { $0.date > $1.date }
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to add workout: \(error.localizedDescription)"
                self.isLoading = false
            }
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
