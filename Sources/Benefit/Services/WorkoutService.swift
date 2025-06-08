import Foundation

/// Service responsible for managing workout data.
/// 
/// This service handles:
/// - Fetching workouts from local storage (will use API when backend is ready)
/// - Adding new workouts
/// - Deleting workouts
/// - Persisting workout data locally
/// 
/// Currently uses UserDefaults for persistence, but is designed to easily
/// switch to a network-based backend when available.
public class WorkoutService: WorkoutServiceProtocol {
    private let networkService: FitnessNetworkService
    private let authService: FitnessAuthService
    private let userDefaults = UserDefaults.standard
    private let workoutsKey = "com.fitjourney.workouts"
    
    public init(networkService: FitnessNetworkService, authService: FitnessAuthService) {
        self.networkService = networkService
        self.authService = authService
        
        // Initialize with mock data if no data exists
        if loadWorkoutsFromStorage().isEmpty {
            saveWorkoutsToStorage(mockWorkouts)
        }
    }
    private let baseURL = "https://api.fitjourney.com/workouts"
    
    @MainActor
    public func fetchWorkouts() async throws -> [Workout] {
        guard let _ = try? await authService.getToken() else {
            throw FitnessAuthError.notAuthenticated
        }
        
        // Load from local storage
        return loadWorkoutsFromStorage()
    }
    
    @MainActor
    public func addWorkout(_ workout: Workout) async throws -> Workout {
        guard let _ = try? await authService.getToken() else {
            throw FitnessAuthError.notAuthenticated
        }
        
        // Add to local storage
        var workouts = loadWorkoutsFromStorage()
        workouts.append(workout)
        saveWorkoutsToStorage(workouts)
        
        return workout
    }
    
    @MainActor
    public func deleteWorkout(id: String) async throws {
        guard let _ = try? await authService.getToken() else {
            throw FitnessAuthError.notAuthenticated
        }
        
        // Remove from local storage
        var workouts = loadWorkoutsFromStorage()
        workouts.removeAll { $0.id == id }
        saveWorkoutsToStorage(workouts)
    }
    
    // MARK: - Persistence Methods
    
    private func loadWorkoutsFromStorage() -> [Workout] {
        guard let data = userDefaults.data(forKey: workoutsKey),
              let workouts = try? JSONDecoder().decode([Workout].self, from: data) else {
            return []
        }
        return workouts
    }
    
    private func saveWorkoutsToStorage(_ workouts: [Workout]) {
        if let data = try? JSONEncoder().encode(workouts) {
            userDefaults.set(data, forKey: workoutsKey)
        }
    }
    
    // Mock data for demonstration
    private var mockWorkouts: [Workout] {
        [
            Workout(
                id: "1",
                name: "Morning Run",
                duration: 1800, // 30 minutes
                caloriesBurned: 350,
                date: Date().addingTimeInterval(-86400), // Yesterday
                type: .running
            ),
            Workout(
                id: "2",
                name: "Weight Training",
                duration: 3600, // 60 minutes
                caloriesBurned: 450,
                date: Date().addingTimeInterval(-172800), // 2 days ago
                type: .weightLifting
            ),
            Workout(
                id: "3",
                name: "Yoga Session",
                duration: 2700, // 45 minutes
                caloriesBurned: 200,
                date: Date().addingTimeInterval(-259200), // 3 days ago
                type: .yoga
            )
        ]
    }
}
