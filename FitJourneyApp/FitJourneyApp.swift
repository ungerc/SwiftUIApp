import SwiftUI
import Authentication
import FitnessTracker

@main
struct FitJourneyApp: App {
    // Create dependencies
    private let networkManager = NetworkManager()
    private lazy var authManager = AuthManager(networkManager: networkManager)
    private lazy var goalService = GoalService(networkManager: networkManager, authManager: authManager)
    private lazy var workoutService = WorkoutService(networkManager: networkManager, authManager: authManager)
    
    // Create view models
    @StateObject private var authViewModel: AuthViewModel
    @StateObject private var workoutViewModel: WorkoutViewModel
    @StateObject private var goalViewModel: GoalViewModel
    
    init() {
        // Initialize view models with dependencies
        let auth = AuthViewModel(authManager: authManager)
        let workout = WorkoutViewModel(workoutService: workoutService)
        let goal = GoalViewModel(goalService: goalService)
        
        _authViewModel = StateObject(wrappedValue: auth)
        _workoutViewModel = StateObject(wrappedValue: workout)
        _goalViewModel = StateObject(wrappedValue: goal)
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                MainTabView(workoutViewModel: workoutViewModel, goalViewModel: goalViewModel)
                    .environmentObject(authViewModel)
            } else {
                AuthView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
