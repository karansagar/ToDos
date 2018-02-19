//
//  ViewController.swift
//  ToDoe
//
//  Created by Karan Sagar on 16/02/18.
//  Copyright © 2018 Karan Sagar. All rights reserved.
//

import UIKit
import CoreData

// 1 Added UITableViewController
class ToDoListViewController: UITableViewController {
    
    // 2. Brand new item array in this array some hardcorded items on startup
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        
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
        
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        //     itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //Calling Function of save Item
        saveItems()
        
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
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
          
            
            // Still item will not be append on the row
            self.itemArray.append(newItem)
            
            
            // Called Function
            self.saveItems()
            
            
            
        }
        
        // add textField on UI Alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems()  {
        
        do {
            try context.save()
        } catch {
            print("Error saving context\(error)")
        }
        
        // majic method reload data. this reload and recount and add new item :)
        self.tableView.reloadData()
    }
    
    // Load Item Function
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil)  {
        // let request:NSFetchRequest<Item> =
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context\(error)")
        }
        tableView.reloadData()
    }
    
}

// MARL:- Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // we can create sort
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Calling loadItem Request
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
