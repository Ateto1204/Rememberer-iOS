import Foundation
import Network

extension ChatView {
    
    class ViewModel: ObservableObject {
        
        @Published var messages: [Message] = []
        @Published var currentInput: String = ""
        @Published var response: [Question] = []
        @Published var hasResponse: Bool = false
        @Published var requestCrash: Bool = false
        private let openAIService = OpenAIService()
        
        init(initString: String) {
            self.currentInput = initString
        }
        
        func updateCurrentInput(input: String) {
            self.currentInput = input
        }
        
        func sendMessage() {
            
            self.hasResponse = false
            
            openAIService.sendMessage(messages: messages) { [weak self] response in 
                guard let self = self, let receiveOpenAIMessage = response else {
                    print("Had no received message")
                    self?.requestCrash = true
//                    self?.sendMessage()
                    return 
                }
                
                let receiveMessage = Message(id: UUID(), content: receiveOpenAIMessage, createAt: Date())
                
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
    let content: [Question]
    let createAt: Date
}
