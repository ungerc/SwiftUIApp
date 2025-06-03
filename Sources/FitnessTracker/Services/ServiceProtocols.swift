import Foundation

public protocol WorkoutServiceProtocol {
    func fetchWorkouts() async throws -> [Workout]
    func addWorkout(_ workout: Workout) async throws -> Workout
}

public protocol GoalServiceProtocol {
    func fetchGoals() async throws -> [Goal]
    func addGoal(_ goal: Goal) async throws -> Goal
    func updateGoalProgress(id: String, newValue: Double) async throws -> Goal
}
