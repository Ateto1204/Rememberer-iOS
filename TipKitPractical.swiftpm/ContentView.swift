import SwiftUI
import TipKit

struct ContentView: View {
    
    var tip = InlineTip()
    
    var body: some View {
        VStack {
            Text("Hello, world!")
            
            TipView(tip, arrowEdge: .top)
                .padding()
        }
    }
}
