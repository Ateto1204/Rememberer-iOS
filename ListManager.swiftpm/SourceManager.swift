import SwiftUI


extension ContentView {
    class SourceManager: ObservableObject, Identifiable {
        @Published var sources: [Source] = []
        
        func addSource() {
            sources.append(Source.demoSource)
        }
    }
}

struct Source: Identifiable {
    let id = UUID()
    var title: String
    var content: String = ""
    var tags: [String] = []
    
    init(title: String) {
        self.title = title
    }
    
    mutating func addTag(newTag: String) {
        tags.append(newTag)
    }
}

extension Source {
    static let demoSource = Source(title: "New resource")
}
