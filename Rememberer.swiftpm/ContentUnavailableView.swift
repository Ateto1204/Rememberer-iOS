//import SwiftUI
//
//
//struct ContentUnavailableView: View {
//    
//    let unavailableStatus: UnavailableStatus
//    
//    var body: some View {
//        ZStack {
//            switch unavailableStatus {
//            case .net: 
//                ErrorView(content: "No Internet Connect", image: "wifi.slash")
//            case .gen: 
//                ErrorView(content: "Generating Fail", image: "exclamationmark.triangle.fill")
//            case .loading: 
//                ErrorView(content: "", image: "Generating...")
//            }
//        }
//    }
//}
//
//struct ErrorView: View {
//    
//    let content: String
//    let image: String
//    
//    var body: some View {
//        VStack(spacing: 25) {
//            Image(systemName: image)
//            Text(content)
//        }
//    }
//}
//
//enum UnavailableStatus {
//    case net
//    case gen
//    case loading
//}
