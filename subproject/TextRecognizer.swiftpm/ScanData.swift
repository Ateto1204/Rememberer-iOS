import SwiftUI
import Foundation

struct ScanData: Identifiable {
    var id = UUID()
    let content: String
    
    init(content: String) {
        self.content = content
    }
}
