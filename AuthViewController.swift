//Authorization module

import UIKit

class AuthViewController: ViewController<AuthPresenter, AuthCoordinator, AuthViewRepo>, AuthViewProtocol {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: RegTextFieldView!
    @IBOutlet weak var passwordTextField: RegTextFieldView!
    @IBOutlet weak var nextButton: Button!
    
    @IBAction func OnNextButtonClick(_ sender: Any) {
        if let login = loginTextField.textField.text,
           let passw = passwordTextField.textField.text {
            repository?.signIn(login, passw)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.checkSessionAndOpenHomeVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear() {
        scrollView.isScrollEnabled = false
    }

    @objc func keyboardWillDisappear() {
        scrollView.isScrollEnabled = true
    }
    
    func showErrorPassword() {
        presenter?.showLoginError()
    }
    
    override func updateView() {
        self.loginTextField.textField.text      = ""
        self.passwordTextField.textField.text   = ""
        
        coordinator?.goToHomeVC()
    }
}
