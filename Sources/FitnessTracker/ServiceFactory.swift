import Foundation

public class ServiceFactory {
    // Core services
    private let networkService: NetworkServiceProtocol
    private let authService: AuthServiceProtocol
    
    public init(
        networkService: NetworkServiceProtocol = NetworkManager(),
        authService: AuthServiceProtocol? = nil
    ) {
        self.networkService = networkService
        self.authService = authService ?? AuthManager(networkService: networkService)
    }
    
    // Domain services
    public func makeWorkoutService() -> WorkoutServiceProtocol {
        return WorkoutService(networkService: networkService, authService: authService)
    }
    
    public func makeGoalService() -> GoalServiceProtocol {
        return GoalService(networkService: networkService, authService: authService)
    }
}
