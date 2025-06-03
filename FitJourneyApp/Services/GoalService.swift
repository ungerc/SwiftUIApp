import Foundation
import AppCore

// This is now a wrapper around the ApplicationGoalAdapter
public class GoalService {
    private let goalAdapter: ApplicationGoalAdapter
    
    init(goalAdapter: ApplicationGoalAdapter) {
        self.goalAdapter = goalAdapter
    }
    
    public func fetchGoals() async throws -> [Goal] {
        return try await goalAdapter.fetchGoals()
    }
    
    public func addGoal(_ goal: Goal) async throws -> Goal {
        return try await goalAdapter.addGoal(
            name: goal.name,
            type: goal.type,
            targetValue: goal.targetValue,
            currentValue: goal.currentValue,
            unit: goal.unit,
            deadline: goal.deadline
        )
    }
    
    public func updateGoalProgress(id: String, newValue: Double) async throws -> Goal {
        return try await goalAdapter.updateGoalProgress(id: id, newValue: newValue)
    }
    
    // Convenience method to delete a goal
    public func deleteGoal(id: String) async throws {
        try await goalAdapter.deleteGoal(id: id)
    }
}

// Using the types from AppCore
public typealias Goal = AppCore.Goal
public typealias GoalType = AppCore.GoalType
