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
    @State private var authViewModel: AuthViewModel
    @State private var workoutViewModel: WorkoutViewModel
    @State private var goalViewModel: GoalViewModel
    
    init() {
        // Initialize view models with dependencies
        let auth = AuthViewModel(authManager: authManager)
        let workout = WorkoutViewModel(workoutService: workoutService)
        let goal = GoalViewModel(goalService: goalService)
        
        _authViewModel = State(wrappedValue: auth)
        _workoutViewModel = State(wrappedValue: workout)
        _goalViewModel = State(wrappedValue: goal)
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
