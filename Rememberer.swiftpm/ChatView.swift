import SwiftUI
import Combine

struct ChatView: View {
    
    @ObservedObject var viewModel: ViewModel
    @State private var firstToSend: Bool = true
    @State private var hasGetAnswer: Bool = false
    @State private var hasGetReason: Bool = false
    @State private var tmp: String = "default"
    @State static var choiceCount: Int = 0
    
    let asking: String = "Generate one more multiple choice questions"
    let format: String = "In addition, the format of the question must completely follow this that do not has additional lines or words ans must include the keyword \"Component:\":\nComponent: (the question)\nComponent: (the choices)\nComponent: (the answer)\nComponent: (the explanation)"
    let getAnswer: String = "Tell me the answer that only include the capital A, B, C or D"
    let reasonOfAnswer: String = "Why?"
    
    @State var showingHUD: Bool = false
    @State var isAnimating: Bool = false
//    @State var currentAnswerIsCorrect: Bool = false
    @State var animateShake: Int = 0
    
    init(content: String) {
        let prompt = "\(asking) based on the following: \n \(content)\n\(format)"
        self.viewModel = ViewModel(initString: prompt)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
//                    Text(viewModel.response)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(.blue)
                    
                    if viewModel.hasResponse {
                        if !viewModel.response.isEmpty {
                            questionView(content: viewModel.response, retry: 0)
                        } else {
                            Text("The response is empty")
                        }
                    } else {
                        Text("Generating...")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
            .padding()
            
            HStack {
                
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
    
    func questionView(content: String, retry: Int) -> some View {
        
        let components: [String] = content.components(separatedBy: "Component: ").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        guard components.count >= 4 else {
            print("Retry: \(components.count)")
            if retry > 8 {
                return VStack {
                    ForEach(components.indices) { idx in 
                        Text(components[idx])
                            .foregroundColor(.white)
                            .padding()
                            .background(.gray)
                    }
                }
            }
            else { return questionView(content: content, retry: retry + 1)}
        }
        
        let question: String = components[0]        
        var choices: [String] = components[1].components(separatedBy: .newlines)
        
        guard choices.count >= 4 else {
            if retry > 8 {
                return VStack {
                    ForEach(choices.indices) { idx in 
                        Text(choices[idx])
                            .foregroundColor(.white)
                            .padding()
                            .background(.yellow)
                    }
                }
            }
            else { return questionView(content: content, retry: retry + 1) }
        }
        
        let ans: String = components[2]
        let explanation: String = components[3]
        
        
        return VStack(alignment: .leading) {
            var currentAnswerIsCorrect = false
            
            Text(question)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.primary)
                .font(.title3)
                .padding()
                .transition(.scale)
                .modifier(ShakeEffect(animatableData: CGFloat(animateShake)))
                .frame(height: 250)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
            
            ForEach(choices.indices) { idx in 
                if !choices[idx].isEmpty {
                    Button {
                        
                        if choices[idx].first == ans.first {
                            currentAnswerIsCorrect = true
                        }
                        
                        withAnimation(Animation.timingCurve(0.47, 1.62, 0.45, 0.99, duration: 0.4)) {
                            showingHUD.toggle()
                            isAnimating = true
                        }
                        
                        if currentAnswerIsCorrect {
                            DispatchQueue.main.asyncAfter(deadline: .now() + (1.7)) {
                                viewModel.sendMessage()
                                withAnimation() {
                                    showingHUD = false
                                    isAnimating = false
                                    currentAnswerIsCorrect = false
                                }
                            }
                        } else {
                            withAnimation(.default) {
                                animateShake += 1
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + (2.5)) {
                                withAnimation() {
                                    showingHUD = false
                                    isAnimating = false
                                    currentAnswerIsCorrect = false
                                }
                            }
                        }
                        
                    } label: {
                        Text(choices[idx])
                            .foregroundColor(.white)
                            .padding()
                            .background(.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
            }
            
            
            if showingHUD {
                HUD {
                    if(currentAnswerIsCorrect) {
                        HStack(spacing: 25) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("That's correct")
                                    .padding(.leading, 5)
                                    .foregroundColor(Color.primary)
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("That's wrong, try again")
                                .padding(.leading, 5)
                        }
                    }
                }
                .zIndex(1)
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .disabled(isAnimating)
    }
    
}

struct HUD<Content: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @ViewBuilder let content: Content
    
    var body: some View {
        content
            .padding(.horizontal, 12)
            .padding(16)
            .background(
                Capsule()
                    .foregroundColor(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground))
                    .shadow(color: Color(.black).opacity(0.15), radius: 10, x: 0, y: 4)
            )
            .padding(20)
    }
}

struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 10 * sin(animatableData * .pi * CGFloat(3)), y: 0))
    }
}
