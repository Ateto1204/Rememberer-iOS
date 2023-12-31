import SwiftUI
import SwipeCellKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                myTableViewControllerWrapper()
            }
            .navigationBarTitle("My List")
        }
    }
}
