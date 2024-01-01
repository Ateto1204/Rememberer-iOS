import SwiftUI

struct ContentView: View {
    
    @ObservedObject var sourceManager: SourceManager
    
    init() {
        self.sourceManager = SourceManager()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if sourceManager.sources.count > 0 {
                    displaySources()
                }
                OperatingButtonView()
            }
            .navigationBarTitle("My Resource")
        }
    }
    
    func OperatingButtonView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    sourceManager.addSource()
                } label: {
                    Text("+")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .padding(.trailing, 18)
                }
            }
            .padding(.bottom, 18)
        }
    }
    
    func displaySources() -> some View {
        List {
            VStack {
                ForEach(sourceManager.sources) { item in 
                    NavigationLink {
                        SourceContentView(source: item)
                    } label: {
                        Text(item.title)
                            .padding()
                    }
                }
            }
        }
    }
}
