import SwiftUI

struct ContentView: View {
    
    @State private var viewController = ViewControllerRepresentable()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("My Resources")
                        .font(.largeTitle)
                        .bold()
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                    Spacer()
                }
                ZStack {
                    if  viewController.controller.resources.count > 0 {
                        viewController
                            .padding()
                            .onAppear(perform: {
                                viewController.refresh()
                            })
                    } else {
                        LottieView(loopMode: .loop, name: "Waiting")
                            .opacity(0.68)
                            .scaleEffect(0.5)
                    }
                    OperatingButtonView()
                }
            }
        }
    }
    
    func OperatingButtonView() -> some View {
        VStack {
            Spacer()
            HStack(spacing: 12) {
                Spacer()                
                Button {
                    viewController.addData()
                } label: {
                    Text("+")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .padding(.trailing, 18)
                }
                .padding(.bottom, 18)
            }
        }
    }
}
