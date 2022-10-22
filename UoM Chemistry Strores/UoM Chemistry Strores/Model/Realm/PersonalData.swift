//
//  PersonalData.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Foundation
import RealmSwift



class PersonalData: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var lab: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var ppeCode: String = ""
    
}
