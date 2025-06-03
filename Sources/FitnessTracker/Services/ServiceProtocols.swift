import Foundation

public protocol WorkoutServiceProtocol {
    func fetchWorkouts() async throws -> [Workout]
    func addWorkout(_ workout: Workout) async throws -> Workout
    func deleteWorkout(id: String) async throws
}

public protocol GoalServiceProtocol {
    func fetchGoals() async throws -> [Goal]
    func addGoal(_ goal: Goal) async throws -> Goal
    func updateGoalProgress(id: String, newValue: Double) async throws -> Goal
    func deleteGoal(id: String) async throws
}

public protocol FitnessNetworkService {
    func fetch<T: Decodable>(from urlString: String) async throws -> T
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    func put<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    func delete(from urlString: String) async throws
}

public protocol FitnessAuthService {
    var isAuthenticated: Bool { get }
    func getToken() throws -> String
}

public enum FitnessAuthError: Error {
    case notAuthenticated
}
