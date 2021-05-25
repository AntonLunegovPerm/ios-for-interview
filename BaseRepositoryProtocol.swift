//Base

import Foundation

protocol BaseRepositoryProtocol {
    
    associatedtype View
    
    func attachView(view: View)
    
    func detachView()
    
}
