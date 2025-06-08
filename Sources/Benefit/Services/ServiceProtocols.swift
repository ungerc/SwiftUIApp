import Foundation

/// Protocol defining the interface for workout-related operations.
/// All methods are marked with @MainActor as they may update UI state.
public protocol WorkoutServiceProtocol {
    /// Fetches all workouts for the current user.
    /// - Returns: An array of `Workout` objects
    /// - Throws: `FitnessAuthError.notAuthenticated` if user is not authenticated,
    ///          or network-related errors
    @MainActor
    func fetchWorkouts() async throws -> [Workout]
    
    /// Adds a new workout for the current user.
    /// - Parameter workout: The workout to add
    /// - Returns: The created workout with server-assigned ID
    /// - Throws: `FitnessAuthError.notAuthenticated` if user is not authenticated,
    ///          or network-related errors
    @MainActor
    func addWorkout(_ workout: Workout) async throws -> Workout
    
    /// Deletes a workout by its ID.
    /// - Parameter id: The unique identifier of the workout to delete
    /// - Throws: `FitnessAuthError.notAuthenticated` if user is not authenticated,
    ///          or network-related errors
    @MainActor
    func deleteWorkout(id: String) async throws
}

/// Protocol defining the interface for goal-related operations.
/// All methods are marked with @MainActor as they may update UI state.
public protocol GoalServiceProtocol {
    /// Fetches all goals for the current user.
    /// - Returns: An array of `Goal` objects
    /// - Throws: `FitnessAuthError.notAuthenticated` if user is not authenticated,
    ///          or network-related errors
    @MainActor
    func fetchGoals() async throws -> [Goal]
    
    /// Adds a new goal for the current user.
    /// - Parameter goal: The goal to add
    /// - Returns: The created goal with server-assigned ID
    /// - Throws: `FitnessAuthError.notAuthenticated` if user is not authenticated,
    ///          or network-related errors
    @MainActor
    func addGoal(_ goal: Goal) async throws -> Goal
    
    /// Updates the progress of an existing goal.
    /// - Parameters:
    ///   - id: The unique identifier of the goal to update
    ///   - newValue: The new current value for the goal
    /// - Returns: The updated goal
    /// - Throws: `FitnessAuthError.notAuthenticated` if user is not authenticated,
    ///          or network-related errors
    @MainActor
    func updateGoalProgress(id: String, newValue: Double) async throws -> Goal
    
    /// Deletes a goal by its ID.
    /// - Parameter id: The unique identifier of the goal to delete
    /// - Throws: `FitnessAuthError.notAuthenticated` if user is not authenticated,
    ///          or network-related errors
    @MainActor
    func deleteGoal(id: String) async throws
}

/// Protocol for network services used by the fitness tracker module.
/// This is a subset of NetworkServiceProtocol specific to fitness features.
public protocol FitnessNetworkService {
    /// Fetches data from a URL and decodes it into the specified type.
    /// - Parameter urlString: The URL to fetch data from
    /// - Returns: The decoded data of type `T`
    /// - Throws: Network-related errors
    func fetch<T: Decodable>(from urlString: String) async throws -> T
    
    /// Sends a POST request with an encodable body and returns a decoded response.
    /// - Parameters:
    ///   - urlString: The URL to send the request to
    ///   - body: The encodable data to send in the request body
    /// - Returns: The decoded response of type `U`
    /// - Throws: Network-related errors
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    
    /// Sends a PUT request with an encodable body and returns a decoded response.
    /// - Parameters:
    ///   - urlString: The URL to send the request to
    ///   - body: The encodable data to send in the request body
    /// - Returns: The decoded response of type `U`
    /// - Throws: Network-related errors
    func put<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    
    /// Sends a DELETE request to the specified URL.
    /// - Parameter urlString: The URL to send the delete request to
    /// - Throws: Network-related errors
    func delete(from urlString: String) async throws
}

/// Protocol for authentication services used by the fitness tracker module.
/// This is a subset of AuthServiceProtocol specific to fitness features.
public protocol FitnessAuthService: Actor {
    /// Indicates whether a user is currently authenticated
    var isAuthenticated: Bool { get async }

    /// Retrieves the authentication token for API requests.
    /// - Returns: The authentication token
    /// - Throws: Errors if no valid token is available
    func getToken() async throws -> String
}

/// Errors specific to fitness module authentication.
public enum FitnessAuthError: Error {
    /// Thrown when attempting to access fitness features without authentication
    case notAuthenticated
}
