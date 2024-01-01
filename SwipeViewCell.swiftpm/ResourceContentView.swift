import SwiftUI

struct ResourceContentView: View {
    
    @State var resource: Resource
    @State private var isAddingTag: Bool = false
    @State private var newTag: String = ""
    @State private var isAlert: Bool = false
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Tags: ")
                    .padding()
                
                if resource.tags.count > 0 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(resource.tags, id: \.self) { tag in 
                                Text(tag)
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
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
            
            
            
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    Text(resource.content)
                        .padding()
                }
                .padding(.top, 12)
                
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
        }
        .navigationBarTitle(resource.title)
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
}
