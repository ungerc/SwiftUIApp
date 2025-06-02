import SwiftUI

struct MainTabView: View {
    @ObservedObject var workoutViewModel: WorkoutViewModel
    @ObservedObject var goalViewModel: GoalViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init(workoutViewModel: WorkoutViewModel, goalViewModel: GoalViewModel) {
        self.workoutViewModel = workoutViewModel
        self.goalViewModel = goalViewModel
    }
    
    var body: some View {
        TabView {
            Text("Dashboard")
                .environmentObject(workoutViewModel)
                .environmentObject(goalViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
            
            Text("Workouts")
                .environmentObject(workoutViewModel)
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }
            
            Text("Goals")
                .environmentObject(goalViewModel)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
            
            Text("Profile")
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .task {
            async let workouts = workoutViewModel.fetchWorkouts()
            async let goals = goalViewModel.fetchGoals()
            _ = await (workouts, goals)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let networkManager = NetworkManager()
        let authManager = AuthManager(networkManager: networkManager)
        let workoutService = WorkoutService(networkManager: networkManager, authManager: authManager)
        let goalService = GoalService(networkManager: networkManager, authManager: authManager)
        
        MainTabView(
            workoutViewModel: WorkoutViewModel(workoutService: workoutService),
            goalViewModel: GoalViewModel(goalService: goalService)
        )
        .environmentObject(AuthViewModel(authManager: authManager))
    }
}
import SwiftUI

struct MainTabView: View {
    @ObservedObject var workoutViewModel: WorkoutViewModel
    @ObservedObject var goalViewModel: GoalViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init(workoutViewModel: WorkoutViewModel, goalViewModel: GoalViewModel) {
        self.workoutViewModel = workoutViewModel
        self.goalViewModel = goalViewModel
    }
    
    var body: some View {
        TabView {
            Text("Dashboard")
                .environmentObject(workoutViewModel)
                .environmentObject(goalViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
            
            Text("Workouts")
                .environmentObject(workoutViewModel)
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }
            
            Text("Goals")
                .environmentObject(goalViewModel)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
            
            Text("Profile")
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .task {
            async let workouts = workoutViewModel.fetchWorkouts()
            async let goals = goalViewModel.fetchGoals()
            _ = await (workouts, goals)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let networkManager = NetworkManager()
        let authManager = AuthManager(networkManager: networkManager)
        let workoutService = WorkoutService(networkManager: networkManager, authManager: authManager)
        let goalService = GoalService(networkManager: networkManager, authManager: authManager)
        
        MainTabView(
            workoutViewModel: WorkoutViewModel(workoutService: workoutService),
            goalViewModel: GoalViewModel(goalService: goalService)
        )
        .environmentObject(AuthViewModel(authManager: authManager))
    }
}
