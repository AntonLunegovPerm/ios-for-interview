//
//  SwinjectStoryboard.swift
//  guard.point
//
//  Created by user1 on 29.08.2020.
//  Copyright © 2020 poloniumarts. All rights reserved.
//

import Foundation
import SwinjectStoryboard
import SwinjectAutoregistration

extension SwinjectStoryboard {
    
    @objc class func setup() {
        
        // MARK: - defaults
        defaultContainer.autoregister(UserDefaults.self, initializer: UserDefaults.init)
//        defaultContainer.autoregister(SheetViewController.self, initializer: SheetViewController.init))
    
        // MARK: - coordinators
        defaultContainer.autoregister(BaseCoordinator.self, initializer: BaseCoordinator.init)
        defaultContainer.autoregister(AuthCoordinator.self, initializer: AuthCoordinator.init)
        
        defaultContainer.autoregister(HomeCoordinator.self, initializer: HomeCoordinator.init)

        // MARK: - viewmodels
            
        defaultContainer.autoregister(AuthViewModel.self, initializer: AuthViewModel.init)
        defaultContainer.autoregister(HomeViewModel.self,initializer: HomeViewModel.init)
        defaultContainer.autoregister(PSCViewModel.self,initializer: PSCViewModel.init)
        defaultContainer.autoregister(HistoryViewModel.self,initializer: HistoryViewModel.init)
        defaultContainer.autoregister(OrderViewModel.self,initializer: OrderViewModel.init)

        // MARK: - repositoryes
        defaultContainer.autoregister(AuthViewRepo.self, initializer: AuthViewRepo.init)
        defaultContainer.autoregister(HomeRepo.self, initializer: HomeRepo.init)
        
        // MARK: - controllers
        defaultContainer.storyboardInitCompleted(AuthViewController.self) { r, c in
            c.viewModel     = r~>
            c.coordinator   = r~>
            c.repository    = r~>
        }
        
        defaultContainer.storyboardInitCompleted(HomeViewController.self) { r, c in
            c.viewModel     = r~>
            c.coordinator   = r~>
            c.repository    = r~>
        }
        
        defaultContainer.storyboardInitCompleted(PSCViewController.self) { r, c in
            c.viewModel     = r~>
            c.coordinator   = r~>
            c.repository    = r~>
        }
        
        defaultContainer.storyboardInitCompleted(HistoryViewController.self) { r, c in
            c.viewModel     = r~>
            c.coordinator   = r~>
            c.repository    = r~>
        }
        
        defaultContainer.storyboardInitCompleted(OrderViewController.self) { r, c in
            c.viewModel     = r~>
            c.coordinator   = r~>
            c.repository    = r~>
        }
    }
}
