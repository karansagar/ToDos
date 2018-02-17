//
//  ViewController.swift
//  ToDoe
//
//  Created by Karan Sagar on 16/02/18.
//  Copyright © 2018 Karan Sagar. All rights reserved.
//

import UIKit

// 1 Added UITableViewController
class ToDoListViewController: UITableViewController {
    
    // 2. Brand new item array in this array some hardcorded items on startup
    var itemArray = [Item]()
   
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.title = "Find Nemo"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Kill Bill"
        itemArray.append(newItem3)
        
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items

    }
    }
    
    //MARK: - TableView DataSource Methods
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        // Create 3 hardcorded cell
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.title

        // Ternary Operator ==>
        // Value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
//    cell.textLabel?.text = itemArray[indexPath.row].
    
    //MARK:- TableView Delegate Method (Did SelectRow)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Checkmark next to cells which you have selected // ACCESSORY
        // TableView.cellForRow(at: indexPath)?.accessoryType = .checkmark // it will be default all checked there will be no ways todeselect
        
        // Add and Remove checkmark ... Click once ->(checkmark) Click again ->(Remove checkmark)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        
        // To Avoid highlight on grey & Should be flash grey and go back to white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Add New Item button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // UI alert controller to show. have text field and write quick to do list and append to itemArray
        let alert = UIAlertController(title: "Add To-Do Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will hepen once user will click add item on UIAlert
            
            
            //
            let newItem = Item()
            newItem.title = textField.text!
            
            // Still item will not be append on the row
             self.itemArray.append(newItem)
            
            // user defaults
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            
            // majic method reload data. this reload and recount and add new item :)
            self.tableView.reloadData()
        }
        
        // add textField on UI Alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
