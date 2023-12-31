import SwiftUI
import SwipeCellKit
import UIKit

class myTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let cellIdentifier = "MyCustomCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(myCustomCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! myCustomCell
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
    
}

class myCustomCell: SwipeTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configureCell(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
