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
            VStack {
                HStack {
                    Text("My Resources")
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
                        .popoverTip(addResourcesTip, arrowEdge: .trailing)
                        .padding()
                }
                .padding(.bottom, 18)
            }
        }
    }
    
    private func makeScannerView() -> ScannerView {
        ScannerView(completion: { textPerPage in 
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: outputText)
                self.texts.append(newScanData)
            }
            self.showScannerSheet = false
        })
    }
    
    private func photoScanner() -> ImagePicker {
        ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, completion: { image in
            if let outputText = image?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: outputText)
                self.texts.append(newScanData)
            }
            self.isPickerShowing = false
        })
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
