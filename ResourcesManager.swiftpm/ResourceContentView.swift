import SwiftUI

struct ResourceContentView: View {
    
    @ObservedObject var resource: Resource
    @State private var isAddingTag: Bool = false
    @State private var newTag: String = ""
    @State private var newTitle: String = ""
    @State private var isAlert: Bool = false
    @State private var modifyingTitle: Bool = false
    @State private var modifyingContent: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                
                // Display resource title
                HStack(alignment: .top) {
                    
                    Text(resource.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Button {
                        self.modifyingTitle = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                    }
                    .sheet(isPresented: $modifyingTitle, content: {
                        TitleModifyingView()
                    })
                    
                    Spacer()
                }
                .padding()
                
                // Display tagsView
                HStack {
                    Text("Tags: ")
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
                    VStack {
                        resourceContentView()
                        Spacer()
                    }
                    
                    // Submit the content of the resourc to GPT
                    Button {
                        
                    } label: {
                        Text("Start")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.accentColor.opacity(0.83))
                            .cornerRadius(12)
                    }
                    .padding()
                    
                }
                
                Spacer()
            }
        }
    }
    
    func tagAddingView() -> some View {
        VStack {
            Text("Add a new tag")
            HStack {
                TextField("New tag", text: $newTag)
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
                        .foregroundColor(.secondary)
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
    
    func resourceContentView() -> some View {
        VStack {
            HStack(spacing: 15) {
                Spacer()
                
                Button {
                    modifyingContent = true
                } label: {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 22, height: 22)
                }
                
                Button {
                    modifyingContent = true
                } label: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                }
                
                Button {
                    modifyingContent = true
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 25, height: 25)
                }
                
            }
            .padding(.trailing, 18)
            .sheet(isPresented: $modifyingContent, content: {
                Text("demo")
            })
            
            if !resource.content.isEmpty {
                ScrollView {
                    Text(resource.content)
                        .padding()
                }
            } else {
                ZStack {
//                    Spacer()
                    LottieView(loopMode: .loop, name: "UFOAnimation")
                        .opacity(0.8)
                        .scaleEffect(0.55)
                        .padding(.bottom, 100)
                    Text("Waiting to edit them...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 70)
//                    Spacer()
                }
            }
        }
        .padding()
    }
    
    func TitleModifyingView() -> some View {
        VStack(alignment: .center, spacing: 25) {
            Text("Enter your new title")
            TextField(resource.title, text: $newTitle)
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
