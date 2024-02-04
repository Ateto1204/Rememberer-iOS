import SwiftUI

struct ContentView: View {
    
    @State var showingHUD: Bool = false
    @State var isAnimating: Bool = false
    @State var currentAnswerIsCorrect: Bool = false
    @State var currentAnswerIsWrong: Bool = false
    
    @State var animateShake: Int = 0
    
    var body: some View {
        VStack(spacing: 25) {
            
            Text("Question")
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.primary)
                .font(.title3)
                .transition(.scale)
                .modifier(ShakeEffect(animatableData: CGFloat(animateShake)))
                .frame(height: 250)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
            
            HStack {
                Button {
                    
                    currentAnswerIsCorrect = true
                    
                    withAnimation(Animation.timingCurve(0.47, 1.62, 0.45, 0.99, duration: 0.4)) {
                        showingHUD.toggle()
                        isAnimating = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + (1.7)) {
                        withAnimation() {
                            showingHUD = false
                            isAnimating = false
                        }
                    }
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("Correct")
                            .foregroundColor(.accentColor)
                            .font(.callout)
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.accentColor.opacity(0.13))
                    .cornerRadius(10)
                }
                .padding(3)
                
                Button {
                    
                    currentAnswerIsCorrect = false
                    
                    withAnimation(Animation.timingCurve(0.47, 1.62, 0.45, 0.99, duration: 0.4)) {
                        showingHUD.toggle()
                        isAnimating = true
                    }
                    
                    withAnimation(.default) {
                        animateShake += 1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + (1.7)) {
                        withAnimation() {
                            showingHUD = false
                            isAnimating = false
                        }
                    }
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("Wrong")
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.accentColor)
                            .font(.callout)
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.accentColor.opacity(0.13))
                    .cornerRadius(10)
                }
                .padding(3)
            }
            .disabled(isAnimating)
            .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity))
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
