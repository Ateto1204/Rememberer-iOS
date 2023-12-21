import SwiftUI

struct ContentView: View {
    
    @State private var showScannerSheet = false
    @State private var texts:[ScanData] = []
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Text("Select from")
                    
                    Button {
                        self.showScannerSheet = true
                    } label: {
                        Text("Camera")
                    }
                    .sheet(isPresented: $showScannerSheet, content: {
                        makeScannerView()
                    })
                    
                    Text("or")
                    
                    Button {
                        self.isPickerShowing = true
                    } label: {
                        Text("Photo")
                    }
                    .sheet(isPresented: $isPickerShowing, content: {
                        photoScanner()
                    })
                }
                .padding()
                
                Spacer()
                
                if texts.count > 0 {
                    List {
                        ForEach(texts) { text in 
                            NavigationLink {
                                ResultView(content: text.content)
                                    .navigationTitle(text.content)
                            } label: {
                                Text(text.content).lineLimit(3)
                            }
                        }
                    }
                } else {
                    Text("No scan yet")
                        .font(.title)
                }
                
                Spacer()
                
            }
            .navigationTitle("Rememberer")
            
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
