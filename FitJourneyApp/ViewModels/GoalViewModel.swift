import Foundation
import SwiftUI
import AppCore

@Observable
@MainActor
class GoalViewModel {
    private let goalAdapter: GoalAdapter
    
    init(goalAdapter: GoalAdapter) {
        self.goalAdapter = goalAdapter
    }
    
    var goals: [Goal] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    func fetchGoals() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedGoals = try await goalAdapter.fetchGoals()
            goals = fetchedGoals
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch goals: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func addGoal(_ goal: Goal) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let newGoal = try await goalAdapter.addGoal(goal)
            goals.append(newGoal)
            isLoading = false
        } catch {
            errorMessage = "Failed to add goal: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func updateGoalProgress(id: String, newValue: Double) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let updatedGoal = try await goalAdapter.updateGoalProgress(id: id, newValue: newValue)
            if let index = goals.firstIndex(where: { $0.id == id }) {
                goals[index] = updatedGoal
            }
            isLoading = false
        } catch {
            errorMessage = "Failed to update goal: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // Helper computed properties
    var completedGoals: [Goal] {
        goals.filter { $0.progress >= 1.0 }
    }
    
    var inProgressGoals: [Goal] {
        goals.filter { $0.progress < 1.0 }
    }
}
