import SwiftUI

struct MainTabView: View {
    var workoutViewModel: WorkoutViewModel
    var goalViewModel: GoalViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    
    init(workoutViewModel: WorkoutViewModel, goalViewModel: GoalViewModel) {
        self.workoutViewModel = workoutViewModel
        self.goalViewModel = goalViewModel
    }
    
    var body: some View {
        TabView {
            Text("Dashboard")
                .environment(workoutViewModel)
                .environment(goalViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
            
            Text("Workouts")
                .environment(workoutViewModel)
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }
            
            Text("Goals")
                .environment(goalViewModel)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
            
            Text("Profile")
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

#Preview {
    let networkManager = NetworkManager()
    let authManager = AuthManager(networkManager: networkManager)
    let workoutService = WorkoutService(networkManager: networkManager, authManager: authManager)
    let goalService = GoalService(networkManager: networkManager, authManager: authManager)
    
    return MainTabView(
        workoutViewModel: WorkoutViewModel(workoutService: workoutService),
        goalViewModel: GoalViewModel(goalService: goalService)
    )
    .environment(AuthViewModel(authManager: authManager))
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
