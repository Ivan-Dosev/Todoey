//
//  ViewController.swift
//  Todoey
//
//  Created by Ivan Dimitrov on 1.02.18.
//  Copyright © 2018 Ivan Dosev Dimitrov. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

    }

    //         Mark: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
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
        return cell
    }
    
    
    //    Mark: TableView Delegate Methods:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
//        print(itemArray[indexPath.row])
        
//        tozi red zamestva dolnite 5 reda If.... else ...
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
          saveItem()
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present (alert,animated: true,completion: nil)
        
    }
    
    func saveItem() {
       
        do {
           try context.save()
        }
        catch{
            print ("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
      
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do{
      itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
   
}

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request,predicate: predicate)
        
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

