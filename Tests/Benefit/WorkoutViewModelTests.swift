import Testing
@testable import Benefit

@Suite("WorkoutViewModel Tests")
@MainActor
struct WorkoutViewModelTests {
    let sut: WorkoutViewModel
    let mockWorkoutService: MockWorkoutService
    
    init() {
        mockWorkoutService = MockWorkoutService()
        sut = WorkoutViewModel(workoutService: mockWorkoutService)
    }
    
    // MARK: - Fetch Workouts Tests
    
    @Test("Fetch workouts success updates workouts")
    func fetchWorkoutsSuccess() async {
        // Given
        let expectedWorkouts = [
            Workout(id: "1", name: "Morning Run", duration: 1800, caloriesBurned: 300, date: Date(), type: .running),
            Workout(id: "2", name: "Yoga", duration: 3600, caloriesBurned: 200, date: Date(), type: .yoga)
        ]
        mockWorkoutService.fetchWorkoutsResult = .success(expectedWorkouts)
        
        // When
        await sut.fetchWorkouts()
        
        // Then
        #expect(sut.workouts.count == 2)
        #expect(sut.workouts[0].id == "1")
        #expect(sut.workouts[1].id == "2")
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("Fetch workouts failure sets error message")
    func fetchWorkoutsFailure() async {
        // Given
        mockWorkoutService.fetchWorkoutsResult = .failure(MockError.networkError)
        
        // When
        await sut.fetchWorkouts()
        
        // Then
        #expect(sut.workouts.isEmpty)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == "Failed to fetch workouts")
    }
    
    // MARK: - Add Workout Tests
    
    @Test("Add workout success appends to workouts")
    func addWorkoutSuccess() async {
        // Given
        let newWorkout = Workout(id: "3", name: "Test Workout", duration: 2400, caloriesBurned: 250, date: Date(), type: .running)
        mockWorkoutService.addWorkoutResult = .success(newWorkout)
        
        // When
        await sut.addWorkout(
            name: "Test Workout",
            type: .running,
            duration: 2400,
            caloriesBurned: 250,
            date: Date()
        )
        
        // Then
        #expect(sut.workouts.count == 1)
        #expect(sut.workouts[0].name == "Test Workout")
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("Add workout failure sets error message")
    func addWorkoutFailure() async {
        // Given
        mockWorkoutService.addWorkoutResult = .failure(MockError.networkError)
        
        // When
        await sut.addWorkout(
            name: "Test Workout",
            type: .running,
            duration: 2400,
            caloriesBurned: 250,
            date: Date()
        )
        
        // Then
        #expect(sut.workouts.isEmpty)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == "Failed to add workout")
    }
    
    // MARK: - Delete Workout Tests
    
    @Test("Delete workout success removes from workouts")
    func deleteWorkoutSuccess() async {
        // Given
        let workout = Workout(id: "1", name: "Test", duration: 1800, caloriesBurned: 200, date: Date(), type: .running)
        sut.workouts = [workout]
        mockWorkoutService.deleteWorkoutShouldSucceed = true
        
        // When
        await sut.deleteWorkout(id: "1")
        
        // Then
        #expect(sut.workouts.isEmpty)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
    }
    
    // MARK: - Computed Properties Tests
    
    @Test("Total calories burned calculates correctly")
    func totalCaloriesBurnedCalculation() {
        // Given
        sut.workouts = [
            Workout(id: "1", name: "Run", duration: 1800, caloriesBurned: 300, date: Date(), type: .running),
            Workout(id: "2", name: "Swim", duration: 2400, caloriesBurned: 400, date: Date(), type: .swimming)
        ]
        
        // When
        let total = sut.totalCaloriesBurned
        
        // Then
        #expect(total == 700)
    }
    
    @Test("Total duration calculates correctly")
    func totalDurationCalculation() {
        // Given
        sut.workouts = [
            Workout(id: "1", name: "Run", duration: 1800, caloriesBurned: 300, date: Date(), type: .running),
            Workout(id: "2", name: "Swim", duration: 2400, caloriesBurned: 400, date: Date(), type: .swimming)
        ]
        
        // When
        let total = sut.totalDuration
        
        // Then
        #expect(total == 4200) // 1800 + 2400
    }
}

// MARK: - Mock Workout Service

@MainActor
class MockWorkoutService: WorkoutServiceProtocol {
    var fetchWorkoutsResult: Result<[Workout], Error>?
    var addWorkoutResult: Result<Workout, Error>?
    var deleteWorkoutShouldSucceed = true
    var deleteWorkoutError: Error?
    
    func fetchWorkouts() async throws -> [Workout] {
        guard let result = fetchWorkoutsResult else {
            throw MockError.notImplemented
        }
        
        switch result {
        case .success(let workouts):
            return workouts
        case .failure(let error):
            throw error
        }
    }
    
    func addWorkout(_ workout: Workout) async throws -> Workout {
        guard let result = addWorkoutResult else {
            throw MockError.notImplemented
        }
        
        switch result {
        case .success(let workout):
            return workout
        case .failure(let error):
            throw error
        }
    }
    
    func deleteWorkout(id: String) async throws {
        if !deleteWorkoutShouldSucceed {
            throw deleteWorkoutError ?? MockError.networkError
        }
        // Success case - just return without throwing
    }
}

enum MockError: Error {
    case networkError
    case notImplemented
}
