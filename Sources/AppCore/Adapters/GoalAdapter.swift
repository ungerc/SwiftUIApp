import Foundation
import FitnessTracker

// This adapter exposes the GoalServiceProtocol to other modules
// without them needing to import FitnessTracker directly
public class GoalAdapter {
    private let goalService: GoalServiceProtocol
    
    public init(goalService: GoalServiceProtocol) {
        self.goalService = goalService
    }
    
    public func fetchGoals() async throws -> [Goal] {
        return try await goalService.fetchGoals()
    }
    
    public func addGoal(_ goal: Goal) async throws -> Goal {
        return try await goalService.addGoal(goal)
    }
    
    public func updateGoalProgress(id: String, newValue: Double) async throws -> Goal {
        return try await goalService.updateGoalProgress(id: id, newValue: newValue)
    }
}
