import Foundation
import Network

extension ChatView {
    
    class ViewModel: ObservableObject {
        
        @Published var messages: [Message] = []
        @Published var message: String = ""
        @Published var response: String = ""
        @Published var hasResponse: Bool = false
        @Published var requestCrash: Bool = false
        private let openAIService = OpenAIService()
        
        init(initString: String) {
            self.message = initString
        }
        
        func updateMessage(input: String) {
            self.message = input
        }
        
        func sendMessage() {
            
            self.hasResponse = false
            let newMessage = Message(id: UUID(), role: .user, content: message)
            messages.append(newMessage)
            
            openAIService.sendMessage(messages: messages) { [weak self] response in 
                guard let self = self, let receiveOpenAIMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    self?.requestCrash = true
                    return 
                }
                
                let receiveMessage = Message(id: UUID(), role: receiveOpenAIMessage.role, content: receiveOpenAIMessage.content)
                self.response = receiveMessage.content
                print("receive: \(self.response)")
                self.hasResponse = true
                
                DispatchQueue.main.async {
                    self.messages.append(receiveMessage)
                }
            }
        }
        
    }
    
    class NetworkManager: ObservableObject {
        let monitor = NWPathMonitor()
        @Published var isNetworkAvailable: Bool = false
        
        init() {
            monitor.pathUpdateHandler = { path in 
                self.isNetworkAvailable = path.status == .satisfied
            }
            monitor.start(queue: DispatchQueue.global())
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
}
