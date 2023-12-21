import SwiftUI
import Combine

struct ChatView: View {
    
    @ObservedObject var viewModel: ViewModel
    @State private var firstToSend: Bool = true
    @State private var hasGetAnswer: Bool = false
    @State private var hasGetReason: Bool = false
    
    let asking: String = "Generate one more multiple choice questions"
    let format: String = "In addition, the format of the choice question must follow this:\nComponent: \n(the question)\nComponent: \n(the choices)\nComponent: \n(the answer)\nComponent: \n    (the explanation)"
    let getAnswer: String = "Give me only the choice of the answer (A, B, C or D)"
    let reasonOfAnswer: String = "Why?"
    
    init(content: String) {
        let prompt = "\(asking) based on the following: \n \(content)\n\(format)"
        self.viewModel = ViewModel(initString: prompt)
    }
    
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
                
                if !firstToSend && !hasGetReason {
                    Button {
                        viewModel.updateCurrentInput(input: hasGetAnswer ? reasonOfAnswer : getAnswer)
                        if hasGetAnswer { self.hasGetReason = true }
                        if !hasGetAnswer { self.hasGetAnswer = true }
                        viewModel.sendMessage()
                    } label: {
                        Text(hasGetAnswer ? "Why" : "Get Answer")
                            .foregroundColor(.white)
                            .padding()
                            .background(.black)
                            .cornerRadius(12)
                    }
                }
                
                Button {
                    if firstToSend { self.firstToSend = false }
                    else { viewModel.updateCurrentInput(input: asking) }
                    viewModel.sendMessage()
                    self.hasGetAnswer = false
                    self.hasGetReason = false
                } label: {
                    Text(firstToSend ? "Start" : "Next")
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
