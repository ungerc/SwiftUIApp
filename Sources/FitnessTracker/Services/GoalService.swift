import Foundation

public class GoalService: GoalServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let authService: AuthServiceProtocol
    
    public init(networkService: NetworkServiceProtocol, authService: AuthServiceProtocol) {
        self.networkService = networkService
        self.authService = authService
    }
    private let baseURL = "https://api.fitjourney.com/goals"
    
    public func fetchGoals() async throws -> [Goal] {
        guard let _ = try? authService.getToken() else {
            throw AuthError.notAuthenticated
        }
        
        // In a real app, you would include the token in the request
        // For now, we'll return mock data
        return mockGoals
    }
    
    public func addGoal(_ goal: Goal) async throws -> Goal {
        guard let _ = try? authService.getToken() else {
            throw AuthError.notAuthenticated
        }
        
        // In a real app, you would send the goal to the server
        // For now, we'll just return the goal
        return goal
    }
    
    public func updateGoalProgress(id: String, newValue: Double) async throws -> Goal {
        guard let _ = try? authService.getToken() else {
            throw AuthError.notAuthenticated
        }
        
        // In a real app, you would update the goal on the server
        // For now, we'll return a mock goal with updated progress
        let mockGoal = mockGoals.first { $0.id == id }!
        return Goal(
            id: mockGoal.id,
            name: mockGoal.name,
            targetValue: mockGoal.targetValue,
            currentValue: newValue,
            unit: mockGoal.unit,
            deadline: mockGoal.deadline,
            type: mockGoal.type
        )
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
