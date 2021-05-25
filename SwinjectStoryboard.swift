
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
        
        // MARK: - presenter
            
        defaultContainer.autoregister(AuthPresenter.self, initializer: AuthPresenter.init)

        // MARK: - repositoryes
        defaultContainer.autoregister(AuthViewRepo.self, initializer: AuthViewRepo.init)
        
        // MARK: - controllers
        defaultContainer.storyboardInitCompleted(AuthViewController.self) { r, c in
            c.presenter     = r~>
            c.coordinator   = r~>
            c.repository    = r~>
        }
    }
}
