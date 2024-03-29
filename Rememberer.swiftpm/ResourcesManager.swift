import SwiftUI
import UIKit

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
    
    func refresh() {
        controller.loadData()
    }
}

class ViewController: UIViewController, ObservableObject {
    
    @Published var resources: [Resource] = [Resource.demoResource]
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(red: 226/255, green: 188/255, blue: 207/255, alpha: 1)
        tableView.separatorColor = UIColor(red: 199/255, green: 103/255, blue: 126/255, alpha: 1)
        tableView.layer.cornerRadius = 18
        
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
        resources.append(Resource(title: "New resource"))
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if !resources[indexPath.row].tags.isEmpty { 
            cell.textLabel?.text = resources[indexPath.row].tags[0] + " | "
        } else {
            cell.textLabel?.text = ". default | "
        }
        
        cell.textLabel?.text?.append(resources[indexPath.row].title)
        cell.textLabel?.backgroundColor = UIColor(red: 190/255, green: 212/255, blue: 229/255, alpha: 1)
        cell.textLabel?.textColor? = UIColor.black
        cell.backgroundColor = UIColor(red: 190/255, green: 212/255, blue: 229/255, alpha: 1)
        
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
        self.loadData()
        return config
    }
}

class Resource: ObservableObject, Identifiable {
    
    let id = UUID()
    @Published var title: String
    @Published var content: String = ""
    @Published var tags: [String] = []
    
    init(title: String) {
        self.title = title
    }
    
    func addTag(newTag: String) {
        tags.append(newTag)
    }
}

extension Resource {
    static let demoResource = Resource(title: "New resource")
}
