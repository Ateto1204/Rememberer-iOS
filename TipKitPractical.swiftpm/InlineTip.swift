import SwiftUI
import TipKit


struct InlineTip: Tip {
    var title: Text {
        Text("This is a TipKit")
    }
    
    var message: Text? {
        Text("message.")
    }
    
    var image: Image? {
        Image(systemName: "globe")
    }
}
