import Testing
@testable import Benefit

@Suite("GoalViewModel Tests")
@MainActor
struct GoalViewModelTests {
    let sut: GoalViewModel
    let mockGoalService: MockGoalService
    
    init() {
        mockGoalService = MockGoalService()
        sut = GoalViewModel(goalService: mockGoalService)
    }
    
    // MARK: - Fetch Goals Tests
    
    @Test("Fetch goals success updates goals")
    func fetchGoalsSuccess() async {
        // Given
        let expectedGoals = [
            Goal(id: "1", name: "Lose Weight", targetValue: 10, currentValue: 3, unit: "kg", type: .weight),
            Goal(id: "2", name: "Daily Steps", targetValue: 10000, currentValue: 10000, unit: "steps", type: .steps)
        ]
        mockGoalService.fetchGoalsResult = .success(expectedGoals)
        
        // When
        await sut.fetchGoals()
        
        // Then
        #expect(sut.goals.count == 2)
        #expect(sut.inProgressGoals.count == 1)
        #expect(sut.completedGoals.count == 1)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("Fetch goals failure sets error message")
    func fetchGoalsFailure() async {
        // Given
        mockGoalService.fetchGoalsResult = .failure(MockError.networkError)
        
        // When
        await sut.fetchGoals()
        
        // Then
        #expect(sut.goals.isEmpty)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == "Failed to fetch goals")
    }
    
    // MARK: - Add Goal Tests
    
    @Test("Add goal success appends to goals")
    func addGoalSuccess() async {
        // Given
        let newGoal = Goal(id: "3", name: "New Goal", targetValue: 100, currentValue: 0, unit: "units", type: .workouts)
        mockGoalService.addGoalResult = .success(newGoal)
        
        // When
        await sut.addGoal(
            name: "New Goal",
            type: .workouts,
            targetValue: 100,
            currentValue: 0,
            unit: "units",
            deadline: nil
        )
        
        // Then
        #expect(sut.goals.count == 1)
        #expect(sut.goals[0].name == "New Goal")
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
    }
    
    // MARK: - Update Goal Progress Tests
    
    @Test("Update goal progress success updates goal")
    func updateGoalProgressSuccess() async {
        // Given
        let originalGoal = Goal(id: "1", name: "Test", targetValue: 100, currentValue: 50, unit: "units", type: .workouts)
        let updatedGoal = Goal(id: "1", name: "Test", targetValue: 100, currentValue: 75, unit: "units", type: .workouts)
        sut.goals = [originalGoal]
        mockGoalService.updateGoalProgressResult = .success(updatedGoal)
        
        // When
        await sut.updateGoalProgress(id: "1", newValue: 75)
        
        // Then
        #expect(sut.goals[0].currentValue == 75)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
    }
    
    // MARK: - Delete Goal Tests
    
    @Test("Delete goal success removes from goals")
    func deleteGoalSuccess() async {
        // Given
        let goal = Goal(id: "1", name: "Test", targetValue: 100, currentValue: 50, unit: "units", type: .workouts)
        sut.goals = [goal]
        mockGoalService.deleteGoalShouldSucceed = true
        
        // When
        await sut.deleteGoal(id: "1")
        
        // Then
        #expect(sut.goals.isEmpty)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
    }
    
    // MARK: - Computed Properties Tests
    
    @Test("In progress goals filters correctly")
    func inProgressGoalsFilter() {
        // Given
        sut.goals = [
            Goal(id: "1", name: "Goal 1", targetValue: 100, currentValue: 50, unit: "units", type: .workouts),
            Goal(id: "2", name: "Goal 2", targetValue: 100, currentValue: 100, unit: "units", type: .steps),
            Goal(id: "3", name: "Goal 3", targetValue: 100, currentValue: 75, unit: "units", type: .calories)
        ]
        
        // When
        let inProgress = sut.inProgressGoals
        
        // Then
        #expect(inProgress.count == 2)
        #expect(inProgress.allSatisfy { $0.progress < 1.0 })
    }
    
    @Test("Completed goals filters correctly")
    func completedGoalsFilter() {
        // Given
        sut.goals = [
            Goal(id: "1", name: "Goal 1", targetValue: 100, currentValue: 50, unit: "units", type: .workouts),
            Goal(id: "2", name: "Goal 2", targetValue: 100, currentValue: 100, unit: "units", type: .steps),
            Goal(id: "3", name: "Goal 3", targetValue: 100, currentValue: 150, unit: "units", type: .calories)
        ]
        
        // When
        let completed = sut.completedGoals
        
        // Then
        #expect(completed.count == 2)
        #expect(completed.allSatisfy { $0.progress >= 1.0 })
    }
}

// MARK: - Mock Goal Service

@MainActor
class MockGoalService: GoalServiceProtocol {
    var fetchGoalsResult: Result<[Goal], Error>?
    var addGoalResult: Result<Goal, Error>?
    var updateGoalProgressResult: Result<Goal, Error>?
    var deleteGoalShouldSucceed = true
    var deleteGoalError: Error?
    
    func fetchGoals() async throws -> [Goal] {
        guard let result = fetchGoalsResult else {
            throw MockError.notImplemented
        }
        
        switch result {
        case .success(let goals):
            return goals
        case .failure(let error):
            throw error
        }
    }
    
    func addGoal(_ goal: Goal) async throws -> Goal {
        guard let result = addGoalResult else {
            throw MockError.notImplemented
        }
        
        switch result {
        case .success(let goal):
            return goal
        case .failure(let error):
            throw error
        }
    }
    
    func updateGoalProgress(id: String, newValue: Double) async throws -> Goal {
        guard let result = updateGoalProgressResult else {
            throw MockError.notImplemented
        }
        
        switch result {
        case .success(let goal):
            return goal
        case .failure(let error):
            throw error
        }
    }
    
    func deleteGoal(id: String) async throws {
        if !deleteGoalShouldSucceed {
            throw deleteGoalError ?? MockError.networkError
        }
        // Success case - just return without throwing
    }
}
