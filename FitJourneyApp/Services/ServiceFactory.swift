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
    
    // Create an AuthManager using the adapter
    public func makeAuthManager() -> AuthManager {
        return AuthManager(authAdapter: applicationServiceFactory.makeAuthAdapter())
    }
    
    // Add other service factory methods as needed
}
