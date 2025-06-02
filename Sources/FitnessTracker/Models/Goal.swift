import Foundation

public struct Goal: Identifiable, Codable {
    public let id: String
    public let name: String
    public let targetValue: Double
    public let currentValue: Double
    public let unit: String
    public let deadline: Date?
    public let type: GoalType
    
    public init(id: String, name: String, targetValue: Double, currentValue: Double, unit: String, deadline: Date? = nil, type: GoalType) {
        self.id = id
        self.name = name
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.unit = unit
        self.deadline = deadline
        self.type = type
    }
    
    public var progress: Double {
        return min(currentValue / targetValue, 1.0)
    }
}

public enum GoalType: String, Codable, CaseIterable {
    case weight
    case steps
    case workouts
    case distance
    case calories
    
    public var icon: String {
        switch self {
        case .weight: return "scalemass"
        case .steps: return "figure.walk"
        case .workouts: return "figure.highintensity.intervaltraining"
        case .distance: return "map"
        case .calories: return "flame"
        }
    }
}
