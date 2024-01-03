import SwiftUI
import TipKit

@main
struct Rememberer: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        try? Tips.configure([
            .displayFrequency(.immediate), 
            .datastoreLocation(.applicationDefault)
        ])
    }
}
