
import UIKit

class Repository: BaseRepositoryProtocol {

    typealias View = BaseViewProtocol
    weak var view: View?
    
    func attachView(view: BaseViewProtocol) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func showError(_ errorText: String){
        (self.view as! UIViewController).showError(errorText)
    }
    
    func showError(_ errorText: String, duration: TimeInterval){
        (self.view as! UIViewController).showError(errorText, duration: duration)
    }
    
    func checkServer(){
        ApiManager.request(view: self.view as! UIViewController ,target: .checkServer, responseModel: Ok.self, success: { (response) in
            
            print("isOk = \(response.ok)")
            
        }, error: { (error) in
            
        })
    }
    
    func logout(){
        ApiManager.request(view: self.view as! UIViewController ,target: .logout, responseModel: Ok.self, success: { (response) in
                if response.ok {
                    self.view?.logout()
                }

        }, error: { (error) in
            if error == 403 || error == 401{
                self.view?.logout()
            }
        })
    }
}
