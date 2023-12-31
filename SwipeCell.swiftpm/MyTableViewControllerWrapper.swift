import SwiftUI

struct myTableViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> myTableViewController {
        return myTableViewController()
    }
    
    func updateUIViewController(_ uiViewController: myTableViewController, context: Context) {
        uiViewController.loadData()
    }
}
