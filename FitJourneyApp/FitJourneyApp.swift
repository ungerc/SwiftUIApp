import SwiftUI

@main
struct FitJourneyApp: App {
    // Create dependencies
    private let networkManager = NetworkManager()
    private lazy var authManager = AuthManager(networkManager: networkManager)
    private lazy var goalService = GoalService(networkManager: networkManager, authManager: authManager)
    private lazy var workoutService = WorkoutService(networkManager: networkManager, authManager: authManager)
    
    // Create view models
    @State private var authViewModel = AuthViewModel(authManager: AuthManager(networkManager: NetworkManager()))
    @State private var workoutViewModel = WorkoutViewModel(workoutService: WorkoutService(networkManager: NetworkManager(), authManager: AuthManager(networkManager: NetworkManager())))
    @State private var goalViewModel = GoalViewModel(goalService: GoalService(networkManager: NetworkManager(), authManager: AuthManager(networkManager: NetworkManager())))
    
    init() {
        // Initialize view models with dependencies
        authViewModel = AuthViewModel(authManager: authManager)
        workoutViewModel = WorkoutViewModel(workoutService: workoutService)
        goalViewModel = GoalViewModel(goalService: goalService)
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                MainTabView(workoutViewModel: workoutViewModel,
                            goalViewModel: goalViewModel)
                    .environment(authViewModel)
            } else {
                AuthView()
                    .environment(authViewModel)
            }
        }
    }
}
