import SwiftUI

struct ContentView: View {
    @State private var name: String = ""
    
    var body: some View {
        VStack (spacing: 25) {
            Text(name)
                .onAppear(perform: loadData)
            Button {
                loadData()
            } label: {
                Text("Display")
            }
        }
    }
    
    func loadData() {
        guard let url = URL(string: "https://cold-brook-9024.fly.dev/randname") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                if let name = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.name = name
                    }
                }
            }
        }.resume()
    }
}
