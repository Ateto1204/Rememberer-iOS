import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    
    private var controller = ViewController()
    
    func makeUIViewController(context: Context) -> ViewController {
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
    
    func addData() {
        controller.addResource()
    }
}

class ViewController: UIViewController {
    
    var names = ["David", "Jack", "Jason", "Tony"]
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Adding tableView to AppView
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    func loadData() {
        tableView.reloadData()
    }
    
    func addResource() {
        names.append(ViewController.demoResource)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    static let demoResource = "DEMO"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}
