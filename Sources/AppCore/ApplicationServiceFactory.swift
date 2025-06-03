import Foundation
import Networking
import Authentication
import FitnessTracker

public class ApplicationServiceFactory {
    private let serviceProvider: ServiceProvider
    
    public init() {
        self.serviceProvider = ServiceProvider()
    }
    
    // For testing
    public init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }
    
    // Auth services
    public func makeAuthAdapter() -> ApplicationAuthAdapter {
        return serviceProvider.authAdapter
    }
    
    // Workout services
    public func makeWorkoutAdapter() -> ApplicationWorkoutAdapter {
        return serviceProvider.workoutAdapter
    }
    
    // Goal services
    public func makeGoalAdapter() -> ApplicationGoalAdapter {
        return serviceProvider.goalAdapter
    }
    
    // Network services
    public func makeNetworkAdapter() -> ApplicationNetworkAdapter {
        return serviceProvider.networkAdapter
    }
}
