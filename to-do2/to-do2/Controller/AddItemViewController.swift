//
//  AddItemViewController.swift
//  to-do1
//
//  Created by Hyunju Kim on 3/22/24.
//

import UIKit

protocol AddItemDelegate {
    func addItemDidCancel()
    func addItemDidAdd(item: ChecklistItem, category: TodoList.Category)
    func addItemDidEdit(item: ChecklistItem, destCategory: TodoList.Category, sourceCategory: TodoList.Category)
}


class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var itemTF: UITextField!
    
    weak var itemToEdit: ChecklistItem?
    
    var categoryToEdit: TodoList.Category?
    
    var newCategory : TodoList.Category?
    
    var delegate: AddItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = itemToEdit {
            self.title = "Edit Item"
            itemTF.text = item.text
            newCategory = categoryToEdit!
        }
        
        itemTF.delegate = self
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            removeCheckmark(remove: false)
        }

    private func removeCheckmark(remove: Bool) {
            guard let category = newCategory else {
               return
            }

            let rowInx = category.rawValue + 2
            let indexPath = IndexPath(row: rowInx, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) {
                if remove {
                    cell.imageView?.image = UIImage(systemName: "circle")
                } else {
                    cell.imageView?.image = UIImage(systemName: "checkmark.circle")
                }
            }

        }

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //navigationController?.popViewController(animated: true)
        delegate?.addItemDidCancel()
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if let item = itemToEdit, let text = itemTF.text {
            item.text = text
            delegate?.addItemDidEdit(item: item, destCategory: newCategory!, sourceCategory: categoryToEdit!)
        } else {
            if let itemText = itemTF.text {
                let item = ChecklistItem(text: itemText)
                delegate?.addItemDidAdd(item: item, category: newCategory!)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemTF.endEditing(true)
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { if let cell = tableView.cellForRow(at: indexPath) {
        
        for category in TodoList.Category.allCases {
            newCategory = category
            removeCheckmark(remove: true)
        }
        
        switch cell.tag {
        case 100:
            newCategory = TodoList.Category.daily
        case 101:
            newCategory = TodoList.Category.weekly
        case 102:
            newCategory = TodoList.Category.monthly
        default: 
            newCategory = TodoList.Category.yearly
        }
    }
    }
    
    
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
