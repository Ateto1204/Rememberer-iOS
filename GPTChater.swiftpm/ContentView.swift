import SwiftUI
import Combine

struct ContentView: View {
    
    @State var chatMessages: [ChatMessage] = []
    @State var messageText: String = ""
    
    let openAIService = OpenAIService()
    @State var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            
            ScrollView {
                LazyVStack {
                    ForEach(chatMessages, id: \.id) { message in 
                        messageView(message: message)
                    }
                }
            }
            .padding()
            
            HStack {
                TextField("Enter a message", text: $messageText)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                
                Button {
                    sendMessage()
                } label: {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding()
                        .background(.black)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
    }
    
    func messageView(message: ChatMessage) -> some View {
        HStack {    
            if message.sender == .me {
                Spacer()
            }
            
            Text(message.content)
                .foregroundColor(message.sender == .me ? .white : .white)
                .padding()
                .background(message.sender == .me ? .blue : .gray.opacity(0.1))
                .cornerRadius(15)
            
            if message.sender == .gpt {
                Spacer()
            }
        }
    }
    
    private func sendMessage() {
        print(messageText)
        
        let myMessage = ChatMessage(id: UUID().uuidString, content: messageText, dataCreated: Date(), sender: .me)
        chatMessages.append(myMessage)
        
        openAIService.sendMessage(message: messageText).sink { completion in 
            // Handle error
        } receiveValue: { response in 
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
            let gptMessage = ChatMessage(id: response.id, content: textResponse, dataCreated: Date(), sender: .gpt)
            chatMessages.append(gptMessage)
        }
        .store(in: &cancellables)
        
        messageText = ""
    }
    
}

struct ChatMessage {
    let id: String
    let content: String
    let dataCreated: Date
    let sender: MessageSender
}

enum MessageSender {
    case gpt
    case me
}

extension ChatMessage {
    static let DemoMessages = [
        ChatMessage(id: UUID().uuidString, content: "Demo Sample", dataCreated: Date(), sender: .me), 
        ChatMessage(id: UUID().uuidString, content: "Demo Sample", dataCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Demo Sample", dataCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Demo Sample", dataCreated: Date(), sender: .gpt),
    ]
}
