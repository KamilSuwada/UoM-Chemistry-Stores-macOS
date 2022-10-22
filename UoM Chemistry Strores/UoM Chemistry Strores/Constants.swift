//
//  Constants.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Foundation
import RealmSwift



struct K {
    
    
    static func getSettings() -> Array<Setting> {
        var output = Array<Setting>()
        
        let realm = try! Realm()
        let userSettings = realm.objects(UserSettings.self).first!
        
        // Not finished as 98% of UoM Chemistry has Windows machines.
        
        return output
    }
    
    
    struct HelpText {
        
        
        static let v0 = """
Terms, conditions and some other information would have been here!.
"""
        
        
    }
    
    
    struct Popovers {
        
        static let orderVC = "orderVC"
        static let updateDetailsVC = "updateDetailsVC"
        static let infoVC = "infoVC"
        static let settingsVC = "settingsVC"
        
    }
    
    
    struct Assets {
        
        static func getPathToChemistryItems(for resourceName: String) -> String? {
            let url = Bundle.main.url(forResource: resourceName, withExtension: "json")
            if let url = url {
                return url.path
            } else {
                return nil
            }
        }
        
        
        static func getPathToAssetPics(forPNG resourceName: String) -> String? {
            let url = Bundle.main.url(forResource: resourceName, withExtension: "png")
            if let url = url {
                return url.path
            } else {
                return nil
            }
        }
        
        
        static func getPathToAssetPics(forJPG resourceName: String) -> String? {
            let url = Bundle.main.url(forResource: resourceName, withExtension: "jpg")
            if let url = url {
                return url.path
            } else {
                return nil
            }
        }
        
        
        static func getPathToAssetPics(forJPEG resourceName: String) -> String? {
            let url = Bundle.main.url(forResource: resourceName, withExtension: "jpeg")
            if let url = url {
                return url.path
            } else {
                return nil
            }
        }
    }
}
