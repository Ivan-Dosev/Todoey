//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ivan Dimitrov on 11.02.18.
//  Copyright © 2018 Ivan Dosev Dimitrov. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    //    MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
//        cell.textLabel?.text = item.name
        
        return cell
    }
    
    //    MARK: - Tableview Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinacionVC = segue.destination as! TodoListViewController
        if  let indexPath = tableView.indexPathForSelectedRow{
            destinacionVC.selectedCategory = categories?[indexPath.row]
        }

    }
    
    //    MARK: - Data Manipulation Methods
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present (alert,animated: true,completion: nil)
        
    }
    
    //    MARK: - DATA Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print ("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
      categories = realm.objects(Category.self)

        tableView.reloadData()
    }

}

