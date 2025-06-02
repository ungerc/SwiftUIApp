import Foundation

public class WorkoutService {
    private let networkManager: NetworkManager
    private let authManager: AuthManager
    
    public init(networkManager: NetworkManager, authManager: AuthManager) {
        self.networkManager = networkManager
        self.authManager = authManager
    }
    
    public func fetchWorkouts() async throws -> [Workout] {
        guard let _ = try? authManager.getToken() else {
            throw AuthError.notAuthenticated
        }
        
        // Mock implementation
        return [
            Workout(id: "1", name: "Morning Run", duration: 1800, caloriesBurned: 250, date: Date(), type: .running),
            Workout(id: "2", name: "Evening Yoga", duration: 3600, caloriesBurned: 180, date: Date().addingTimeInterval(-86400), type: .yoga)
        ]
    }
    
    public func addWorkout(_ workout: Workout) async throws -> Workout {
        guard let _ = try? authManager.getToken() else {
            throw AuthError.notAuthenticated
        }
        
        // Mock implementation - just return the workout
        return workout
    }
}

public struct Workout: Identifiable, Codable {
    public let id: String
    public let name: String
    public let duration: TimeInterval
    public let caloriesBurned: Double
    public let date: Date
    public let type: WorkoutType
    
    public init(id: String, name: String, duration: TimeInterval, caloriesBurned: Double, date: Date, type: WorkoutType) {
        self.id = id
        self.name = name
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.date = date
        self.type = type
    }
}

public enum WorkoutType: String, Codable, CaseIterable {
    case running
    case cycling
    case swimming
    case weightLifting
    case yoga
    case hiit
    
    public var icon: String {
        switch self {
        case .running: return "figure.run"
        case .cycling: return "figure.outdoor.cycle"
        case .swimming: return "figure.pool.swim"
        case .weightLifting: return "dumbbell"
        case .yoga: return "figure.mind.and.body"
        case .hiit: return "figure.highintensity.intervaltraining"
        }
    }
}
