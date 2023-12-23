import SwiftUI
import Combine

struct ChatView: View {
    
    @ObservedObject var viewModel: ViewModel
    @State private var firstToSend: Bool = true
    @State private var hasGetAnswer: Bool = false
    @State private var hasGetReason: Bool = false
    @State private var tmp: String = "default"
    
    let asking: String = "Generate one more multiple choice questions"
    let format: String = "In addition, the format of the question must completely follow this that do not has additional lines or words ans must include the keyword \"Component:\":\nComponent: (the question)\nComponent: (the choices)\nComponent: (the answer)\nComponent: (the explanation)"
    let getAnswer: String = "Tell me the answer that only include the capital A, B, C or D"
    let reasonOfAnswer: String = "Why?"
    
    init(content: String) {
        let prompt = "\(asking) based on the following: \n \(content)\n\(format)"
        self.viewModel = ViewModel(initString: prompt)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    Text(viewModel.response)
                        .foregroundColor(.white)
                        .padding()
                        .background(.blue)
                    
                    if viewModel.hasResponse {
                        questionView(content: viewModel.response)
                    } else {
                        Text("Generating...")
                            .foregroundColor(.white)
                            .padding()
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
    
    func questionView(content: String) -> some View {
        
        let components: [String] = content.components(separatedBy: "Component: ").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        guard components.count >= 4 else {
            print("Retry")
            return questionView(content: content)
        }
        
        let question: String = components[0]
        let choices: [String] = components[1].components(separatedBy: .newlines)
        let ans: String = components[2]
        let explanation: String = components[3]
        
        return VStack(alignment: .leading) {

            Text(question)
            
            ForEach(choices.indices) { idx in 
                if !choices[idx].isEmpty {
                    Button {
                        
                    } label: {
                        Text(choices[idx])
                            .foregroundColor(.white)
                            .padding()
                            .background(.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
            }

        }
    }
    
}
