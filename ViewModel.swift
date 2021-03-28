
import Foundation
import SwiftEventBus
import SideMenu

open class ViewModel: NSObject {

    var rootView: UIViewController?
    var baseCoordinator: BaseCoordinator?
    let disposeBag  = DisposeBag()
    var appData     = AppData(JSONString: Storage.sharedInstance.getAppData())
    
    private var sideMenu: SideMenuNavigationController?
    
    init(userDef: UserDefaults, coordinator: BaseCoordinator) {
        self.provider = provider
        self.baseCoordinator = coordinator
        super.init()

    }
    
    func initNavigationController(_ nvc: UINavigationController?){
        self.baseCoordinator?.navigationController = nvc
    }
    
    func deinitViewModel(){
        rootView        = nil
        provider        = nil
        baseCoordinator = nil
    }
    
    func castRootVC(){}
    func makeUI(){}
    
    func initBaseSideMenu(){

        sideMenu = R.storyboard.main().instantiateViewController(withIdentifier: "SideMenu") as? SideMenuNavigationController

        sideMenu?.presentationStyle  = .menuSlideIn
        sideMenu?.statusBarEndAlpha  = 0
        sideMenu?.menuWidth          = rootView!.view.frame.width
    }
    
    func initBaseSideMenuEventBus(_ obj: AnyObject){
        SwiftEventBus.onMainThread(obj, name: R.string.eventBus.side_MENU_CLICK()) { result in
            self.sideMenu?.dismiss(animated: true, completion: nil)
        }
        SwiftEventBus.onMainThread(obj, name: R.string.eventBus.side_MENU_PSC_CLICK()) { result in
            self.sideMenu?.dismiss(animated: true, completion: {
                self.baseCoordinator?.goToChildVC(R.storyboard.main.pscViewController()!)
            })
        }
        SwiftEventBus.onMainThread(obj, name: R.string.eventBus.side_MENU_HISTORY_CLICK()) { result in
            self.sideMenu?.dismiss(animated: true, completion: {
                self.baseCoordinator?.goToChildVC(R.storyboard.main.historyViewController()!)
            })
        }
        SwiftEventBus.onMainThread(obj , name: R.string.eventBus.side_MENU_PAY_CLICK()) { result in
            self.sideMenu?.dismiss(animated: true, completion: {
            })
        }
        SwiftEventBus.onMainThread(obj , name: R.string.eventBus.side_MENU_ONBOARDING_CLICK()) { result in
            self.sideMenu?.dismiss(animated: true, completion: {
                self.baseCoordinator?.goToOnboarding()
            })
        }
        
        SwiftEventBus.onMainThread(obj, name: R.string.eventBus.side_MENU_LOGOUT_CLICK()) { result in
            self.sideMenu?.dismiss(animated: true, completion: {
                Storage.sharedInstance.logout()
                SessionManager.removeSession()
                self.baseCoordinator?.goToRootVC()
            })
        }
    }

    func deinitBaseSideMenuEventBus(_ obj: AnyObject){
        SwiftEventBus.unregister(obj)
    }
    
    func showingBaseSideMenu(){
        if let menu = sideMenu {
            self.rootView!.present(menu, animated: true, completion: nil)
        }
    }
}
