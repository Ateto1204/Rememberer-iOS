import SwiftUI

struct ContentView: View {
    
//    @State var content: String = "Question: \nWhat is AI?\n\nChoices: \nA) A integer\nB) Artificial Intellegence\nC)Artificial Integer\nD) nope\n\nAnswer: \nB) Artificial intellegence\n\nExplanation: \nNo reason"
    @State var content: String = "In addition, the format of the choice question must follow this:\nComponent: \n(the question)\nComponent: \n(the choices)\nComponent: \n(the answer)\nComponent: \n    (the explanation)"
    @State var question = ""
    @State var choices: [String] = []
    @State var ans = ""
    @State var explain = ""
    
    var body: some View {
        ScrollView {
            let components: [String] = content.components(separatedBy: "Component: ")
            ForEach(components.indices) { data in 
                Text(components[data])
            }
        }
    }
    
//    func parseContent() -> some View {
//        
////        guard let contentString = content as? String else { return }
//        
////        let components: [String] = contentString.components(separatedBy: ["Question: ", " Choices: ", " Answer: ", " Explanation: "])
//        let components: [String] = content.components(separatedBy: .newlines)
//        VStack {
//            ForEach(components.indices) { data in 
//                Text("")
//            }
//        }
//    }
}
