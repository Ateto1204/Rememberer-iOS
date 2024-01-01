import SwiftUI

struct ContentView: View {
    
    @State private var viewController = ViewControllerRepresentable()
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    viewController
                        .padding()
                    OperatingButtonView()
                }
                .navigationBarTitle("My Resources")
            }
        }
    }
    
    func OperatingButtonView() -> some View {
        VStack {
            Spacer()
            HStack {
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
