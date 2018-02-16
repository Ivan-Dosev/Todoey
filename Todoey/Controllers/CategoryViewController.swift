//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ivan Dimitrov on 11.02.18.
//  Copyright © 2018 Ivan Dosev Dimitrov. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    //    MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    //    MARK: - Tableview Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinacionVC = segue.destination as! TodoListViewController
        if  let indexPath = tableView.indexPathForSelectedRow{
            destinacionVC.selectedCategory = categoryArray[indexPath.row]
        }

    }
    
    //    MARK: - Data Manipulation Methods
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            self.categoryArray.append(newItem)
            
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present (alert,animated: true,completion: nil)
        
    }
    
    //    MARK: - DATA Manipulation Methods
    func saveCategories() {
        
        do {
            try context.save()
        }
        catch{
            print ("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }

}

