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
    
    public var currentUser: User? {
        return authService.currentUser
    }
    
    public func signIn(email: String, password: String) async throws -> User {
        let credentials = AuthCredentials(email: email, password: password)
        return try await authService.signIn(with: credentials)
    }
    
    public func signUp(email: String, password: String, name: String) async throws -> User {
        let credentials = AuthCredentials(email: email, password: password)
        return try await authService.signUp(with: credentials, name: name)
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
    
    public func fetchWorkouts() async throws -> [Workout] {
        return try await workoutService.fetchWorkouts()
    }
    
    public func addWorkout(name: String, type: WorkoutType, duration: TimeInterval, caloriesBurned: Double, date: Date) async throws -> Workout {
        let workout = Workout(
            id: UUID().uuidString, // This will be replaced by the server
            name: name,
            duration: duration,
            caloriesBurned: caloriesBurned,
            date: date,
            type: type
        )
        return try await workoutService.addWorkout(workout)
    }
    
    public func deleteWorkout(id: String) async throws {
        // Assuming the service has this method
        try await workoutService.deleteWorkout(id: id)
    }
}

// MARK: - Concrete Goal Adapter
public class ConcreteGoalAdapter: ApplicationGoalAdapter {
    private let goalService: GoalServiceProtocol
    
    public init(goalService: GoalServiceProtocol) {
        self.goalService = goalService
    }
    
    public func fetchGoals() async throws -> [Goal] {
        return try await goalService.fetchGoals()
    }
    
    public func addGoal(name: String, type: GoalType, targetValue: Double, currentValue: Double, unit: String, deadline: Date?) async throws -> Goal {
        let goal = Goal(
            id: UUID().uuidString, // This will be replaced by the server
            name: name,
            targetValue: targetValue,
            currentValue: currentValue,
            unit: unit,
            deadline: deadline,
            type: type
        )
        return try await goalService.addGoal(goal)
    }
    
    public func updateGoalProgress(id: String, newValue: Double) async throws -> Goal {
        return try await goalService.updateGoalProgress(id: id, newValue: newValue)
    }
    
    public func deleteGoal(id: String) async throws {
        // Assuming the service has this method
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
