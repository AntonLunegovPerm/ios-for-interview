//Base Presenter
 
import Foundation

open class Presenter: NSObject {

    var rootView: UIViewController?
    var baseCoordinator: BaseCoordinator?
    
    init(userDef: UserDefaults, coordinator: BaseCoordinator) {
        self.baseCoordinator = coordinator
        super.init()
    }
    
    func initNavigationController(_ nvc: UINavigationController?){
        self.baseCoordinator?.navigationController = nvc
    }
    
    func castRootVC(){}
    func makeUI(){}
    
    func deinitPresenter(){
        rootView        = nil
        baseCoordinator = nil
    }
}

