
import Foundation
import RxSwift
import RxCocoa
import Moya

enum Api {
    
    case checkServer
    
    case login(_ signin: LoginRequest)
    case logout

}

extension Api: TargetType {
    
    var environmentBaseUrl: String {
        
        switch ApiManager.environment {
            
            case .dev:   return Configs.Network.testUrl
            case .prod:  return Configs.Network.baseUrl
        }
    }
    
    var baseURL: URL {return URL(string: environmentBaseUrl)!}
    
    var task: Task {
        switch self {
        
        case let .login(signin):
            return .requestData((signin.toJSONString(prettyPrint: true)?.data(using: .utf8))!)
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {

        let assigned: [String: String] = [
            "Content-Type" : "application/json",
            "Authenticate": SessionManager.shared.session?.id  ?? ""
        ]
        
        return assigned
    }
    
    var path: String {
        
        switch self {
            case .login(_ ):
                return "login"
            case .logout:
                return "logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        
            case .login(_ ):
                return .post
                
            default:
                return .get
        }
    }
    
    var sampleData: Data {
        
        switch self {
            default:
                return Data()
        }
    }
}
