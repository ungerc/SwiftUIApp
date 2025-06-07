import Testing
@testable import FitnessTracker

@Suite("Model Tests")
struct ModelTests {
    
    // MARK: - Goal Tests
    
    @Test("Goal progress calculates correctly")
    func goalProgressCalculation() {
        // Given
        let goal = Goal(
            id: "1",
            name: "Test Goal",
            targetValue: 100,
            currentValue: 75,
            unit: "units",
            type: .workouts
        )
        
        // When
        let progress = goal.progress
        
        // Then
        #expect(progress == 0.75)
    }
    
    @Test("Goal progress when exceeded caps at 1")
    func goalProgressExceededCapsAt1() {
        // Given
        let goal = Goal(
            id: "1",
            name: "Test Goal",
            targetValue: 100,
            currentValue: 150,
            unit: "units",
            type: .workouts
        )
        
        // When
        let progress = goal.progress
        
        // Then
        #expect(progress == 1.0)
    }
    
    @Test("Goal progress when zero is zero")
    func goalProgressWhenZero() {
        // Given
        let goal = Goal(
            id: "1",
            name: "Test Goal",
            targetValue: 100,
            currentValue: 0,
            unit: "units",
            type: .workouts
        )
        
        // When
        let progress = goal.progress
        
        // Then
        #expect(progress == 0.0)
    }
    
    // MARK: - GoalType Tests
    
    @Test("GoalType icon returns correct icon")
    func goalTypeIcon() {
        // Given/When/Then
        #expect(GoalType.weight.icon == "scalemass")
        #expect(GoalType.steps.icon == "figure.walk")
        #expect(GoalType.workouts.icon == "figure.highintensity.intervaltraining")
        #expect(GoalType.distance.icon == "map")
        #expect(GoalType.calories.icon == "flame")
    }
    
    @Test("GoalType all cases contains all types")
    func goalTypeAllCases() {
        // Given/When
        let allCases = GoalType.allCases
        
        // Then
        #expect(allCases.count == 5)
        #expect(allCases.contains(.weight))
        #expect(allCases.contains(.steps))
        #expect(allCases.contains(.workouts))
        #expect(allCases.contains(.distance))
        #expect(allCases.contains(.calories))
    }
    
    // MARK: - Workout Tests
    
    @Test("Workout initialization sets all properties")
    func workoutInitialization() {
        // Given
        let id = "123"
        let name = "Morning Run"
        let duration: TimeInterval = 3600
        let caloriesBurned = 500.0
        let date = Date()
        let type = WorkoutType.running
        
        // When
        let workout = Workout(
            id: id,
            name: name,
            duration: duration,
            caloriesBurned: caloriesBurned,
            date: date,
            type: type
        )
        
        // Then
        #expect(workout.id == id)
        #expect(workout.name == name)
        #expect(workout.duration == duration)
        #expect(workout.caloriesBurned == caloriesBurned)
        #expect(workout.date == date)
        #expect(workout.type == type)
    }
    
    // MARK: - WorkoutType Tests
    
    @Test("WorkoutType icon returns correct icon")
    func workoutTypeIcon() {
        // Given/When/Then
        #expect(WorkoutType.running.icon == "figure.run")
        #expect(WorkoutType.cycling.icon == "figure.outdoor.cycle")
        #expect(WorkoutType.swimming.icon == "figure.pool.swim")
        #expect(WorkoutType.weightLifting.icon == "dumbbell")
        #expect(WorkoutType.yoga.icon == "figure.mind.and.body")
        #expect(WorkoutType.hiit.icon == "heart.circle")
    }
    
    @Test("WorkoutType all cases contains all types")
    func workoutTypeAllCases() {
        // Given/When
        let allCases = WorkoutType.allCases
        
        // Then
        #expect(allCases.count == 6)
        #expect(allCases.contains(.running))
        #expect(allCases.contains(.cycling))
        #expect(allCases.contains(.swimming))
        #expect(allCases.contains(.weightLifting))
        #expect(allCases.contains(.yoga))
        #expect(allCases.contains(.hiit))
    }
}
