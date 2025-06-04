import Foundation

import Networking
import Authentication
import FitnessTracker

public class ServiceProvider {
    // Application Adapters
    public let networkAdapter: ApplicationNetworkAdapter
    public let authAdapter: ApplicationAuthAdapter
    public let workoutAdapter: ApplicationWorkoutAdapter
    public let goalAdapter: ApplicationGoalAdapter
    
    public init() {
        // Create core services
        let networkService = NetworkManager()
        let authService = AuthManager(networkService: networkService)
        
        // Create domain services
        let workoutService = WorkoutService(networkService: networkService, authService: authService)
        let goalService = GoalService(networkService: networkService, authService: authService)
        
        // Create adapters
        self.networkAdapter = ConcreteNetworkAdapter(networkService: networkService)
        self.authAdapter = ConcreteAuthAdapter(authService: authService)
        self.workoutAdapter = ConcreteWorkoutAdapter(workoutService: workoutService)
        self.goalAdapter = ConcreteGoalAdapter(goalService: goalService)
    }
    
    // For testing - allows injecting mock services
    public init(
        networkService: NetworkServiceProtocol,
        authService: AuthServiceProtocol,
        workoutService: WorkoutServiceProtocol,
        goalService: GoalServiceProtocol
    ) {
        self.networkAdapter = ConcreteNetworkAdapter(networkService: networkService)
        self.authAdapter = ConcreteAuthAdapter(authService: authService)
        self.workoutAdapter = ConcreteWorkoutAdapter(workoutService: workoutService)
        self.goalAdapter = ConcreteGoalAdapter(goalService: goalService)
    }
}
