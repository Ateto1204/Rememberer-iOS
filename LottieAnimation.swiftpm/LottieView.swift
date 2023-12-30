import SwiftUI
import Lottie

// package import source: https://github.com/airbnb/lottie-ios.git
// json source: https://app.lottiefiles.com

struct LottieView: UIViewRepresentable {
    let loopMode: LottieLoopMode
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: "Loading")
        animationView.play()
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
}
