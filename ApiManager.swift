//Api

import Foundation
import Moya
import ObjectMapper
import Moya_ObjectMapper

enum APIEnvironment{
    case dev
    case prod
}

struct ApiManager {
    
    static let environment: APIEnvironment = .prod
    
    static let apieMoyaProvider = MoyaProvider<Api>(plugins: [NetworkLoggerPlugin()])
    
    static func request<D: Decodable>(view: UIViewController, target: Api, responseModel : D.Type, success successCallback: @escaping (D) -> Void, error errorCallback: @escaping (Int) -> Void, _ isProgressStart: Bool = true, _ isProgressFinish: Bool = true)  {
        
        if isProgressStart {
            view.showProgress()
        }
        
        apieMoyaProvider.request(target) { (result) in
            switch result {
            case .success(let response):
                
                let statusCode = response.response?.statusCode ?? 0
                var resp: D!
                
                // MARK: - log start
                do {
                    try print("DEBUG REQUEST = " + response.mapString())
                    if let data = response.request?.httpBody {
                        print(String(decoding:data, as: UTF8.self))
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
                // MARK: - log finish
                switch statusCode {
                    case 200...299:
                        do {
                            resp = try response.map(responseModel.self)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                        
                        if isProgressFinish {
                            view.hideProgress { _ in
                                if resp != nil{
                                    successCallback(resp)
                                }
                            }
                            
                        }else{
                            if resp != nil{
                                successCallback(resp)
                            }
                        }
                        
                        break
                      
                    case 400:
                        view.hideProgress()
                        errorCallback(statusCode)
                        break
                        
                    case 401:
                        view.hideProgress()
                        errorCallback(statusCode)
                        break
                        
                    case 403:
                        view.hideProgress()
                        errorCallback(statusCode)
                        break
                        
                    case 404:
                        view.hideProgress()
                        view.showError("???????????? 404.")
                        errorCallback(statusCode)
                        break
                        
                    case 405:
                        break
                    case 406:
                        break
                    case 413:
                        view.hideProgress()
                        view.showError("???????????? 413. ?????????????? ?????????????? ????????.")
                        errorCallback(statusCode)
                        break
                    case 422:
                        break
                    case 500:
                        view.hideProgress()
                        view.showError("???????????? ???? ????????????????")
                        errorCallback(statusCode)
                        break
                        
                    default:
                        view.hideProgress()
                        view.showError("?????????????????????? ????????????")
                        errorCallback(statusCode)
                        break
                }
                
                break

            case .failure(let error):
                print("Error = \(error)")
                view.hideProgress()
                errorCallback(0)
                view.showError("?????????????????????? ???????????????? ????????????????????")
                break
            }
        }
    }
}
