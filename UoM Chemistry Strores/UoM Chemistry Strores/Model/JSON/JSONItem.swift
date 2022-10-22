//
//  JSONItem.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Foundation




class JSONItem: Codable {
    
    var name: String
    var defaultName: String
    var code: String
    var unitIssue: String
    var canEdit: Bool
    var keywords: [String]
    var isFavourite: Bool
    var price: Double
    var imageName: String
    var defaultImageName: String
    var quantity: Int
    var hasCustomImage: Bool
    var isNotPPE: Bool
    let id: UUID
    
    var isDelivered: Bool
    
    var searchableStrings: [String]
    var searchableString: String
    
    var itemIndexInTable: Int?
    
    
// MARK: Initialisers:
    
    // Initialiser will be used to initialise and item for the first time they are created, from JSON created by custom Python script.
    init(name: String, code: String, unitIssue: String, keywords: [String], isFavourite: Bool, price: Double, imageName: String, quantity: Int) {
        self.name = name
        self.defaultName = name
        self.code = code
        self.unitIssue = unitIssue
        self.keywords = keywords
        self.isFavourite = isFavourite
        self.price = price
        self.imageName = imageName
        self.defaultImageName = ""
        self.quantity = quantity
        self.isNotPPE = true
        self.canEdit = false
        self.hasCustomImage = false
        self.isDelivered = false
        
        self.searchableStrings = []
        
        self.searchableStrings.append(self.name)
        self.searchableStrings.append(self.code)
        self.searchableStrings.append(self.unitIssue)
        
        for keyword in self.keywords {
            self.searchableStrings.append(keyword)
        }
        
        self.searchableString = self.searchableStrings.joined(separator: " ")
        
        self.id = UUID()
    }
}
