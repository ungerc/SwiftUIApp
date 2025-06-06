import Foundation
import SwiftUI
import Networking
import Authentication
import FitnessTracker

// MARK: - Auth Adapter Protocol
public protocol ApplicationAuthAdapter: AnyObject {
    var isAuthenticated: Bool { get }
    var currentUser: AppUser? { get }
    
    @MainActor
    func signIn(email: String, password: String) async throws -> AppUser
    @MainActor
    func signUp(email: String, password: String, name: String) async throws -> AppUser
    func signOut() throws
    func getToken() throws -> String
    
    @MainActor
    func makeAuthView() -> AnyView
}

// MARK: - Workout Adapter Protocol
public protocol ApplicationWorkoutAdapter {
    func fetchWorkouts() async throws -> [AppWorkout]
    func addWorkout(name: String, type: AppWorkoutType, duration: TimeInterval, caloriesBurned: Double, date: Date) async throws -> AppWorkout
    func deleteWorkout(id: String) async throws
}

// MARK: - Goal Adapter Protocol
public protocol ApplicationGoalAdapter {
    func fetchGoals() async throws -> [AppGoal]
    func addGoal(name: String, type: AppGoalType, targetValue: Double, currentValue: Double, unit: String, deadline: Date?) async throws -> AppGoal
    func updateGoalProgress(id: String, newValue: Double) async throws -> AppGoal
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
public struct AppUser: Codable, Identifiable, Sendable {
    public let id: String
    public let email: String
    public let name: String
    
    public init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }
    
    // Convert from AuthUser
    public init(authUser: AuthUser) {
        self.id = authUser.id
        self.email = authUser.email
        self.name = authUser.name
    }
}

public struct AppWorkout: Identifiable, Codable, Sendable {
    public let id: String
    public let name: String
    public let duration: TimeInterval
    public let caloriesBurned: Double
    public let date: Date
    public let type: AppWorkoutType
    
    public init(id: String, name: String, duration: TimeInterval, caloriesBurned: Double, date: Date, type: AppWorkoutType) {
        self.id = id
        self.name = name
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.date = date
        self.type = type
    }
    
    // Convert from FitnessTracker Workout
    public init(workout: FitnessTracker.Workout) {
        self.id = workout.id
        self.name = workout.name
        self.duration = workout.duration
        self.caloriesBurned = workout.caloriesBurned
        self.date = workout.date
        self.type = AppWorkoutType(fitnessType: workout.type)
    }
}

public enum AppWorkoutType: String, Codable, CaseIterable, Sendable {
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
    
    // Convert from FitnessTracker WorkoutType
    public init(fitnessType: FitnessTracker.WorkoutType) {
        switch fitnessType {
        case .running: self = .running
        case .cycling: self = .cycling
        case .swimming: self = .swimming
        case .weightLifting: self = .weightLifting
        case .yoga: self = .yoga
        case .hiit: self = .hiit
        }
    }
}

public struct AppGoal: Identifiable, Codable, Sendable {
    public let id: String
    public let name: String
    public let targetValue: Double
    public let currentValue: Double
    public let unit: String
    public let deadline: Date?
    public let type: AppGoalType
    
    public var progress: Double {
        return min(currentValue / targetValue, 1.0)
    }
    
    public init(id: String, name: String, targetValue: Double, currentValue: Double, unit: String, deadline: Date?, type: AppGoalType) {
        self.id = id
        self.name = name
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.unit = unit
        self.deadline = deadline
        self.type = type
    }
    
    // Convert from FitnessTracker Goal
    public init(goal: FitnessTracker.Goal) {
        self.id = goal.id
        self.name = goal.name
        self.targetValue = goal.targetValue
        self.currentValue = goal.currentValue
        self.unit = goal.unit
        self.deadline = goal.deadline
        self.type = AppGoalType(fitnessType: goal.type)
    }
}

public enum AppGoalType: String, Codable, CaseIterable, Sendable {
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
    
    // Convert from FitnessTracker GoalType
    public init(fitnessType: FitnessTracker.GoalType) {
        switch fitnessType {
        case .weight: self = .weight
        case .steps: self = .steps
        case .workouts: self = .workouts
        case .distance: self = .distance
        case .calories: self = .calories
        }
    }
}
