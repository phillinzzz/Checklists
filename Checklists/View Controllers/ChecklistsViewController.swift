//
//  ViewController.swift
//  Checklists
//
//  Created by 戴林 on 2018/7/23.
//  Copyright © 2018年 potatosoft.co.ltd. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController, ItemDetailViewControllerDelegate {
    

    //var items = [ChecklistItem]()
    var checklist: Checklist!
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        
//        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
    
        }
        navigationController?.popViewController(animated: true)
        
//        saveChecklistItems()
    }
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file is \(dataFilePath())")
//        loadChecklistItems()
        title = checklist.name
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",
                                                 for: indexPath)
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = checklist.items[indexPath.row]
            
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
//        saveChecklistItems()
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
        
        label.textColor = view.tintColor
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    

    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        let subtitle = cell.viewWithTag(1002) as! UILabel
        //label.text = item.text
        label.text = "\(item.itemID): \(item.text)"
        
        
        if item.shouldRemind {
            if item.dueDate <= Date() {
                subtitle.text = "Expired!"
            } else {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
      
                subtitle.text = "Due Date: \(formatter.string(from: item.dueDate))"
            }
        } else {
            subtitle.text = "Take what ever long as you wish!"
        }
        //subtitle.text = "no due time!"
    }
    
    



}

