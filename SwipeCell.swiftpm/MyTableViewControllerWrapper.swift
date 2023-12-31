import SwiftUI

struct myTableViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return myTableViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
