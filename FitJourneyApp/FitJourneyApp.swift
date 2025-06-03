import SwiftUI
import AppCore

@main
struct FitJourneyApp: App {
    // Create the service factory
    private let serviceFactory = ServiceFactory()
    
    // Create view models with dependencies
    @State private var authViewModel = AuthViewModel()
    @State private var workoutViewModel = WorkoutViewModel()
    @State private var goalViewModel = GoalViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authViewModel)
                .environment(workoutViewModel)
                .environment(goalViewModel)
                .onAppear {
                    // Initialize view models with services
                    authViewModel.initialize(authManager: serviceFactory.makeAuthManager())
                    workoutViewModel.initialize(workoutService: serviceFactory.makeWorkoutService())
                    goalViewModel.initialize(goalService: serviceFactory.makeGoalService())
                }
        }
    }
}

// Main content view that handles authentication state
struct ContentView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                AuthView()
            }
        }
    }
}
