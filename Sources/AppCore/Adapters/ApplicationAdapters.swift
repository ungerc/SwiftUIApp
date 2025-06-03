import Foundation

// MARK: - Auth Adapter Protocol
public protocol ApplicationAuthAdapter {
    var isAuthenticated: Bool { get }
    var currentUser: User? { get }
    
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, name: String) async throws -> User
    func signOut() throws
    func getToken() throws -> String
}

// MARK: - Workout Adapter Protocol
public protocol ApplicationWorkoutAdapter {
    func fetchWorkouts() async throws -> [Workout]
    func addWorkout(name: String, type: WorkoutType, duration: TimeInterval, caloriesBurned: Double, date: Date) async throws -> Workout
    func deleteWorkout(id: String) async throws
}

// MARK: - Goal Adapter Protocol
public protocol ApplicationGoalAdapter {
    func fetchGoals() async throws -> [Goal]
    func addGoal(name: String, type: GoalType, targetValue: Double, currentValue: Double, unit: String, deadline: Date?) async throws -> Goal
    func updateGoalProgress(id: String, newValue: Double) async throws -> Goal
    func deleteGoal(id: String) async throws
}

// MARK: - Network Adapter Protocol
public protocol ApplicationNetworkAdapter {
    func fetch<T: Decodable>(from urlString: String) async throws -> T
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    func put<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    func delete(from urlString: String) async throws
}

// MARK: - Model Types
public struct User: Codable, Identifiable {
    public let id: String
    public let email: String
    public let name: String
    
    public init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
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
        case .cycling: return "bicycle"
        case .swimming: return "figure.pool.swim"
        case .weightLifting: return "dumbbell"
        case .yoga: return "figure.mind.and.body"
        case .hiit: return "heart.circle"
        }
    }
}

public struct Goal: Identifiable, Codable {
    public let id: String
    public let name: String
    public let targetValue: Double
    public let currentValue: Double
    public let unit: String
    public let deadline: Date?
    public let type: GoalType
    
    public var progress: Double {
        return min(currentValue / targetValue, 1.0)
    }
    
    public init(id: String, name: String, targetValue: Double, currentValue: Double, unit: String, deadline: Date?, type: GoalType) {
        self.id = id
        self.name = name
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.unit = unit
        self.deadline = deadline
        self.type = type
    }
}

public enum GoalType: String, Codable, CaseIterable {
    case weight
    case steps
    case workouts
    case distance
    case calories
    
    public var icon: String {
        switch self {
        case .weight: return "scalemass"
        case .steps: return "figure.walk"
        case .workouts: return "figure.highintensity.intervaltraining"
        case .distance: return "figure.run"
        case .calories: return "flame"
        }
    }
}
