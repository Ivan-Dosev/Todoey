//
//  ViewController.swift
//  Todoey
//
//  Created by Ivan Dimitrov on 1.02.18.
//  Copyright © 2018 Ivan Dosev Dimitrov. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

    }

    //         Mark: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //        Ternary Operator =>
            //        value == condition ? valueIfTrue : valueIfFalse
            
            //        Tozi red zamestva dolnite 5 if... else...
            cell.accessoryType = item.done ? .checkmark : .none
            
            //        ako e true napravi go .checkmark ako ne da stane .none
            
            //        if item.done == true {
            //            cell.accessoryType = .checkmark
            //        }
            //        else{
            //            cell.accessoryType = .none
            //        }
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    
    //    Mark: TableView Delegate Methods:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if let item = todoItems?[indexPath.row]
        {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print ("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        
//        print(itemArray[indexPath.row])
        
//        tozi red zamestva dolnite 5 reda If.... else ...
//      *  todoItems[indexPath.row].done = !itemArray[indexPath.row].done
//
//      *    saveItem()
//
//       if itemArray[indexPath.row].done == false
//       {
//        itemArray[indexPath.row].done = true
//        }
//       else {
//        itemArray[indexPath.row].done = false
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //    Mark: Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                       currentCategory.items.append(newItem)
                    }
                }
                    catch{
                        print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present (alert,animated: true,completion: nil)
        
    }
    
    
    func loadItems() {
      
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
       
        tableView.reloadData()
    }
   
}

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
     
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
        }
        DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
        }
    }
}

