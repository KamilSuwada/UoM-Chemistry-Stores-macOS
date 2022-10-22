//
//  JSONSubcategory.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Foundation




class JSONSubcategory: Codable {
    
    var name: String
    var defaultName: String
    var imageName: String
    var defaultImageName: String
    var canEdit: Bool
    var hasCustomImage: Bool
    var items: [JSONItem]
    var itemsKeywords: [String]
    let id: UUID
    
    
    
    init(name: String, imageName: String) {
        self.name = name
        self.defaultName = name
        self.items = []
        self.imageName = imageName
        self.defaultImageName = ""
        self.canEdit = false
        self.hasCustomImage = false
        self.itemsKeywords = []
        self.id = UUID()
    }
    
    
}
