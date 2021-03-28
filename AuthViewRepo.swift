
import UIKit
import ObjectMapper

class AuthViewRepo: Repository{
    
    var currentView: AuthViewProtocol!
    
    override func attachView(view: BaseViewProtocol) {
        self.view =  view
        currentView = view as? AuthViewProtocol
    }
    
    func signIn(_ login : String, _ password: String){
        ApiManager.request(view: self.view as! UIViewController ,target: .login(LoginRequest(login, password)), responseModel: Session.self, success: { (response) in
          
                SessionManager.setSession(session: response)
            
                if let pscId = response.psc_id,
                   let crewId = response.crew_id{
//                    self.getPSC(pscId, crewId)
                }else{
                    self.showError("ЧОП не найден")
                }

        }, error: { (error) in
            self.currentView.showErrorPassword()
            
            if error == 403 {
                self.showError("Ошибка авторизации", duration: 3)
            }
            
        }, true, false)
    }
}
