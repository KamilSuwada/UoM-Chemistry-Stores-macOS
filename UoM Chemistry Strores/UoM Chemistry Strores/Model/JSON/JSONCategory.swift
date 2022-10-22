//
//  JSONCategory.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Foundation




class JSONCategory: Codable {
    
    var name: String
    var defaultName: String
    var canEdit: Bool
    var subcategories: [JSONSubcategory]
    var isOpened: Bool
    var subcategoriesAndItemsKeywords: [String]
    let id: UUID
    
    init(name: String) {
        self.name = name
        self.defaultName = name
        self.subcategories = []
        self.isOpened = false
        self.canEdit = false
        self.subcategoriesAndItemsKeywords = []
        
        self.id = UUID()
    }
    
}
