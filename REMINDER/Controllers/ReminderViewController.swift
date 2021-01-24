//
//  ViewController.swift
//  REMINDER
//
//  Created by SHUBHAM KUMAR on 23/12/20.
//

import UIKit
import RealmSwift

class ReminderViewController: UITableViewController {
    
    var reminderItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    //    let defaults = UserDefaults.standard
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") as Any)
        
        //        print(dataFilePath as Any)
        
        //        let newItem = Item()
        //        newItem.title = "iOS APP Development"
        //        reminderItems.append(newItem)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "WEB Development"
        //        newItem2.done = true
        //        reminderItems.append(newItem2)
        //
        //        let newItem3 = Item()
        //        newItem3.title = "PWA Development"
        //        reminderItems.append(newItem3)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reminderItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = reminderItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = reminderItems?[indexPath.row] {
            
            do{
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            }catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        //        reminderItems[indexPath.row].done = !reminderItems[indexPath.row].done
        
        //        context.delete(reminderItems[indexPath.row])
        //        reminderItems.remove(at: indexPath.row)
        
        
        //        if reminderItems[indexPath.row].done == false {
        //            reminderItems[indexPath.row].done = true
        //        }
        //        else{
        //            reminderItems[indexPath.row].done = false
        //        }
        
        //        tableView.reloadData()
        
        //        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:-     ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                
                do{
                    try self.realm.write{
                        
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving category \(error)")
                }
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Model Manipulation Methods
    
    //    func saveItems(){
    //
    //        do{
    //            try realm.write{
    //                realm.add(reminderItems!)
    //            }
    //        }
    //        catch{
    //            print("Error saving context\(error)")
    //        }
    //        tableView.reloadData()
    //    }
    
    func loadItems(){
        
        reminderItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
}

//MARK: - Search Bar Methods

extension ReminderViewController: UISearchBarDelegate{


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        reminderItems = reminderItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
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
