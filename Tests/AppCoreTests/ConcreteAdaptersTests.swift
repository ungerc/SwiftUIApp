import XCTest
@testable import AppCore
@testable import Authentication
@testable import FitnessTracker

final class ConcreteAdaptersTests: XCTestCase {
    
    // MARK: - Auth Adapter Tests
    
    @MainActor
    func testAuthAdapterSignIn() async throws {
        // Given
        let mockAuthService = MockAuthServiceForAdapter()
        let adapter = ConcreteAuthAdapter(authService: mockAuthService)
        
        // When
        let user = try await adapter.signIn(email: "test@example.com", password: "password123")
        
        // Then
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertTrue(adapter.isAuthenticated)
        XCTAssertNotNil(adapter.currentUser)
    }
    
    @MainActor
    func testAuthAdapterSignUp() async throws {
        // Given
        let mockAuthService = MockAuthServiceForAdapter()
        let adapter = ConcreteAuthAdapter(authService: mockAuthService)
        
        // When
        let user = try await adapter.signUp(email: "new@example.com", password: "password123", name: "New User")
        
        // Then
        XCTAssertEqual(user.email, "new@example.com")
        XCTAssertEqual(user.name, "New User")
        XCTAssertTrue(adapter.isAuthenticated)
    }
    
    func testAuthAdapterSignOut() throws {
        // Given
        let mockAuthService = MockAuthServiceForAdapter()
        mockAuthService.isAuthenticated = true
        let adapter = ConcreteAuthAdapter(authService: mockAuthService)
        
        // When
        try adapter.signOut()
        
        // Then
        XCTAssertFalse(adapter.isAuthenticated)
        XCTAssertNil(adapter.currentUser)
    }
    
    // MARK: - Workout Adapter Tests
    
    func testWorkoutAdapterFetchWorkouts() async throws {
        // Given
        let mockWorkoutService = MockWorkoutService()
        let adapter = ConcreteWorkoutAdapter(workoutService: mockWorkoutService)
        
        // When
        let workouts = try await adapter.fetchWorkouts()
        
        // Then
        XCTAssertEqual(workouts.count, 2)
        XCTAssertEqual(workouts[0].name, "Morning Run")
        XCTAssertEqual(workouts[1].name, "Evening Yoga")
    }
    
    func testWorkoutAdapterAddWorkout() async throws {
        // Given
        let mockWorkoutService = MockWorkoutService()
        let adapter = ConcreteWorkoutAdapter(workoutService: mockWorkoutService)
        
        // When
        let workout = try await adapter.addWorkout(
            name: "Test Workout",
            type: .running,
            duration: 1800,
            caloriesBurned: 250,
            date: Date()
        )
        
        // Then
        XCTAssertEqual(workout.name, "Test Workout")
        XCTAssertEqual(workout.type, .running)
        XCTAssertEqual(workout.duration, 1800)
    }
    
    // MARK: - Goal Adapter Tests
    
    func testGoalAdapterFetchGoals() async throws {
        // Given
        let mockGoalService = MockGoalService()
        let adapter = ConcreteGoalAdapter(goalService: mockGoalService)
        
        // When
        let goals = try await adapter.fetchGoals()
        
        // Then
        XCTAssertEqual(goals.count, 2)
        XCTAssertEqual(goals[0].name, "Weight Loss")
        XCTAssertEqual(goals[1].name, "Daily Steps")
    }
    
    func testGoalAdapterUpdateProgress() async throws {
        // Given
        let mockGoalService = MockGoalService()
        let adapter = ConcreteGoalAdapter(goalService: mockGoalService)
        
        // When
        let updatedGoal = try await adapter.updateGoalProgress(id: "1", newValue: 75.0)
        
        // Then
        XCTAssertEqual(updatedGoal.currentValue, 75.0)
        XCTAssertEqual(updatedGoal.progress, 0.75)
    }
}

// MARK: - Mock Services

@MainActor
class MockAuthServiceForAdapter: AuthServiceProtocol {
    var isAuthenticated = false
    var currentUser: AuthUser?
    
    func signIn(with credentials: AuthCredentials) async throws -> AuthUser {
        let user = AuthUser(id: "1", email: credentials.email, name: "Test User")
        self.currentUser = user
        self.isAuthenticated = true
        return user
    }
    
    func signUp(with credentials: AuthCredentials, name: String) async throws -> AuthUser {
        let user = AuthUser(id: "1", email: credentials.email, name: name)
        self.currentUser = user
        self.isAuthenticated = true
        return user
    }
    
    func signOut() throws {
        self.currentUser = nil
        self.isAuthenticated = false
    }
    
    func getToken() throws -> String {
        return "mock-token"
    }
}

class MockWorkoutService: WorkoutServiceProtocol {
    func fetchWorkouts() async throws -> [Workout] {
        return [
            Workout(id: "1", name: "Morning Run", duration: 1800, caloriesBurned: 250, date: Date(), type: .running),
            Workout(id: "2", name: "Evening Yoga", duration: 3600, caloriesBurned: 150, date: Date(), type: .yoga)
        ]
    }
    
    func addWorkout(_ workout: Workout) async throws -> Workout {
        return workout
    }
    
    func deleteWorkout(id: String) async throws {
        // Mock implementation
    }
}

class MockGoalService: GoalServiceProtocol {
    func fetchGoals() async throws -> [Goal] {
        return [
            Goal(id: "1", name: "Weight Loss", targetValue: 100, currentValue: 70, unit: "kg", deadline: nil, type: .weight),
            Goal(id: "2", name: "Daily Steps", targetValue: 10000, currentValue: 7500, unit: "steps", deadline: nil, type: .steps)
        ]
    }
    
    func addGoal(_ goal: Goal) async throws -> Goal {
        return goal
    }
    
    func updateGoalProgress(id: String, newValue: Double) async throws -> Goal {
        return Goal(id: id, name: "Updated Goal", targetValue: 100, currentValue: newValue, unit: "units", deadline: nil, type: .weight)
    }
    
    func deleteGoal(id: String) async throws {
        // Mock implementation
    }
}
