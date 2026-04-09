import UIKit

class ViewController: UIViewController {
  
    @IBOutlet weak var textField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? TaskListViewController {

            if let text = textField.text {
                destination.newTask = text
            }
        }
    }
}
