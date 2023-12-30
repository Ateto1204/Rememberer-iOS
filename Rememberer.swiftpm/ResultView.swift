import SwiftUI

struct ResultView: View {
    
    let content: String
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    Spacer()
                        .frame(height: 0)
                    Text(content)
                        .padding()
                }
                
                NavigationLink {
                    ChatView(content: content)
                } label: {
                    Text("Start")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor.opacity(0.83))
                        .cornerRadius(12)
                }
                .padding()
            }
        }
    }
}
