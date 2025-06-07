import Foundation

/// Service responsible for managing fitness goals.
/// 
/// This service handles:
/// - Fetching goals from local storage (will use API when backend is ready)
/// - Adding new goals
/// - Updating goal progress
/// - Deleting goals
/// - Persisting goal data locally
/// 
/// Currently uses UserDefaults for persistence, but is designed to easily
/// switch to a network-based backend when available.
public class GoalService: GoalServiceProtocol {
    private let networkService: FitnessNetworkService
    private let authService: FitnessAuthService
    private let userDefaults = UserDefaults.standard
    private let goalsKey = "com.fitjourney.goals"
    
    public init(networkService: FitnessNetworkService, authService: FitnessAuthService) {
        self.networkService = networkService
        self.authService = authService
        
        // Initialize with mock data if no data exists
        if loadGoalsFromStorage().isEmpty {
            saveGoalsToStorage(mockGoals)
        }
    }
    private let baseURL = "https://api.fitjourney.com/goals"
    
    @MainActor
    public func fetchGoals() async throws -> [Goal] {
        guard let _ = try? authService.getToken() else {
            throw FitnessAuthError.notAuthenticated
        }
        
        // Load from local storage
        return loadGoalsFromStorage()
    }
    
    @MainActor
    public func addGoal(_ goal: Goal) async throws -> Goal {
        guard let _ = try? authService.getToken() else {
            throw FitnessAuthError.notAuthenticated
        }
        
        // Add to local storage
        var goals = loadGoalsFromStorage()
        goals.append(goal)
        saveGoalsToStorage(goals)
        
        return goal
    }
    
    @MainActor
    public func updateGoalProgress(id: String, newValue: Double) async throws -> Goal {
        guard let _ = try? authService.getToken() else {
            throw FitnessAuthError.notAuthenticated
        }
        
        // Update in local storage
        var goals = loadGoalsFromStorage()
        guard let index = goals.firstIndex(where: { $0.id == id }) else {
            throw FitnessAuthError.notAuthenticated // Should be a different error
        }
        
        let oldGoal = goals[index]
        let updatedGoal = Goal(
            id: oldGoal.id,
            name: oldGoal.name,
            targetValue: oldGoal.targetValue,
            currentValue: newValue,
            unit: oldGoal.unit,
            deadline: oldGoal.deadline,
            type: oldGoal.type
        )
        
        goals[index] = updatedGoal
        saveGoalsToStorage(goals)
        
        return updatedGoal
    }
    
    @MainActor
    public func deleteGoal(id: String) async throws {
        guard let _ = try? authService.getToken() else {
            throw FitnessAuthError.notAuthenticated
        }
        
        // Remove from local storage
        var goals = loadGoalsFromStorage()
        goals.removeAll { $0.id == id }
        saveGoalsToStorage(goals)
    }
    
    // MARK: - Persistence Methods
    
    private func loadGoalsFromStorage() -> [Goal] {
        guard let data = userDefaults.data(forKey: goalsKey),
              let goals = try? JSONDecoder().decode([Goal].self, from: data) else {
            return []
        }
        return goals
    }
    
    private func saveGoalsToStorage(_ goals: [Goal]) {
        if let data = try? JSONEncoder().encode(goals) {
            userDefaults.set(data, forKey: goalsKey)
        }
    }
    
    // Mock data for demonstration
    private var mockGoals: [Goal] {
        [
            Goal(
                id: "1",
                name: "Lose Weight",
                targetValue: 10.0,
                currentValue: 3.5,
                unit: "kg",
                deadline: Calendar.current.date(byAdding: .month, value: 2, to: Date()),
                type: .weight
            ),
            Goal(
                id: "2",
                name: "Daily Steps",
                targetValue: 10000,
                currentValue: 7500,
                unit: "steps",
                type: .steps
            ),
            Goal(
                id: "3",
                name: "Weekly Workouts",
                targetValue: 5,
                currentValue: 2,
                unit: "workouts",
                deadline: Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()),
                type: .workouts
            )
        ]
    }
}
