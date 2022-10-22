//
//  UserSettings.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 07/05/2022.
//

import Foundation
import RealmSwift



class UserSettings: Object {
    
    
    @objc dynamic var hasAgreedToTermsAndConditionsV0: Bool = false
    
    @objc dynamic var prefersOrdersAsLists: Bool = false
    
    
    func restoreDefault() {
        hasAgreedToTermsAndConditionsV0 = false
        self.prefersOrdersAsLists = false
    }
    
    
}
