import Foundation
import Networking
import Authentication
import FitnessTracker

public class ServiceProvider {
    // Adapters
    public let networkAdapter: NetworkAdapter
    public let authAdapter: AuthAdapter
    public let workoutAdapter: WorkoutAdapter
    public let goalAdapter: GoalAdapter
    
    public init() {
        // Create core services
        let networkService = NetworkManager()
        let authService = AuthManager(networkService: networkService)
        
        // Create domain services
        let workoutService = WorkoutService(networkService: networkService, authService: authService)
        let goalService = GoalService(networkService: networkService, authService: authService)
        
        // Create adapters
        self.networkAdapter = NetworkAdapter(networkService: networkService)
        self.authAdapter = AuthAdapter(authService: authService)
        self.workoutAdapter = WorkoutAdapter(workoutService: workoutService)
        self.goalAdapter = GoalAdapter(goalService: goalService)
    }
    
    // For testing - allows injecting mock services
    public init(
        networkService: NetworkServiceProtocol,
        authService: AuthServiceProtocol,
        workoutService: WorkoutServiceProtocol,
        goalService: GoalServiceProtocol
    ) {
        self.networkAdapter = NetworkAdapter(networkService: networkService)
        self.authAdapter = AuthAdapter(authService: authService)
        self.workoutAdapter = WorkoutAdapter(workoutService: workoutService)
        self.goalAdapter = GoalAdapter(goalService: goalService)
    }
}
