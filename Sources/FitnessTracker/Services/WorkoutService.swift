import Foundation
import Networking
import Authentication

public class WorkoutService {
    public static let shared = WorkoutService()
    
    private let networkManager = NetworkManager.shared
    private let authManager = AuthManager.shared
    private let baseURL = "https://api.fitjourney.com/workouts"
    
    private init() {}
    
    public func fetchWorkouts() async throws -> [Workout] {
        guard let token = try? authManager.getToken() else {
            throw AuthError.notAuthenticated
        }
        
        // In a real app, you would include the token in the request
        // For now, we'll return mock data
        return mockWorkouts
    }
    
    public func addWorkout(_ workout: Workout) async throws -> Workout {
        guard let token = try? authManager.getToken() else {
            throw AuthError.notAuthenticated
        }
        
        // In a real app, you would send the workout to the server
        // For now, we'll just return the workout
        return workout
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
