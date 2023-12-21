import Foundation

extension ChatView {
    class ViewModel: ObservableObject {
        
        @Published var messages: [Message] = []
        @Published var currentInput: String = ""
        private let openAIService = OpenAIService()
        
        init(initString: String) {
            self.currentInput = initString
        }
        
        func updateCurrentInput(input: String) {
            self.currentInput = input
        }
        
        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            openAIService.sendMessage(messages: messages) { [weak self] response in 
                guard let self = self, let receiveOpenAIMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    self?.sendMessage()
                    return 
                }
                
                let receiveMessage = Message(id: UUID(), role: receiveOpenAIMessage.role, content: receiveOpenAIMessage.content, createAt: Date())
                
                DispatchQueue.main.async {
                    self.messages.append(receiveMessage)
                }
            }
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
