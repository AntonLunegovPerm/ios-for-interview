
import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

final class AuthViewModel: ViewModel{
    
    // MARK: - Private properties
    private var castView: AuthViewController!

    
    // MARK: - Lifecycle
    override func castRootVC() {
        castView = rootView as? AuthViewController
    }
    
    override func makeUI() {
        
        castView.nextButton.isEnabled   = false
        initLoginObserver()
    }
    
    override func deinitViewModel() {
        castView = nil
        super.deinitViewModel()
    }
    
    func checkSessionAndOpenHomeVC(){
        if  SessionManager.shared.session != nil  && !Storage.sharedInstance.getAppData().isEmpty{
            castView.coordinator?.goToHomeVCWithiutAnimation()
            if let appData = AppData(JSONString: Storage.sharedInstance.getAppData()){
                appData.user = nil
                Storage.sharedInstance.setAppData(data: appData.toJSONString() ?? "")
            }
        }else{
            SessionManager.removeSession()
            Storage.sharedInstance.removeAppData()
        }
    }
    
    // MARK: - init functions
    
    private func initLoginObserver(){
        
        let passwordOneTextFieldValidation = castView.loginTextField.textField
            
            .rx.text
            .map({(!$0!.isEmpty && $0?.count == 6)})
            .share(replay: 1)
        
        let passwordTwoTextFieldValidation = castView.passwordTextField.textField
            
            .rx.text
            .map({(!$0!.isEmpty && $0?.count == 8)})
            .share(replay: 1)
        
        let enableButton = Observable.combineLatest(passwordOneTextFieldValidation, passwordTwoTextFieldValidation) { (log, pass) -> Bool in
           
            if log && pass && IQKeyboardManager.shared.keyboardShowing{
                self.castView.view.endEditing(true)
            }
            
            
            return log && pass
        }
        
        
        enableButton.bind(to: castView.nextButton.rx.isEnabled)
              .disposed(by: disposeBag)
    }
    
    
    // MARK: - UX/UI functions
    
    func showLoginError() {
        castView.loginTextField.errorText.text = "Неверный логин или пароль"
        castView.loginTextField.errorText.fadeIn(alpha: 1.0, duration: 0.3, delay: 0) { (Bool) in
            self.castView.loginTextField.errorText.shake(count: 3, for: 0.2, withTranslation: 5)
            self.castView.loginTextField.textField.textFieldError()
            self.castView.passwordTextField.textField.textFieldError()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.castView.loginTextField.errorText.fadeOut()
            self.castView.loginTextField.textField.textFieldGeneral()
            self.castView.passwordTextField.textField.textFieldGeneral()
        }
    }
}
