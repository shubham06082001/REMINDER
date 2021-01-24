//
//  Item.swift
//  REMINDER
//
//  Created by SHUBHAM KUMAR on 24/01/21.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
