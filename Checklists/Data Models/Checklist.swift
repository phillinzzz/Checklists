//
//  Checklist.swift
//  Checklists
//
//  Created by 戴林 on 2018/8/9.
//  Copyright © 2018年 potatosoft.co.ltd. All rights reserved.
//

import Foundation

class Checklist: NSObject, Codable {
    var name = ""
    var iconName = "No Icon"
    var items = [ChecklistItem]()
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
}
