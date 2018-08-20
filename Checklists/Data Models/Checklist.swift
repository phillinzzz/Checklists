//
//  Checklist.swift
//  Checklists
//
//  Created by 戴林 on 2018/8/9.
//  Copyright © 2018年 potatosoft.co.ltd. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
