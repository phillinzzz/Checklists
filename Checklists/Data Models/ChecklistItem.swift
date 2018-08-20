//
//  ChecklistItem.swift
//  Checklists
//
//  Created by 戴林 on 2018/7/24.
//  Copyright © 2018年 potatosoft.co.ltd. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
