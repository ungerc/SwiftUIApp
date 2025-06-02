import Foundation
import FitnessTracker

class GoalViewModel: ObservableObject {
    private let goalService: GoalService
    
    init(goalService: GoalService) {
        self.goalService = goalService
    }
    
    @Published var goals: [Goal] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchGoals() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let fetchedGoals = try await goalService.fetchGoals()
            
            DispatchQueue.main.async {
                self.goals = fetchedGoals
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch goals: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func addGoal(_ goal: Goal) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let newGoal = try await goalService.addGoal(goal)
            
            DispatchQueue.main.async {
                self.goals.append(newGoal)
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to add goal: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func updateGoalProgress(id: String, newValue: Double) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let updatedGoal = try await goalService.updateGoalProgress(id: id, newValue: newValue)
            
            DispatchQueue.main.async {
                if let index = self.goals.firstIndex(where: { $0.id == id }) {
                    self.goals[index] = updatedGoal
                }
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to update goal: \(error.localizedDescription)"
                self.isLoading = false
            }
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
