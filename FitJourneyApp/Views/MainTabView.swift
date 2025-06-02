import SwiftUI
import FitnessTracker

struct MainTabView: View {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    @StateObject private var goalViewModel = GoalViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            DashboardView()
                .environmentObject(workoutViewModel)
                .environmentObject(goalViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
            
            WorkoutsView()
                .environmentObject(workoutViewModel)
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }
            
            GoalsView()
                .environmentObject(goalViewModel)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
            
            ProfileView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .task {
            await workoutViewModel.fetchWorkouts()
            await goalViewModel.fetchGoals()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AuthViewModel())
    }
}
