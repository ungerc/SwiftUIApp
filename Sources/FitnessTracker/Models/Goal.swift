import Foundation

/// Represents a fitness goal that users can track.
/// Conforms to `Identifiable` for SwiftUI lists, `Codable` for persistence, and `Sendable` for concurrent access.
public struct Goal: Identifiable, Codable, Sendable {
    /// Unique identifier for the goal
    public let id: String
    /// User-defined name for the goal (e.g., "Lose 10 pounds")
    public let name: String
    /// The target value to achieve
    public let targetValue: Double
    /// The current progress value
    public let currentValue: Double
    /// Unit of measurement (e.g., "kg", "steps", "workouts")
    public let unit: String
    /// Optional deadline for achieving the goal
    public let deadline: Date?
    /// Type of goal (weight, steps, etc.)
    public let type: GoalType
    
    /// Creates a new Goal instance.
    /// - Parameters:
    ///   - id: Unique identifier for the goal
    ///   - name: User-defined name for the goal
    ///   - targetValue: The target value to achieve
    ///   - currentValue: The current progress value
    ///   - unit: Unit of measurement
    ///   - deadline: Optional deadline for achieving the goal
    ///   - type: Type of goal
    public init(id: String, name: String, targetValue: Double, currentValue: Double, unit: String, deadline: Date? = nil, type: GoalType) {
        self.id = id
        self.name = name
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.unit = unit
        self.deadline = deadline
        self.type = type
    }
    
    /// Calculates the progress percentage (0.0 to 1.0).
    /// - Returns: Progress as a decimal between 0 and 1, capped at 1.0 when goal is exceeded
    public var progress: Double {
        return min(currentValue / targetValue, 1.0)
    }
}

/// Types of fitness goals supported by the app.
/// Conforms to `CaseIterable` for easy enumeration and `Sendable` for concurrent access.
public enum GoalType: String, Codable, CaseIterable, Sendable {
    /// Weight loss or gain goal
    case weight
    /// Daily step count goal
    case steps
    /// Number of workouts per period
    case workouts
    /// Distance traveled (running, cycling, etc.)
    case distance
    /// Calorie burn goal
    case calories
    
    /// SF Symbol icon name for the goal type.
    /// Used for displaying icons in the UI.
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
