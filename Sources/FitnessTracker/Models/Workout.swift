import Foundation

public struct Workout: Identifiable, Codable {
    public let id: String
    public let name: String
    public let duration: TimeInterval
    public let caloriesBurned: Double
    public let date: Date
    public let type: WorkoutType
    
    public init(id: String, name: String, duration: TimeInterval, caloriesBurned: Double, date: Date, type: WorkoutType) {
        self.id = id
        self.name = name
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.date = date
        self.type = type
    }
}

public enum WorkoutType: String, Codable, CaseIterable {
    case running
    case cycling
    case swimming
    case weightLifting
    case yoga
    case hiit
    
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
