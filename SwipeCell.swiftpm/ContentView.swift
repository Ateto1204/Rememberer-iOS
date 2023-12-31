import SwiftUI
import SwipeCellKit

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    myTableViewControllerWrapper()
                }
                .navigationBarTitle("My List")
                
                OperatingButtonView()
            }
        }
    }
    
    func OperatingButtonView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Text("+")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .padding(.trailing, 18)
                }
            }
            .padding(.bottom, 18)
        }
    }
}
