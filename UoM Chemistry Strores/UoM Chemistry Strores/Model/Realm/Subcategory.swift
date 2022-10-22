//
//  Subcategory.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Foundation
import RealmSwift



class Subcategory: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var defaultName: String = ""
    @objc dynamic var canEdit: Bool = true
    var items: List<Item> = List<Item>()
    var itemsKeywords: [String] = []
    @objc dynamic var imageData: Data? = nil
    @objc dynamic var id: UUID = UUID()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "subcategories")
    
    
    convenience init(name: String, image: Data? = nil) {
        self.init()
        self.name = name
        self.defaultName = name
        self.items = List<Item>()
        self.canEdit = true
        self.itemsKeywords = []
        self.imageData = image
    }
    
    
    convenience init(from subcategory: JSONSubcategory, with image: Data? = nil) {
        self.init()
        self.name = subcategory.name
        self.defaultName = subcategory.name
        self.items = List<Item>()
        self.canEdit = subcategory.canEdit
        self.itemsKeywords = []
        self.id = subcategory.id
        self.imageData = image
    }
    
    
    var itemsAsArray: Array<Item> {
        var items = Array<Item>()
        items.append(contentsOf: self.items)
        return items
    }
    
    
}
