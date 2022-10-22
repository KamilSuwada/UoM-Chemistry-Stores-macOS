//
//  Category.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Foundation
import RealmSwift



class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var defaultName: String = ""
    @objc dynamic var canEdit: Bool = true
    var subcategories: List<Subcategory> = List<Subcategory>()
    @objc dynamic var isOpened: Bool = false
    @objc dynamic var id: UUID = UUID()
    
    convenience init(name: String) {
        self.init()
        self.name = name
        self.defaultName = name
        self.subcategories = List<Subcategory>()
        self.isOpened = false
        self.canEdit = false
    }
    
    
    convenience init(from category: JSONCategory) {
        self.init()
        self.name = category.name
        self.defaultName = category.defaultName
        self.isOpened = category.isOpened
        self.canEdit = category.canEdit
        self.id = category.id
        self.subcategories = List<Subcategory>()
    }
    
    
    var allItemsInCategory: Array<Item> {
        var subcats = Array<Subcategory>()
        subcats.append(contentsOf: self.subcategories)
        
        var items = Array<Item>()
        for subcat in subcats {
            items.append(contentsOf: subcat.items)
        }
        return items
    }
    
    
}
