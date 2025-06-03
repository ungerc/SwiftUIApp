import Foundation
import Networking
import Authentication

public class ServiceFactory {
    // Singleton instance for convenience
    public static let shared = ServiceFactory()
    
    // Core services
    private lazy var networkService: NetworkServiceProtocol = NetworkManager()
    private lazy var authService: AuthServiceProtocol = AuthManager(networkService: networkService)
    
    // Domain services
    public func makeWorkoutService() -> WorkoutServiceProtocol {
        return WorkoutService(networkService: networkService, authService: authService)
    }
    
    public func makeGoalService() -> GoalServiceProtocol {
        return GoalService(networkService: networkService, authService: authService)
    }
    
    // For testing purposes - allows injecting mock services
    public func configure(networkService: NetworkServiceProtocol, authService: AuthServiceProtocol) {
        self.networkService = networkService
        self.authService = authService
    }
}
