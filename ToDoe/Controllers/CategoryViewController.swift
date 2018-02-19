//
//  CategoryViewController.swift
//  ToDoe
//
//  Created by Karan Sagar on 18/02/18.
//  Copyright © 2018 Karan Sagar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var catergories = [Category]()
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    
    //MARK:- TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return catergories.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = catergories[indexPath.row].name
        
        return cell
    }
    
    //MARK :- TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        saveCategory()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        //category to correspond to selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catergories[indexPath.row]
        }
        
        
    }
    
    
    //MARK:- Data Manipluation Menthod
    
    func saveCategory()  {
        do {
            try context.save()
        } catch {
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategories()  {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            catergories = try context.fetch(request)
        } catch {
            print("Error loading categories\(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK:- Add New Categories

    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.catergories.append(newCategory)
            self.saveCategory()
            
            
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    
}

