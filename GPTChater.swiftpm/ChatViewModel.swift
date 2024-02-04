import Foundation

extension ChatView {
    class ViewModel: ObservableObject {
        
        @Published var messages: [Message] = []
        @Published var currentInput: String = ""
        private let openAIService = OpenAIService()
        
        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let receiveOpenAIMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    return 
                }
                let receiveMessage = Message(id: UUID(), role: receiveOpenAIMessage.role, content: receiveOpenAIMessage.content, createAt: Date())
                
                await MainActor.run {
                    messages.append(receiveMessage)
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
