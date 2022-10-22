//
//  NSTextField.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 07/05/2022.
//

import AppKit




extension NSTextField {
    
    
    func setHighlighted(with search: String?...) {
        
        let txtLabel = self.stringValue
        let attributeTxt = NSMutableAttributedString(string: txtLabel)
        
        search.forEach {
            if let searchedText = $0?.lowercased() {
                let range: NSRange = attributeTxt.mutableString.range(of: searchedText, options: .caseInsensitive)
                
                attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.black, range: range)
                attributeTxt.addAttribute(NSAttributedString.Key.backgroundColor, value: NSColor.systemYellow, range: range)
            }
        }
        self.attributedStringValue = attributeTxt
    }
    
    
}
