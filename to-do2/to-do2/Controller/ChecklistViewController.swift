//
//  ViewController.swift
//  to-do1
//
//  Created by Hyunju Kim on 3/20/24.
//

import UIKit

extension UIView {
    func takeScreenshot() -> UIImage {
             // Begin context
          UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
             // Draw view in that context
             drawHierarchy(in: self.bounds, afterScreenUpdates: true)
             // And finally, get image
         let image = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()

             if (image != nil) {
                 return image!
             }
             return UIImage()
         }
}

class ChecklistViewController: UITableViewController, AddItemDelegate {
    
    func addItemDidCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemDidAdd(item: ChecklistItem, category: TodoList.Category) {
        let rowIndex = todoList.getTodoList(category: category).count
        todoList.addTodo(item: item, category: category)

        switch category {
        case .daily:
            let indexPath = IndexPath(row: rowIndex, section: TodoList.Category.daily.rawValue)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
        case .weekly:
            let indexPath = IndexPath(row: rowIndex, section: TodoList.Category.weekly.rawValue)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
        case .monthly:
            let indexPath = IndexPath(row: rowIndex, section: TodoList.Category.monthly.rawValue)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
        default:
            let indexPath = IndexPath(row: rowIndex, section: TodoList.Category.yearly.rawValue)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func addItemDidEdit(item: ChecklistItem, destCategory: TodoList.Category, sourceCategory: TodoList.Category) {
        
        for category in TodoList.Category.allCases {
            let items = todoList.getTodoList(category: category)
            if let rowIndex = items.firstIndex(of: item) {
                let indexPath = IndexPath(row: rowIndex, section: category.rawValue)
                let rowToDelete = indexPath.row > items.count - 1 ? items.count - 1 : indexPath.row
                todoList.remove(item: item, category: category, index: rowToDelete)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if let cell = tableView.cellForRow(at: indexPath) {
                    setLabel(cell: cell, item: item)
                }
            }
        }
        addItemDidAdd(item: item, category: destCategory)
    }
    
    var todoList = TodoList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.allowsMultipleSelectionDuringEditing = true

        todoList = loadData()

        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Category.allCases.count
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddItemVC" {
            let destinationVC = segue.destination as! AddItemViewController
            destinationVC.delegate = self
        } else if segue.identifier == "toImageView" {
            let destinationVC = segue.destination as! ImageViewController
            guard let tableView = self.tableView else {
                 print("TableView not initialized")
                 return
             }
            let screenshot = tableView.takeScreenshot()
            destinationVC.desiredImage = screenshot
            
        } else if segue.identifier == "toEditAddItemVC" {
            let destinationVC = segue.destination as! AddItemViewController
            
            if let cell = sender as? UITableViewCell,
               let indexPath = tableView.indexPath(for: cell),
               let category = categoryForSectionIndex(indexPath.section) {
                let item = todoList.getTodoList(category: category)[indexPath.row]
                destinationVC.categoryToEdit = category
                destinationVC.itemToEdit = item
                destinationVC.delegate = self
            }
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
    }
    
    // MARK: IBAction funcs
//    @IBAction func addItem(_ sender: UIBarButtonItem) {
//        let rowIndex = todoList.todos.count
//        _ = todoList.addTodo(text: "New todo", checked: true)
//
//        let indexPath = IndexPath(row: rowIndex, section: 0)
//
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
//    }

    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let category = categoryForSectionIndex(indexPath.section) {
                    let todos = todoList.getTodoList(category: category)
                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    let item = todos[rowToDelete]
                    todoList.remove(item: item, category: category, index: rowToDelete)
                }
            }
            //Updates information in the view
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    @objc func saveData() {
            do {
                let listData = try JSONEncoder().encode(todoList)
                UserDefaults.standard.set(listData, forKey: "todos")
                print("saved")
            } catch {
                print(error.localizedDescription)
            }
        }

        func loadData() -> TodoList {
            if let listData = UserDefaults.standard.data(forKey: "todos") {
                do {
                    let lists = try JSONDecoder().decode(TodoList.self, from: listData)
                    return lists
                } catch {
                    print(error.localizedDescription)
                }
            }
            return TodoList()
        }
    
    
    // MARK: tableView funcs
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //todoList.move(item: todoList.todos[sourceIndexPath.row], toIndex: destinationIndexPath.row)
        
        if let sourceCategory = categoryForSectionIndex(sourceIndexPath.section), let destinationCategory = categoryForSectionIndex(destinationIndexPath.section) {
            let item = todoList.getTodoList(category: sourceCategory)[sourceIndexPath.row]
            todoList.move(item: item, sourceCategory: sourceCategory, sourceIndex: sourceIndexPath.row, destinationCategory: destinationCategory, destinationIndex: destinationIndexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title: String? = nil
        if let category = categoryForSectionIndex(section) {
            switch category {
            case .daily:
                title = "Daily"
            case .weekly:
                title = "Weekly"
            case .monthly:
                title = "Monthly"
            case .yearly:
                title = "Yearly"
            }
        }
        return title
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let category = categoryForSectionIndex(indexPath.section) {
            _ = todoList.getTodoList(category: category)[indexPath.row]
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let category = categoryForSectionIndex(section) {
            let list = todoList.getTodoList(category: category)
            return list.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        //let item = todoList.todos[indexPath.row]
       
        if let category = categoryForSectionIndex(indexPath.section) {
            let list = todoList.getTodoList(category: category)
            let item = list[indexPath.row]
            setLabel(cell: cell, item: item)
            setCheckmark(cell: cell, item: item)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            return
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if let category = categoryForSectionIndex(indexPath.section) {
                let list = todoList.getTodoList(category: category)
                let item = list[indexPath.row]
                
                item.toggleChecked()
                setCheckmark(cell: cell, item: item)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: Other funcs
    
    func setCheckmark(cell: UITableViewCell, item: ChecklistItem) {
        
        guard let tvCell = cell as? ChecklistTableViewCell else {
            return
        }
        
        if item.checked {
            tvCell.checkmarkLabel.text = "✓"
        } else {
            tvCell.checkmarkLabel.text = ""
        }
    }
    
    func setLabel(cell: UITableViewCell, item: ChecklistItem) {
        guard let tvCell = cell as? ChecklistTableViewCell else {
            return
        }
        
        tvCell.todoTextLabel.text = item.text
    }
    
    private func categoryForSectionIndex(_ index: Int) ->
        TodoList.Category? {
            return TodoList.Category(rawValue: index)
        }
    
    private func sectionIndexForCategory(category: TodoList.Category) -> Int {
        var index = -1
        for cat in TodoList.Category.allCases {
            if cat == category {
                index = cat.rawValue
            }
        }
        return index
    }
}

