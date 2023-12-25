import SwiftUI
import Network

struct ContentView: View {
    
    @ObservedObject var networkSatus: NetworkManager
    
    init() {
        self.networkSatus = NetworkManager()
    }
    
    var body: some View {
        VStack {
            Text(networkSatus.self.isNetworkAvailable ? "connect" : "error")
            
            Button {
                print(networkSatus.self.isNetworkAvailable ? "connect" : "error")
            } label: {
                Text("update")
            }
        }
    }
}

extension ContentView {
    
    class NetworkManager: ObservableObject {
        let monitor = NWPathMonitor()
        var isNetworkAvailable: Bool = false
        
        init() {
            monitor.pathUpdateHandler = { path in 
                self.isNetworkAvailable = path.status == .satisfied
                if self.isNetworkAvailable {
                    print("connect")
                } else {
                    print("error")
                }
            }
            monitor.start(queue: DispatchQueue.global())
        }
    }
}
