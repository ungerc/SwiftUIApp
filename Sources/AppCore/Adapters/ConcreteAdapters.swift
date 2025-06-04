import Foundation
import Networking
import Authentication
import FitnessTracker

// MARK: - Concrete Auth Adapter
public class ConcreteAuthAdapter: ApplicationAuthAdapter {
    private let authService: AuthServiceProtocol
    
    public init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    public var isAuthenticated: Bool {
        return authService.isAuthenticated
    }
    
    public var currentUser: AppUser? {
        guard let authUser = authService.currentUser else { return nil }
        return AppUser(authUser: authUser)
    }
    
    public func signIn(email: String, password: String) async throws -> AppUser {
        let credentials = AuthCredentials(email: email, password: password)
        let authUser = try await authService.signIn(with: credentials)
        return AppUser(authUser: authUser)
    }
    
    public func signUp(email: String, password: String, name: String) async throws -> AppUser {
        let credentials = AuthCredentials(email: email, password: password)
        let authUser = try await authService.signUp(with: credentials, name: name)
        return AppUser(authUser: authUser)
    }
    
    public func signOut() throws {
        try authService.signOut()
    }
    
    public func getToken() throws -> String {
        return try authService.getToken()
    }
}

// MARK: - Concrete Workout Adapter
public class ConcreteWorkoutAdapter: ApplicationWorkoutAdapter {
    private let workoutService: WorkoutServiceProtocol
    
    public init(workoutService: WorkoutServiceProtocol) {
        self.workoutService = workoutService
    }
    
    public func fetchWorkouts() async throws -> [AppWorkout] {
        let fitnessWorkouts = try await workoutService.fetchWorkouts()
        return fitnessWorkouts.map { AppWorkout(workout: $0) }
    }
    
    public func addWorkout(name: String,
                           type: AppWorkoutType,
                           duration: TimeInterval,
                           caloriesBurned: Double,
                           date: Date) async throws -> AppWorkout {

        // Convert AppWorkoutType to FitnessTracker.WorkoutType
        let fitnessType: FitnessTracker.WorkoutType

        switch type {
        case .running: fitnessType = .running
        case .cycling: fitnessType = .cycling
        case .swimming: fitnessType = .swimming
        case .weightLifting: fitnessType = .weightLifting
        case .yoga: fitnessType = .yoga
        case .hiit: fitnessType = .hiit
        }
        
        let workout = FitnessTracker.Workout(
            id: UUID().uuidString, // This will be replaced by the server
            name: name,
            duration: duration,
            caloriesBurned: caloriesBurned,
            date: date,
            type: fitnessType
        )
        
        let result = try await workoutService.addWorkout(workout)
        return AppWorkout(workout: result)
    }
    
    public func deleteWorkout(id: String) async throws {
        try await workoutService.deleteWorkout(id: id)
    }
}

// MARK: - Concrete Goal Adapter
public class ConcreteGoalAdapter: ApplicationGoalAdapter {
    private let goalService: GoalServiceProtocol
    
    public init(goalService: GoalServiceProtocol) {
        self.goalService = goalService
    }
    
    public func fetchGoals() async throws -> [AppGoal] {
        let fitnessGoals = try await goalService.fetchGoals()
        return fitnessGoals.map { AppGoal(goal: $0) }
    }
    
    public func addGoal(name: String, type: AppGoalType, targetValue: Double, currentValue: Double, unit: String, deadline: Date?) async throws -> AppGoal {
        // Convert AppGoalType to FitnessTracker.GoalType
        let fitnessType: FitnessTracker.GoalType
        switch type {
        case .weight: fitnessType = .weight
        case .steps: fitnessType = .steps
        case .workouts: fitnessType = .workouts
        case .distance: fitnessType = .distance
        case .calories: fitnessType = .calories
        }
        
        let goal = FitnessTracker.Goal(
            id: UUID().uuidString, // This will be replaced by the server
            name: name,
            targetValue: targetValue,
            currentValue: currentValue,
            unit: unit,
            deadline: deadline,
            type: fitnessType
        )
        
        let result = try await goalService.addGoal(goal)
        return AppGoal(goal: result)
    }
    
    public func updateGoalProgress(id: String, newValue: Double) async throws -> AppGoal {
        let updatedGoal = try await goalService.updateGoalProgress(id: id, newValue: newValue)
        return AppGoal(goal: updatedGoal)
    }
    
    public func deleteGoal(id: String) async throws {
        try await goalService.deleteGoal(id: id)
    }
}

// MARK: - Concrete Network Adapter
public class ConcreteNetworkAdapter: ApplicationNetworkAdapter {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func fetch<T: Decodable>(from urlString: String) async throws -> T {
        return try await networkService.fetch(from: urlString)
    }
    
    public func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        return try await networkService.post(to: urlString, body: body)
    }
    
    public func put<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        // Assuming the service has this method
        return try await networkService.put(to: urlString, body: body)
    }
    
    public func delete(from urlString: String) async throws {
        // Assuming the service has this method
        try await networkService.delete(from: urlString)
    }
}
