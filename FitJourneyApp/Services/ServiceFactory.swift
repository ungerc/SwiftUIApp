import Foundation
import AppCore

// Factory for creating app-level services using the adapters
public class ServiceFactory {
    private let applicationServiceFactory: ApplicationServiceFactory
    
    public init() {
        self.applicationServiceFactory = ApplicationServiceFactory()
    }
    
    // For testing
    public init(applicationServiceFactory: ApplicationServiceFactory) {
        self.applicationServiceFactory = applicationServiceFactory
    }
    
    // Create a WorkoutService using the adapter
    public func makeWorkoutService() -> WorkoutService {
        return WorkoutService(workoutAdapter: applicationServiceFactory.makeWorkoutAdapter())
    }
    
    // Create a GoalService using the adapter
    public func makeGoalService() -> GoalService {
        return GoalService(goalAdapter: applicationServiceFactory.makeGoalAdapter())
    }
    
    // Create an AuthManager using the adapter
    public func makeAuthManager() -> AuthManager {
        return AuthManager(authAdapter: applicationServiceFactory.makeAuthAdapter())
    }
    
    // Create a NetworkManager using the adapter
    public func makeNetworkManager() -> NetworkManager {
        return NetworkManager(networkAdapter: applicationServiceFactory.makeNetworkAdapter())
    }
}
