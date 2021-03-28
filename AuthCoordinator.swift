
import UIKit

class AuthCoordinator: BaseCoordinator {
    
    func goToHomeVC() {
        goToVC(R.storyboard.main.homeViewController()!)
    }
    
    func goToHomeVCWithiutAnimation() {
        goToVC(R.storyboard.main.homeViewController()!, animated: false)
    }
}
