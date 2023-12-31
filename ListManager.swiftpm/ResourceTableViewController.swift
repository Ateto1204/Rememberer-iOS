import SwipeCellKit
import UIKit

class ResourceTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let cellIdentifier = "MyCustomCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ResourceCustomCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func loadData() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResourceCustomCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in 
        }
        
        deleteAction.image = UIImage(systemName: "star")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        options.buttonSpacing = 10
        
        return options
    }
}

class ResourceCustomCell: SwipeTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configureCell(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
