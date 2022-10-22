//
//  JSONCoder.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Foundation




class JsonCoder {
    
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    
    
    static func decode(from filePath: String) -> [JSONCategory]? {
        do {
            let url = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: url)
            return try decoder.decode([JSONCategory].self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    static func encode(data: [JSONCategory]) -> String? {
        do {
            let jsonData = try encoder.encode(data)
            if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                return String(decoding: jsonData, as: UTF8.self)
            } else {
                print("json data malformed")
                return nil
            }
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
