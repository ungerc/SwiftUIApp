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
        _authViewModel = StateObject(wrappedValue: AuthViewModel(authManager: authManager))
        _workoutViewModel = StateObject(wrappedValue: WorkoutViewModel(workoutService: workoutService))
        _goalViewModel = StateObject(wrappedValue: GoalViewModel(goalService: goalService))
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
