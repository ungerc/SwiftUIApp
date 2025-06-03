import SwiftUI
import AppCore

@main
struct FitJourneyApp: App {
    // Create service provider
    private let serviceProvider = ServiceProvider()
    
    // Create view models
    @State private var authViewModel = AuthViewModel(authAdapter: serviceProvider.authAdapter)
    @State private var workoutViewModel = WorkoutViewModel(workoutAdapter: serviceProvider.workoutAdapter)
    @State private var goalViewModel = GoalViewModel(goalAdapter: serviceProvider.goalAdapter)
    
    // No need for custom initializer as we're initializing directly in the property declarations
    
    var body: some Scene {
        WindowGroup {

                //            if authViewModel.isAuthenticated {
                MainTabView(workoutViewModel: workoutViewModel,
                            goalViewModel: goalViewModel)
                .environment(authViewModel)
                
                //            } else {
                //                AuthView()
                //                    .environment(authViewModel)
                //            }
        }
    }
}
