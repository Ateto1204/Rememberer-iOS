import SwiftUI


extension ContentView {
    class SourceManager: ObservableObject, Identifiable {
        @Published var sources: [Source] = []
        
        func addSource() {
            sources.append(Source.demoSource)
        }
    }
}

class Source: ObservableObject, Identifiable {
    let id = UUID()
    var title: String
    var content: String = ""
    @Published var tags: [String] = []
    
    init(title: String) {
        self.title = title
    }
    
    func addTag(newTag: String) {
        tags.append(newTag)
    }
}

extension Source {
    static let demoSource = Source(title: "New resource")
}
