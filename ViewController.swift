
import UIKit
import RxSwift

class ViewController<U: ViewModel, S: BaseCoordinator, M: Repository>: UIViewController, BaseViewProtocol {
    
    typealias T = U
    typealias C = S
    typealias X = M
    
    var viewModel:      T?
    var coordinator:    C?
    var repository:     X?

    convenience init() {
        self.init(viewModel: nil, coordinator: nil, repository: nil)
    }

    init(viewModel: T?, coordinator: C?, repository: X?) {
        self.coordinator    = coordinator
        self.viewModel      = viewModel
        self.repository     = repository
        super.init(nibName: nil, bundle: nil)
        self.repository?.view = self
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        viewModel?.deinitViewModel()
        viewModel   = nil
        coordinator = nil
        repository  = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.rootView = self
        repository?.attachView(view: self)
        castRootVC()
        makeUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initCoordinator()
    }
    
    func makeUI() {
        viewModel?.makeUI()
    }
    func castRootVC(){
        viewModel?.castRootVC()
    }
    
    func initCoordinator(){
        coordinator?.navigationController = navigationController
    }
    
    func updateView() {}
    
    func logout() {
        Storage.sharedInstance.logout()
        SessionManager.removeSession()
        self.coordinator?.goToRootVC()
    }
    func errorForbidden() {}
}

extension UIViewController {
    
    func showError(_ errorDescription: String, duration: TimeInterval = 1) {
        let view = ErrorView()
        view.setMessage(errorDescription)
        view.frame = CGRect(x: 0, y: getStatusBarHeight(), width: self.view.bounds.width, height: 80)
        view.isHidden = true
        self.view.addSubview(view)
        view.fadeIn(duration: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            view.fadeOut(duration: 1)
        }
    }
    
    func logoutFrom403(_ repo: Repository){
        repo.logout()
    }
    
    
    // MARK: - progress work
    func showProgress(completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }){
        let view = ProgressBarView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
          self.view.addSubview(view)
        }, completion: {_ in
            completion(true)
        })
    }
    
    func hideProgress(completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        
        if let subview = self.view.viewWithTag(ConstUtil.Tags.progressView.rawValue) {
            UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                subview.removeFromSuperview()
            }, completion: {
                (completed) in completion(true)})
        }else{
            completion(true)
        }
    }
    
    func showToast(message : String, font: UIFont, duration: TimeInterval = 6) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor =   R.color.primary()!.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func getStatusBarHeight() -> CGFloat {
       var statusBarHeight: CGFloat = 0
       if #available(iOS 13.0, *) {
           let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
           statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       } else {
           statusBarHeight = UIApplication.shared.statusBarFrame.height
       }
       return statusBarHeight
   }
}
