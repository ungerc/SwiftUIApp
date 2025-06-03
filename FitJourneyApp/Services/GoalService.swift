import Foundation

class GoalService {
    private let networkManager: NetworkManager
    private let authManager: AuthManager

    init(networkManager: NetworkManager,
         authManager: AuthManager) {
        self.networkManager = networkManager
        self.authManager = authManager
    }

    func fetchGoals() async throws -> [Goal] {
        guard let _ = try? authManager.getToken() else {
            throw AuthError.notAuthenticated
        }

        // Mock implementation
        return [
            Goal(id: "1", name: "Lose Weight", targetValue: 10, currentValue: 3, unit: "kg", deadline: Date().addingTimeInterval(30*86400), type: .weight),
            Goal(id: "2", name: "Run More", targetValue: 20, currentValue: 5, unit: "km", deadline: Date().addingTimeInterval(14*86400), type: .distance)
        ]
    }

    func addGoal(_ goal: Goal) async throws -> Goal {
        guard let _ = try? authManager.getToken() else {
            throw AuthError.notAuthenticated
        }

        // Mock implementation - just return the goal
        return goal
    }

    func updateGoalProgress(id: String, newValue: Double) async throws -> Goal {
        guard let _ = try? authManager.getToken() else {
            throw AuthError.notAuthenticated
        }

        // Mock implementation - find the goal and update its progress
        let mockGoal = Goal(id: id, name: "Updated Goal", targetValue: 10, currentValue: newValue, unit: "units", deadline: Date().addingTimeInterval(30*86400), type: .workouts)
        return mockGoal
    }
}

struct Goal: Identifiable, Codable {
    public let id: String
    public let name: String
    public let targetValue: Double
    public let currentValue: Double
    public let unit: String
    public let deadline: Date?
    public let type: GoalType

    public var progress: Double {
        return currentValue / targetValue
    }

    init(id: String, name: String, targetValue: Double, currentValue: Double, unit: String, deadline: Date?, type: GoalType) {
        self.id = id
        self.name = name
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.unit = unit
        self.deadline = deadline
        self.type = type
    }
}

enum GoalType: String, Codable, CaseIterable {
    case weight
    case steps
    case workouts
    case distance
    case calories

    public var icon: String {
        switch self {
        case .weight: return "scalemass"
        case .steps: return "figure.walk"
        case .workouts: return "figure.run"
        case .distance: return "map"
        case .calories: return "flame"
        }
    }
}
