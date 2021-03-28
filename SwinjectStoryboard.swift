
import Foundation
import SwinjectStoryboard
import SwinjectAutoregistration

extension SwinjectStoryboard {
    
    @objc class func setup() {
        
        // MARK: - defaults
        defaultContainer.autoregister(UserDefaults.self, initializer: UserDefaults.init)

    
        // MARK: - coordinators
        defaultContainer.autoregister(BaseCoordinator.self, initializer: BaseCoordinator.init)
        defaultContainer.autoregister(AuthCoordinator.self, initializer: AuthCoordinator.init)
        
        // MARK: - viewmodels
            
        defaultContainer.autoregister(AuthViewModel.self, initializer: AuthViewModel.init)

        // MARK: - repositoryes
        defaultContainer.autoregister(AuthViewRepo.self, initializer: AuthViewRepo.init)
        
        // MARK: - controllers
        defaultContainer.storyboardInitCompleted(AuthViewController.self) { r, c in
            c.viewModel     = r~>
            c.coordinator   = r~>
            c.repository    = r~>
        }
    }
}
