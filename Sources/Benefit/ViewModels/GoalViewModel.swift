import SwiftUI

/// View model for managing goal data and UI state.
/// Handles fetching, adding, updating, and deleting goals while managing loading states.
@Observable
@MainActor
public class GoalViewModel {
    /// The underlying goal service
    let goalService: GoalServiceProtocol
    
    /// Array of goals displayed in the UI
    public var goals: [Goal] = []
    
    /// Indicates whether a goal operation is in progress
    public var isLoading = false
    
    /// Error message to display to the user, if any
    public var errorMessage: String?
    
    /// Filters and returns goals that are still in progress.
    /// - Returns: Array of goals with progress less than 100%
    public var inProgressGoals: [Goal] {
        goals.filter { $0.progress < 1.0 }
    }
    
    /// Filters and returns completed goals.
    /// - Returns: Array of goals with progress at or above 100%
    public var completedGoals: [Goal] {
        goals.filter { $0.progress >= 1.0 }
    }
    
    /// Creates a new GoalViewModel.
    /// - Parameter goalService: The goal service to use for data operations
    public init(goalService: GoalServiceProtocol) {
        self.goalService = goalService
    }
    
    public func fetchGoals() async {
        isLoading = true
        errorMessage = nil
        
        do {
            goals = try await goalService.fetchGoals()
        } catch {
            errorMessage = "Failed to fetch goals"
        }
        
        isLoading = false
    }

    func fetchGoal(id: String) async throws -> Goal? {
        try await goalService.fetchGoals().first(where: { $0.id == id })
    }

    public func addGoal(name: String, type: GoalType, targetValue: Double, currentValue: Double, unit: String, deadline: Date?) async {
        isLoading = true
        errorMessage = nil
        
        let newGoal = Goal(
            id: UUID().uuidString,
            name: name,
            targetValue: targetValue,
            currentValue: currentValue,
            unit: unit,
            deadline: deadline,
            type: type
        )
        
        do {
            let addedGoal = try await goalService.addGoal(newGoal)
            goals.append(addedGoal)
        } catch {
            errorMessage = "Failed to add goal"
        }
        
        isLoading = false
    }
    
    public func updateGoalProgress(id: String, newValue: Double) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let updatedGoal = try await goalService.updateGoalProgress(id: id, newValue: newValue)
            if let index = goals.firstIndex(where: { $0.id == id }) {
                goals[index] = updatedGoal
            }
        } catch {
            errorMessage = "Failed to update goal progress"
        }
        
        isLoading = false
    }
    
    public func deleteGoal(id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await goalService.deleteGoal(id: id)
            goals.removeAll { $0.id == id }
        } catch {
            errorMessage = "Failed to delete goal"
        }
        
        isLoading = false
    }
}
