//
//  Item.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Foundation
import RealmSwift



class Item: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var defaultName: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var unitIssue: String = ""
    @objc dynamic var canEdit: Bool = true
    @objc dynamic var isFavourite: Bool = false
    @objc dynamic var price: Double = 0.0
    @objc dynamic var quantity: Int = 0
    @objc dynamic var isNotPPE: Bool = true
    @objc dynamic var id: UUID = UUID()
    @objc dynamic var isDelivered: Bool = false
    @objc dynamic var keywords: String = ""
    var searchableStrings: [String] = []
    @objc dynamic var imageData: Data? = nil
    var itemIndexInTable: Int? = nil
    var parentCategory = LinkingObjects(fromType: Subcategory.self, property: "items")
    
    @objc dynamic var isUsual: Bool = false
    @objc dynamic var usualQuantity: Int = 0
    
    
// MARK: Initialisers:
    
    // Initialiser will be used to initialise and item for the first time they are created, from JSON created by custom Python script.
    
    convenience init(name: String, code: String, unitIssue: String, keywords: [String], isFavourite: Bool, price: Double, imageName: String, quantity: Int) {
        self.init()
        self.name = name
        self.defaultName = name
        self.code = code
        self.unitIssue = unitIssue
        self.keywords = keywords.joined(separator: " ")
        self.isFavourite = isFavourite
        self.price = price
        self.quantity = quantity
        self.isNotPPE = true
        self.canEdit = false
        self.isDelivered = false
        
        self.searchableStrings = keywords
        self.searchableStrings.append(name)
        self.searchableStrings.append(code)
        
        self.id = UUID()
    }
    
    
    convenience init(from item: JSONItem, with imageData: Data?) {
        self.init()
        self.name = item.name
        self.defaultName = item.defaultName
        self.code = item.code
        self.unitIssue = item.unitIssue
        self.keywords = item.keywords.joined(separator: " ")
        self.isFavourite = item.isFavourite
        self.price = item.price
        self.quantity = item.quantity
        self.isNotPPE = item.isNotPPE
        self.canEdit = item.canEdit
        self.isDelivered = item.isDelivered
        
        self.searchableStrings = keywords.components(separatedBy: " ")
        self.searchableStrings.append(name)
        self.searchableStrings.append(code)
        
        self.id = item.id
        self.imageData = imageData
    }
    
    
    
    
// MARK: ItemCellDelegate methods:
    
    
    func plusOneTapped() {
        let realm = try! Realm()
        do {
            try realm.write({
                self.quantity += 1
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func minusOneTapped() {
        if self.quantity > 0 {
            let realm = try! Realm()
            do {
                try realm.write({
                    self.quantity -= 1
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func favouriteButtonTapped() {
        let realm = try! Realm()
        do {
            try realm.write({
                self.isFavourite.toggle()
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
// MARK: Computed properties:
    
    
    var formattedSelf: String {
        return "\(self.quantity) x \(self.name) - \(self.code)"
    }
    
    
    var formattedPrice: String {
        let cost = Double(self.quantity) * self.price
        return String(format: "£%.2f", cost)
    }
    
    
    var searchableString: String {
        self.searchableStrings = []
        
        self.searchableStrings.append(self.name)
        self.searchableStrings.append(self.code)
        self.searchableStrings.append(self.unitIssue)
        self.searchableStrings.append(contentsOf: self.keywords.components(separatedBy: " "))
        
        return self.searchableStrings.joined(separator: " ")
    }
    
}
