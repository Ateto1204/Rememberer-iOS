import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            LottieView(loopMode: .loop)
//                .opacity(0.68)
                .scaleEffect(0.5)
        }
    }
}
