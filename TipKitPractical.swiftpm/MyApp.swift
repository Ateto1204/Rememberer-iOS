import SwiftUI
import TipKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        try? Tips.configure()
    }
}
