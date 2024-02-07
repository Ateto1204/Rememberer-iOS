import SwiftUI
import TipKit

struct ContentView: View {
    
    @State private var showScannerSheet = false
    @State private var texts:[ScanData] = []
    @State private var content: String = ""
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    
    @State private var viewController = ViewControllerRepresentable()
    private let addResourcesTip = AddResourcesTip()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 227/255, green: 211/255, blue: 228/255) // pale purple
                VStack {
                    HStack {
                        Text("My Resources")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                            .bold()
                            .padding(EdgeInsets(top: 30, leading: 30, bottom: 20, trailing: 20))
                        Spacer()
                    }
                    ZStack {
                        viewController
                            .padding()
                            .onAppear(perform: {
                                viewController.refresh()
                            })
                        OperatingButtonView()
                    }
                }
            }
            .ignoresSafeArea()
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
                        .background(Color(red: 162/255, green: 119/255, blue: 238/255)) // tropical indigo
                        .clipShape(Circle())
                        .padding(.trailing, 18)
                        .popoverTip(addResourcesTip, arrowEdge: .trailing)
                        .padding()
                }
                .padding(.bottom, 18)
            }
        }
    }
}

struct AddResourcesTip: Tip {
    var title: Text {
        Text("Press this")
    }
    
    var message: Text? {
        Text("Press to add new resources")
    }
    
    var image: Image? {
        Image(systemName: "doc.badge.plus")
    }
}
