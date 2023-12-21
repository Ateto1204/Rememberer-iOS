import SwiftUI

struct ResultView: View {
    
    let content: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(content)
                    .padding()
                NavigationLink {
                    ChatView(content: content)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 75, height: 50)
                        Text("Submit")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
