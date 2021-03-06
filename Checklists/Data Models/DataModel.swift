//
//  DataModel.swift
//  Checklists
//
//  Created by 戴林 on 2018/8/10.
//  Copyright © 2018年 potatosoft.co.ltd. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistIndex": -1, "FirstTime": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    func sortChecklists() {
        lists.sort(by: {checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending})
        for checklist in lists {
            checklist.items.sort(by: {item1, item2 in if item1.shouldRemind == item2.shouldRemind { return item1.dueDate < item2.dueDate } else if item1.shouldRemind == true && item2.shouldRemind == false { return true} else { return false} })
            //checklist.items.sort(by: {item1, item2 in return })
        }
    }
    
    func documentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array!")
        }
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            
            let decoder = PropertyListDecoder()
            
            do {
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists()
            } catch {
                print("Error decoding list array!")
            }
        }
    }
}
