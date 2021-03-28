
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
}

open class BaseCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController?
    
    func goToVC(_ vc: UIViewController, animated: Bool = true )  {
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func goToRootVC(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToChildVC(_ vc: UIViewController){
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut )
        transition.type = .reveal
        transition.subtype = .fromTop
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func backFromChildVC(){
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .reveal
        transition.subtype = .fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }
}
