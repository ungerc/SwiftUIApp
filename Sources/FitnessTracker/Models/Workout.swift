import Foundation

/// Represents a fitness workout session.
/// Conforms to `Identifiable` for SwiftUI lists, `Codable` for persistence, and `Sendable` for concurrent access.
public struct Workout: Identifiable, Codable, Sendable {
    /// Unique identifier for the workout
    public let id: String
    /// User-defined name for the workout (e.g., "Morning Run")
    public let name: String
    /// Duration of the workout in seconds
    public let duration: TimeInterval
    /// Estimated calories burned during the workout
    public let caloriesBurned: Double
    /// Date and time when the workout was performed
    public let date: Date
    /// Type of workout activity
    public let type: WorkoutType
    
    /// Creates a new Workout instance.
    /// - Parameters:
    ///   - id: Unique identifier for the workout
    ///   - name: User-defined name for the workout
    ///   - duration: Duration in seconds
    ///   - caloriesBurned: Estimated calories burned
    ///   - date: Date and time of the workout
    ///   - type: Type of workout activity
    public init(id: String, name: String, duration: TimeInterval, caloriesBurned: Double, date: Date, type: WorkoutType) {
        self.id = id
        self.name = name
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.date = date
        self.type = type
    }
}

/// Types of workout activities supported by the app.
/// Conforms to `CaseIterable` for easy enumeration and `Sendable` for concurrent access.
public enum WorkoutType: String, Codable, CaseIterable, Sendable {
    /// Running or jogging activity
    case running
    /// Cycling or biking activity
    case cycling
    /// Swimming activity
    case swimming
    /// Weight lifting or strength training
    case weightLifting
    /// Yoga or stretching exercises
    case yoga
    /// High-Intensity Interval Training
    case hiit
    
    /// SF Symbol icon name for the workout type.
    /// Used for displaying icons in the UI.
    public var icon: String {
        switch self {
        case .running: return "figure.run"
        case .cycling: return "figure.outdoor.cycle"
        case .swimming: return "figure.pool.swim"
        case .weightLifting: return "dumbbell"
        case .yoga: return "figure.mind.and.body"
        case .hiit: return "heart.circle"
        }
    }
}
