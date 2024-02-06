import SwiftUI

struct ResourceContentView: View {
    
    @ObservedObject var resource: Resource
    @State private var isAddingTag: Bool = false
    @State private var newTag: String = ""
    @State private var newTitle: String = ""
    @State private var isAlert: Bool = false
    @State private var modifyingTitle: Bool = false
    @State private var modifyingContent: Bool = false
    
    @State private var showScannerSheet = false
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
            
            VStack {
                
                // Display resource title
                HStack(alignment: .top) {
                    
                    Text(resource.title)
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                    
                    Button {
                        self.modifyingTitle = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                    }
                    .sheet(isPresented: $modifyingTitle, content: {
                        TitleModifyingView()
                    })
                    
                    Spacer()
                }
                .padding(.top, 56)
                .padding(.leading, 25)
                
                // Display tagsView
                HStack {
                    Text("Tags: ")
                        .foregroundColor(.black)
                        .padding()
                    
                    if resource.tags.count > 0 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(resource.tags, id: \.self) { tag in 
                                    HStack {
                                        
                                        Button {
                                            if let target = resource.tags.firstIndex(of: tag) {
                                                resource.tags.remove(at: target)
                                            }
                                        } label: {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 11, height: 11)
                                                .foregroundColor(.white)
                                                .padding(.leading, 9)
                                        }
                                        
                                        Text(tag)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 8))
                                    }
                                    .background(Color.secondary)
                                    .cornerRadius(6)
                                    .shadow(radius: 10)
                                }
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("none")
                                .foregroundColor(.gray)
                                .padding()
                            Spacer()
                        }
                    }
                    
                    Button {
                        self.isAddingTag = true
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                    }
                    .sheet(isPresented: $isAddingTag, content: {
                        tagAddingView()
                    })
                }
                .padding()
                
                Spacer()
                
                ZStack(alignment: .bottom) {
                    
                    // Display content of the resource
                    resourceContentView()
                    
                    // Submit the content of the resource to GPT
                    NavigationLink {
                        ChatView(content: resource.content)
                    } label: {
                        Text("Start")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.accentColor.opacity(0.83))
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 28)
                    
                }
                .padding(.bottom, 25)
            }
        }
        .ignoresSafeArea()
    }
    
    func tagAddingView() -> some View {
        ZStack {
            Color.white
            VStack {
                Text("Add a new tag")
                    .foregroundColor(.black)
                HStack {
                    TextField("New tag", text: $newTag)
                        .placeholder(when: newTag.isEmpty) {
                            Text("New tag")
                                .foregroundColor(.gray)
                        }
                    Button {
                        if !newTag.isEmpty {
                            resource.addTag(newTag: newTag)
                            newTag = ""
                            isAddingTag = false
                        } else {
                            isAlert = true
                        }
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                            .padding(.trailing, 12)
                    }
                    .alert("Your input is empty", isPresented: $isAlert) {
                        Button("OK") {
                            isAlert = false
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    func resourceContentView() -> some View {
        VStack {
            HStack(spacing: 15) {
                Spacer()
                
                Button {
                    showScannerSheet = true
                } label: {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 22, height: 22)
                }
                .sheet(isPresented: $showScannerSheet, content: {
                    makeScannerView()
                })
                
                Button {
                    isPickerShowing = true
                } label: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                }
                .sheet(isPresented: $isPickerShowing, content: {
                    photoScanner()
                })
                
                Button {
                    modifyingContent = true
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 25, height: 25)
                }
                .sheet(isPresented: $modifyingContent, content: {
                    Text("Developing...")
                })
                
            }
            .padding(.trailing, 18)
            
            if !resource.content.isEmpty {
                ScrollView {
                    HStack {
                        Text(resource.content)
                            .foregroundColor(.black)
                            .padding()
                    }
                    .padding()
                }
                .padding()
            } else {
                VStack {
                    Spacer()
                    LottieView(loopMode: .loop, source: "UFOAnimation")
                        .opacity(0.6)
                        .scaleEffect(0.55)
                        .frame(height: 55)
                    Text("Waiting to edit them...")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .opacity(0.9)
                    Spacer()
                }
            }
        }
        .padding()
        .border(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
    
    func TitleModifyingView() -> some View {
        ZStack {
            Color.white
            VStack(alignment: .center, spacing: 25) {
                Text("Enter your new title")
                    .foregroundColor(.black)
                TextField(resource.title, text: $newTitle)
                    .foregroundColor(.black)
                    .placeholder(when: newTitle.isEmpty) {
                        Text(resource.title)
                            .foregroundColor(.gray)
                    }
                    .padding()
                Button {
                    if !newTitle.isEmpty {
                        resource.title = newTitle
                        newTitle = ""
                        modifyingTitle = false
                    } else {
                        isAlert = true
                    }
                } label: {
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 12)
                }
                .alert("Your input is empty", isPresented: $isAlert) {
                    Button("OK") {
                        isAlert = false
                    }
                }
            }
        }
    }
    
    private func makeScannerView() -> ScannerView {
        ScannerView(completion: { textPerPage in 
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: outputText)
                self.resource.content.append(outputText)
            }
            self.showScannerSheet = false
        })
    }
    
    private func photoScanner() -> ImagePicker {
        ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, completion: { image in
            if let outputText = image?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: outputText)
                self.resource.content.append(outputText)
            }
            self.isPickerShowing = false
        })
    }
    
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool, 
        alignment: Alignment = .leading, 
        @ViewBuilder placeholder: () -> Content) -> some View {
            
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
