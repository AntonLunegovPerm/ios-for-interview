
import Foundation
import Starscream

public enum SocketMethods: String {
    
    case connect        = "Connect"
    case subscribe      = "Subscribe"
    case unsubscribe    = "Unsubscribe"
}

class SocketManager: NSObject {

    static let sharedInstance = SocketManager()

    var ws: WebSocket?
    var isConnected = false
    
    override init(){
        super.init()
        
        guard let sessionId = SessionManager.shared.session?.id else {
            return
        }
        
        guard let url = URL(string: Configs.Network.testWs + sessionId) else {
            return
        }

        var request = URLRequest(url: url)
        print("connect to : \(Configs.Network.testWs + (SessionManager.shared.session?.id ?? ""))")
        request.timeoutInterval = 5
        
        ws = WebSocket(request: request)

    }
    
    func isConnect() -> Bool{
        return isConnected
    }
    
    func connect(){
        ws?.connect()
    }
    
    func disconnect(){
        ws?.disconnect()
    }
    
    func send(data: String){
        print("ws data = \(data)")
        ws?.write(string: "\(data)", completion: {
            print("success")
        })
    }
    
    func subscribe(completion: @escaping (String?) -> Void) {
        ws?.onEvent = { event in
            switch event {
                case .connected(let headers):
                    self.isConnected = true
                    completion(SocketMethods.connect.rawValue)
                    print("websocket is connected: \(headers)")
                    
                case .disconnected(let reason, let code):
                    self.isConnected = false
                    print("websocket is disconnected: \(reason) with code: \(code)")
                    
                case .text(let string):
                    print("Received text: \(string)")
                    completion(string)
                    
                case .binary(let data):
                    print("Received data: \(data.count)")
                    
                case .cancelled:
                    self.isConnected = false
                    print("websocket is cancelled")
                    
                case .error(let error):
                    self.isConnected = false
                    print("error = \(String(describing: error))")
                    completion("error = \(String(describing: error))")

                default:
                    break

            }
        }
    }
}
