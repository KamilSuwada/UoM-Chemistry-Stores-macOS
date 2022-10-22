//
//  AppLogic.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import AppKit
import RealmSwift



class AppLogic {
    
    
    let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    var emptyCategories = Array<JSONCategory>()
    var currentPersonalData: PersonalData?
    
    var userSettings: UserSettings = UserSettings()
    
    var searchText: String = ""
    
    
    init() {
        
        
        if realm.objects(UserSettings.self).isEmpty {
            do {
                try realm.write({
                    realm.add(self.userSettings)
                })
            } catch {
                print(error.localizedDescription)
            }
        } else {
            self.userSettings = realm.objects(UserSettings.self).first!
        }
        
        
        if realm.objects(UserSettings.self).isEmpty {
            let settings = UserSettings()
            self.userSettings = settings
            
            do {
                try realm.write({
                    realm.add(settings)
                })
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
        if realm.objects(Category.self).isEmpty {
            self.populateRealmFromJSON()
        }
        
        
        if realm.objects(PersonalData.self).isEmpty {
            let data = PersonalData()
            do {
                try realm.write({
                    realm.add(data)
                })
            } catch {
                print(error.localizedDescription)
            }
        } else if realm.objects(PersonalData.self).count > 1 {
            let data = PersonalData()
            
            do {
                try realm.write({
                    realm.delete(realm.objects(PersonalData.self))
                    realm.add(data)
                })
            } catch {
                print(error.localizedDescription)
            }
        }
        
        self.currentPersonalData = realm.objects(PersonalData.self)[0]
    }
    
    
    private func populateRealmFromJSON() {
        
        guard let path = K.Assets.getPathToChemistryItems(for: "Chem_Database") else { fatalError("Could not find the path to JSON!") }
        
        let categories = JsonCoder.decode(from: path)
        guard let categories = categories else { fatalError("Could not decode JSON into objetcs!") }
        
        self.emptyCategories = categories
        
        for cat in self.emptyCategories {
            let newCategory = Category(from: cat)
            for subcat in cat.subcategories {
                let newSubcategory = Subcategory(from: subcat, with: NSImage(named: subcat.imageName)?.tiffRepresentation)
                for item in subcat.items {
                    let newItem = Item(from: item, with: NSImage(named: item.imageName)?.tiffRepresentation)
                    newSubcategory.items.append(newItem)
                    print("Subcategory: \(newSubcategory.name)      added item: \(newItem.name)")
                }
                newCategory.subcategories.append(newSubcategory)
                print("Category: \(newCategory.name)      added subcategory: \(newSubcategory.name)")
            }
            do {
                try realm.write({
                    realm.add(newCategory)
                    print("Saved to Realm: \(newCategory.name)")
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    // MARK: Computed properties:
    
    
    var order: Order {
        
        var ppeItem: Int = 0
        
        var orderList: String = ""
        var orderString = """
Dear Chemistry Stores,

It is \(self.currentPersonalData!.name) from the \(self.currentPersonalData!.lab).

I would like to place an order for the following items for which, I would like to use code: \(self.currentPersonalData!.code):



"""
        
        for item in self.currentBasket {
            if item.isNotPPE == true {
                let line = "\(item.quantity)x \(item.name) - \(item.code)\n"
                orderString = orderString + line
                orderList = orderList + line
            } else {
                ppeItem += 1
            }
        }
        
        if ppeItem != 0 {
            
            orderString = orderString + "\n\n"
            
            orderString = orderString + "Additionally, we would like to add the following PPE items to the order using code: \(self.currentPersonalData!.ppeCode):"
            
            orderString = orderString + "\n\n"
            
            for item in self.currentBasket {
                if item.isNotPPE == false {
                    let line = "\(item.quantity)x \(item.name) - \(item.code)\n"
                    orderString = orderString + line
                    orderList = orderList + line
                } else {
                    ppeItem += 1
                }
            }
            
            orderString = orderString + "\n\n"
            
        } else {
            orderString = orderString + "\n\n"
        }
        
        let endingString = """
Thank you for any help with this,

Kind Regards

\(self.currentPersonalData!.name)
"""
        
        orderString = orderString + endingString
        
        let order = Order()
        order.email = orderString
        order.list = orderList
        
        return order
    }
    
    
    var currentCategories: Results<Category> {
        return self.realm.objects(Category.self)
    }
    
    
    var categoriesAsArray: Array<Category> {
        var output = Array<Category>()
        output.append(contentsOf: self.currentCategories)
        return output
    }
    
    
    var basketTotal: Double {
        var total: Double = 0.0
        
        for item in currentBasket {
            total = total + (Double(item.quantity) * item.price)
        }
        
        return total
    }
    
    
    var formattedBasketTotal: String {
        if self.basketTotal == 0.0 {
            return "£0.00"
        } else {
            let amount: String = String(format: "%.2f", self.basketTotal)
            return "£\(amount)"
        }
    }
    
    
    var favourites: List<Item> {
        let output = List<Item>()
        for item in allItems {
            if item.isFavourite == true {
                output.append(item)
            }
        }
        return output
    }
    
    
    var favouritesAsArray: Array<Item> {
        return Array(self.favourites)
    }
    
    
    var allItems: Results<Item> {
        let realm = try! Realm()
        return realm.objects(Item.self)
    }
    
    
    var allItemsAsArray: Array<Item> {
        var output = Array<Item>()
        output.append(contentsOf: self.allItems)
        return output
    }
    
    
    var currentBasket: List<Item> {
        let output = List<Item>()
        for item in allItems {
            if item.quantity > 0 {
                output.append(item)
            }
        }
        return output
    }
    
    
    var currentBasketAsArray: Array<Item> {
        var output = Array<Item>()
        output.append(contentsOf: self.currentBasket)
        return output
    }
    
    
    
    // MARK: General methods for updating the logic upon user interactions:
    
    
    
    // Method which clears order and basket data.
    func clearBasket() {
        do {
            try realm.write({
                for item in self.allItems {
                    if item.quantity != 0 {
                        item.quantity = 0
                }
            }
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func saveUsualOrder() -> Bool {
        guard self.currentBasket.isEmpty == false
        else {
            
            let alert = NSAlert()
            
            alert.messageText = "Basket is empty."
            alert.informativeText = "Make sure to add items at desired quantities to the basket before setting the ususal order. If you would like to reset usual order, please tap on 'Reset'."
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Reset")
            
            let response: NSApplication.ModalResponse = alert.runModal()
            if (response == NSApplication.ModalResponse.alertSecondButtonReturn) {
                
                do {
                    try realm.write({
                        for item in self.allItems {
                            item.isUsual = false
                            item.usualQuantity = 0
                        }
                    })
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
            return false
        }
        
        do {
            try realm.write({
                for item in self.allItems {
                    item.isUsual = false
                    item.usualQuantity = 0
                }
                for item in self.currentBasket {
                    item.isUsual = true
                    item.usualQuantity = item.quantity
                }
            })
        } catch {
            print(error.localizedDescription)
        }
        
        return true
    }
    
    
    func orderUsual() {
        
        if self.currentBasket.isEmpty {
            do {
                try realm.write({
                    for item in self.allItemsAsArray {
                        if item.isUsual == true {
                            item.quantity = item.usualQuantity
                        }
                    }
                })
            } catch {
                print(error.localizedDescription)
            }
        } else {
            let alert = NSAlert()
            
            alert.messageText = "Your basket already contains products."
            alert.informativeText = "Would you like to merge or replace current selection?"
            alert.alertStyle = .critical
            alert.addButton(withTitle: "Merge")
            alert.addButton(withTitle: "Replace")
            
            let response: NSApplication.ModalResponse = alert.runModal()
            if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
                do {
                    try realm.write({
                        for item in self.allItemsAsArray {
                            if item.isUsual == true {
                                item.quantity += item.usualQuantity
                            }
                        }
                    })
                } catch {
                    print(error.localizedDescription)
                }
            } else if (response == NSApplication.ModalResponse.alertSecondButtonReturn) {
                self.clearBasket()
                do {
                    try realm.write({
                        for item in self.allItemsAsArray {
                            if item.isUsual == true {
                                item.quantity = item.usualQuantity
                            }
                        }
                    })
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
     
    // MARK: Filtering:
    
    
    
    var isSearching: Bool = false
    
    
    var searchResults: Array<SearchItem> {
        
        var searchHits: Array<SearchHit> = Array<SearchHit>()
        let splitSearchTerm = self.searchText.components(separatedBy: " ")
        
        
        for word in splitSearchTerm {
            
            let nameHitsArr = Array(realm.objects(Item.self).filter("name CONTAINS[cd] %@", word).sorted(byKeyPath: "name", ascending: true))
            let nameHits = SearchHit(type: .name, result: nameHitsArr)
            searchHits.append(nameHits)
            
            let codeHitsArr = Array(realm.objects(Item.self).filter("code CONTAINS[cd] %@", word).sorted(byKeyPath: "name", ascending: true))
            let codeHits = SearchHit(type: .code, result: codeHitsArr)
            searchHits.append(codeHits)
            
            let unitIssueHitsArr = Array(realm.objects(Item.self).filter("unitIssue CONTAINS[cd] %@", word).sorted(byKeyPath: "name", ascending: true))
            let unitIssueHits = SearchHit(type: .unitIssue, result: unitIssueHitsArr)
            searchHits.append(unitIssueHits)
            
            let keywordsHitsArr = Array(realm.objects(Item.self).filter("keywords CONTAINS[cd] %@", word).sorted(byKeyPath: "name", ascending: true))
            let keywordsHits = SearchHit(type: .keywords, result: keywordsHitsArr)
            searchHits.append(keywordsHits)
        }
        
        
        var dict: [String : SearchItem] = [:]
        
        for hit in searchHits {
            for item in hit.result {
                if let _ = dict[item.id.uuidString] {
                    var searchHitAdded = dict[item.id.uuidString]!
                    searchHitAdded.addSearchHitType(hit.type)
                    searchHitAdded.plusOneHit()
                    dict.updateValue(searchHitAdded, forKey: item.id.uuidString)
                } else {
                    var searchItem = SearchItem(item: item)
                    searchItem.addSearchHitType(hit.type)
                    searchItem.plusOneHit()
                    dict.updateValue(searchItem, forKey: item.id.uuidString)
                }
            }
        }
        
        var output = Array<SearchItem>()
        
        for (_, value) in dict {
            output.append(value)
        }
        
        
        output.sort { item1, item2 in
            return item1.numberOfHitsForSearchTerm > item2.numberOfHitsForSearchTerm
        }
        
        
        return output
    }
    
    
    
}
