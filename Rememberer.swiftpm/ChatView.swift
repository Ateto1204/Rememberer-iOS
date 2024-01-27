import SwiftUI
import Combine
import TipKit


struct ChatView: View {
    
    @ObservedObject private var viewModel: ViewModel
    @ObservedObject private var networkManager: NetworkManager
    
    @State private var showExplanation: Bool = false
    private let jsonFormat: String = 
"""
[
    {
        "question": "", 
        "options": [
            "", 
            "", 
            "", 
            ""
        ], 
        "answer": "", 
        "explanation": ""
    }
]
"""
    private let Msg: String = "Generate 5 more multiple-choice questions, and do not answer anything else, just the generated questions."
    private let firstMsg: String = "Please parse the above json format first, then use the following article content or related fields to generate 3 multiple-choice questions, and express them in the json format just now. The most important thing is, do not answer any other content except the generated questions: "
    
    @State private var showingHUD: Bool = false
    @State private var isAnimating: Bool = false
    @State private var currentAnswerIsCorrect: Bool = false
    @State private var animateShake: Int = 0
    @State private var quesNo: Int = 0
    
    private let tip = QuestionDetailTip()
    
    init(content: String) {
        let prompt = "\(jsonFormat)\n\n\(firstMsg)\n\n\(content)"
        self.viewModel = ViewModel(initString: prompt)
        self.networkManager = NetworkManager()
    }
    
    var body: some View {
        if networkManager.isNetworkAvailable {
            ZStack (alignment: .bottom) {
                VStack {
                        
                    if viewModel.hasResponse {
                        if !viewModel.response.isEmpty {
                            let decodedQuestions: [Question] = viewModel.response
                            VStack {
                                questionView(questions: decodedQuestions)
                                Spacer()
                                Spacer()
                            }
                        }
                    } else if viewModel.requestCrash {
//                            ContentUnavailableView(description: "Generating Fail", systemImage: "exclamationmark.triangle.fill")
                        ContentUnavailableView("Generating Fail", systemImage: "exclamationmark.triangle.fill")
                    } else {
                        LottieView(loopMode: .loop, source: "Loading")
                            .scaleEffect(0.5)
                    }
                    Spacer()
                }
                .padding(.top, 5)
                .onAppear(perform: {
                    viewModel.sendMessage()
//                    viewModel.updateCurrentInput(input: Msg)
                })
                .refreshable {
                    viewModel.sendMessage()
                }
                
                if showingHUD {
                    HUD {
                        if(self.currentAnswerIsCorrect) {
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
                    .padding(.bottom)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("@Generated by GPT for reference only")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 8)
                            .padding(.trailing, 12)
                    }
                }
            }
        } else {
            VStack {
                ContentUnavailableView("No Internet Connect", systemImage: "wifi.slash")
                Spacer()
            }
        }
    }
    
    func decodeQues(content: String) -> [Question] {
        let data = content.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([Question].self, from: data)
            return decodedData
         } catch {
             print(error)
         }
        
        let null: [Question] = []
        return null
        
    }
    
    func questionView(questions: [Question]) -> some View {
        
        self.quesNo = 0
        
        if questions.count > 0 {
            return ScrollView {
                Group {
                    Text("Question")
                        .bold()
                    Text(questions[quesNo].question)
                    
                    Text("Options")
                        .bold()
                    ForEach(questions[quesNo].options.indices) { idx in 
                        Text(questions[quesNo].options[idx])
                    }
                    
                    Text("Answer")
                        .bold()
                    Text(questions[quesNo].answer)
                    
                    Text("Explanation")
                        .bold()
                    Text(questions[quesNo].explanation)
                }
                .padding()
                
                Button("Next") {
                    if quesNo + 1 < questions.count {
                        self.quesNo += 1
                    } else {
                        self.quesNo = 0
                        viewModel.sendMessage()
                    }
                }
            }
        } else {
            return ContentUnavailableView("Process fail", systemImage: "exclamationmark.triangle.fill")
        }
        
//        let components: [String] = content.components(separatedBy: "Component: ").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
//        
//        guard components.count >= 4 else {
//            print("Retry: \(components.count)")
//            if retry > 8 {
//                print("Resend")
//                return Text("")
//                .onAppear(perform: {
//                    viewModel.sendMessage()
//                })
//            }
//            else { return questionView(content: content, retry: retry + 1)}
//        }
//        
//        let question: String = components[0]        
//        var choices: [String] = components[1].components(separatedBy: .newlines)
//        
//        guard choices.count >= 4 else {
//            if retry > 8 {
//                print("Resend")
//                return Text("")
//                .onAppear(perform: {
//                    viewModel.sendMessage()
//                })
//            }
//            else { return questionView(content: content, retry: retry + 1) }
//        }
//        
//        let ans: String = components[2]
//        let explanation: String = components[3]
//        
//        
//        
//        return VStack(alignment: .leading, spacing: 5) {
//            
//            TipView(tip, arrowEdge: .bottom)
//            
//            Button {
//                showExplanation = true
//                tip.invalidate(reason: .actionPerformed)
//            } label: {
//                HStack {
//                    Spacer()
//                    VStack {
//                        Text("Question")
//                            .font(.title3)
//                            .foregroundColor(.secondary)
//                            .padding(.bottom, 8)
//                        
//                        Text(question)
//                            .fontWeight(.semibold)
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(Color.primary)
//                            .font(.title3)
//                            .transition(.scale)
//                            .lineSpacing(1.5)
//                            .modifier(ShakeEffect(animatableData: CGFloat(animateShake)))
//                            .padding(.leading)
//                    }
//                    .padding(30)
//                    Spacer()
//                }
//                .frame(height: 250)
//                .background(Color(uiColor: .secondarySystemBackground))
//                .cornerRadius(10)
//                .padding()
//            }
//            .sheet(isPresented: $showExplanation, content: {
//                VStack {
//                    Text("Expanation")
//                        .font(.title3)
//                        .foregroundColor(.secondary)
//                        .padding()
//                    Text(ans)
//                        .padding(.leading, 12)
//                        .padding(.trailing, 12)
//                    Text(explanation)
//                        .padding()
//                    Button {
//                        viewModel.sendMessage()
//                    } label: {
//                        Text("Next")
//                    }
//                }
//            })
//            
//            ForEach(choices.indices) { idx in 
//                if idx < choices.count && !choices[idx].isEmpty {
//                    Button {
//                        
//                        if choices[idx].first == ans.first {
//                            self.currentAnswerIsCorrect = true
//                        }
//                        
//                        withAnimation(Animation.timingCurve(0.47, 1.62, 0.45, 0.99, duration: 0.4)) {
//                            showingHUD.toggle()
//                            isAnimating = true
//                        }
//                        
//                        if self.currentAnswerIsCorrect {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + (1.7)) {
//                                viewModel.sendMessage()
//                                withAnimation() {
//                                    showingHUD = false
//                                    isAnimating = false
//                                    self.currentAnswerIsCorrect = false
//                                }
//                            }
//                        } else {
//                            withAnimation(.default) {
//                                animateShake += 1
//                            }
//                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + (2.5)) {
//                                withAnimation() {
//                                    showingHUD = false
//                                    isAnimating = false
//                                    self.currentAnswerIsCorrect = false
//                                }
//                            }
//                        }
//                        
//                    } label: {
//                        HStack {
//                            Text(choices[idx])
//                                .font(.callout)
//                                .foregroundColor(.accentColor)
//                                .padding(EdgeInsets())
//                            Spacer()
//                        }
//                        .padding(12)
//                        .background(Color.accentColor.opacity(0.13))
//                        .cornerRadius(12)
//                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
//                    }
//                    .padding(3)
//                }
//            }
//            
//            Spacer()
//        }
//        .disabled(isAnimating)
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

struct QuestionDetailTip: Tip {
    var title: Text {
        Text("Press the question")
    }
    
    var message: Text? {
        Text("Press the question the see more detail.")
    }
    
    var image: Image? {
        Image(systemName: "quote.bubble")
    }
}
