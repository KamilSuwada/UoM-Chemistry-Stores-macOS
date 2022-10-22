//
//  SearchResults.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 07/05/2022.
//

import Foundation




enum SearchHitType {
    case name
    case code
    case unitIssue
    case keywords
}


struct SearchHit {
    let type: SearchHitType
    let result: Array<Item>
}


struct SearchItem {
    let item: Item
    var numberOfHitsForSearchTerm: Int = 0
    var searchHits: Array<SearchHitType> = Array<SearchHitType>()
    
    
    mutating func addSearchHitType(_ hit: SearchHitType) {
        self.searchHits.append(hit)
    }
    
    
    mutating func plusOneHit() {
        self.numberOfHitsForSearchTerm += 1
    }
    
    
    mutating func resetHitsNumber(_ hit: SearchHitType) {
        self.numberOfHitsForSearchTerm = 0
    }
}
