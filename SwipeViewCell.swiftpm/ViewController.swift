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
    
    var resources: [Resource] = [Resource.demoResource]
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Adding tableView to AppView
        view.addSubview(tableView)
        
        // Setting tableView with Auto Layout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), 
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor), 
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor), 
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), 
        ])
    }
    
    func loadData() {
        tableView.reloadData()
    }
    
    func addResource() {
        resources.append(Resource.demoResource)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = resources[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationView = ResourceContentView(resource: resources[indexPath.row])
        
        let hostingController = UIHostingController(rootView: destinationView)
        navigationController?.pushViewController(hostingController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {_, _, completion in 
            self.resources.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}

struct Resource: Identifiable {
    let id = UUID()
    var title: String
    var content: String = ""
    var tags: [String] = []
    
    init(title: String) {
        self.title = title
    }
    
    mutating func addTag(newTag: String) {
        tags.append(newTag)
    }
}

extension Resource {
    static let demoResource = Resource(title: "New resource")
}
