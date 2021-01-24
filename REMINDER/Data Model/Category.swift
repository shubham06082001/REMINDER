//
//  Category.swift
//  REMINDER
//
//  Created by SHUBHAM KUMAR on 24/01/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
    
}
