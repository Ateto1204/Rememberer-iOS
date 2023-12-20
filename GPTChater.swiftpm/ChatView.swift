// 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

import SwiftUI
import Combine

struct ChatView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    let openAIService = OpenAIService()
    @State var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in 
                        messageView(message: message)
                    }
                }
            }
            .padding()
            
            HStack {
                TextField("Enter a message", text: $viewModel.currentInput)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                
                Button {
                    viewModel.sendMessage()
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
    
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user { Spacer() }
            
            Text(message.content)
                .foregroundColor(.white)
                .padding()
                .background(message.role == .user ? .blue : .gray.opacity(0.2))
                .cornerRadius(15)
            
            if message.role == .assistant { Spacer() }
        }
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
