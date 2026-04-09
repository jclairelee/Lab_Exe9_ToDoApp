import UIKit
import CoreData

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks: [String] = []
    var newTask: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        if let task = newTask, !task.isEmpty {

            let newTaskItem = Task(context: context)
            newTaskItem.title = task

            do {
                try context.save()
            } catch {
                print("Error saving")
            }
        }

        fetchTasks()
    }

    func fetchTasks() {

        do {
            let items = try context.fetch(Task.fetchRequest())

            tasks = items.map { $0.title ?? "" }

            tableView.reloadData()

        } catch {
            print("Error fetching")
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
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in

            // Delete from Core Data
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

            do {
                let items = try self.context.fetch(fetchRequest)
                let itemToDelete = items[indexPath.row]
                self.context.delete(itemToDelete)
                try self.context.save()
            } catch {
                print("Delete error")
            }

            self.fetchTasks()
            completion(true)
        }
        
        // Edit
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, completion in

            let alert = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)

            alert.addTextField { textField in
                textField.text = self.tasks[indexPath.row]
            }

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in

                if let newText = alert.textFields?.first?.text {

                    let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

                    do {
                        let items = try self.context.fetch(fetchRequest)
                        let item = items[indexPath.row]
                        item.title = newText
                        try self.context.save()
                    } catch {
                        print("Edit error")
                    }

                    self.fetchTasks()
                }
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            self.present(alert, animated: true)

            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
