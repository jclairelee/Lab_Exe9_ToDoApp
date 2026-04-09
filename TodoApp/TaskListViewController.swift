import UIKit

class TaskListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var tasks: [String] = ["Test Task 1", "Test Task 2"]
    var newTask: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        if let task = newTask {
               tasks.append(task)
           }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)

        cell.textLabel?.text = tasks[indexPath.row]

        return cell
    }
}
