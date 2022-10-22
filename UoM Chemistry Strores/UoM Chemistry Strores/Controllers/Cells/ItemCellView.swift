//
//  ItemCellView.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Cocoa
import RealmSwift



class ItemCellView: NSTableCellView {

    
    
    @IBOutlet weak var priceLabel: NSTextField!
    @IBOutlet weak var itemNameLabel: NSTextField!
    @IBOutlet weak var itemImageView: NSImageView!
    @IBOutlet weak var unitOfIssueLabel: NSTextField!
    @IBOutlet weak var codeLabel: NSTextField!
    @IBOutlet weak var quantityLabel: NSTextField!
    @IBOutlet weak var minusButton: NSButton!
    @IBOutlet weak var plusButton: NSButton!
    @IBOutlet weak var favouriteButton: NSButton!
    
    
    var item: Item?
    var windowVC: WindowVC?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
        priceLabel.stringValue = ""
        itemNameLabel.stringValue = ""
        unitOfIssueLabel.stringValue = ""
        codeLabel.stringValue = ""
        quantityLabel.stringValue = ""
        itemImageView.image = NSImage(imageLiteralResourceName: "empty_subcategory")
        favouriteButton.image = NSImage(systemSymbolName: "heart.fill", accessibilityDescription: nil)
        favouriteButton.contentTintColor = NSColor.systemRed
    }
    
    
    func setUp(for item: Item, isSearching: Bool = false, searchHitTypes hitTypes: Array<SearchHitType>? = nil, searchText text: String = "") {
        
        self.item = item
        
        itemNameLabel.stringValue = item.name
        unitOfIssueLabel.stringValue = item.unitIssue
        codeLabel.stringValue = item.code
        
        let quantity = String(item.quantity)
        let price = String(format: "£%.2f", item.price)
        quantityLabel.stringValue = "\(quantity)"
        priceLabel.stringValue = price
        
        
        if item.isFavourite {
            favouriteButton.image = NSImage(systemSymbolName: "heart.fill", accessibilityDescription: nil)
            favouriteButton.contentTintColor = NSColor.systemRed
        } else {
            favouriteButton.image = NSImage(systemSymbolName: "heart", accessibilityDescription: nil)
            favouriteButton.contentTintColor = NSColor.systemRed
        }
        
        
        if isSearching {
            guard let hitTypes = hitTypes else { return }

            for hit in hitTypes {
                
                switch hit {
                case .name:
                    itemNameLabel.setHighlighted(with: text)
                case .code:
                    codeLabel.setHighlighted(with: text)
                case .unitIssue:
                    unitOfIssueLabel.setHighlighted(with: text)
                case .keywords:
                    return
                }
            }
        }
        
        
        guard let data = item.imageData else { itemImageView.image = NSImage(imageLiteralResourceName: "empty_subcategory"); return }
        itemImageView.image = NSImage(data: data)
    }
    
    
    
    @IBAction func minusButtonTapped(_ sender: NSButton) {
        guard let item = item else { return }
        guard let delegate = windowVC else { return }

        item.minusOneTapped()
        delegate.refreshAll()
    }
    
    
    @IBAction func plusButtonTapped(_ sender: NSButton) {
        guard let item = item else { return }
        guard let delegate = windowVC else { return }
        
        item.plusOneTapped()
        delegate.refreshAll()
    }
    
    
    @IBAction func favouriteButtonTapped(_ sender: NSButton) {
        guard let item = item else { return }
        guard let delegate = windowVC else { return }
        
        item.favouriteButtonTapped()
        delegate.refreshAll()
    }
    
    
}
