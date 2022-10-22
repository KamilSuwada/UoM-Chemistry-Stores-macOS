//
//  CategoriesVC.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 06/05/2022.
//

import Cocoa
import RealmSwift



class CategoriesVC: NSViewController {
    
    
    @IBOutlet weak var categoriesOutline: NSOutlineView!
    
    
    var categories: Results<Category>?
    var itemsToShow: Array<Item> = Array<Item>()
    var windowVC: WindowVC?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    
    
    
    
    
    
}




// MARK: NSOutlineView:
extension CategoriesVC: NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let windowVC = self.windowVC else { return 0 }
        guard let category = item as? Category else { return windowVC.appLogic.categoriesAsArray.count }
        return category.subcategories.count
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let windowVC = self.windowVC else { return "" }
        guard let category = item as? Category else { return windowVC.appLogic.categoriesAsArray[index] }
        return category.subcategories[index]
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let category = item as? Category else { return false }
        
        if category.name == "Favourites" {
            return false
        } else {
            return true
        }
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
      
        
        if let category = item as? Category
        {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as? NSTableCellView
            if let textField = view?.textField
            {
                textField.stringValue = category.name
            }
        } else if let subcategory = item as? Subcategory
        {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self) as? NSTableCellView
            if let textField = view?.textField
            {
                textField.stringValue = subcategory.name
            }
            if let imageView = view?.imageView
            {
                imageView.image = nil //NSImage(systemSymbolName: "heart", accessibilityDescription: nil)
            }
        }
        
        
        return view
    }
    
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else { return }
        guard let windowSplitVC = parent as? WindowSplitVC else { return }
        guard let itemsAndBasketVC = windowSplitVC.children[1] as? ItemsAndBasketSplitVC else { return }
        guard let itemsVC = itemsAndBasketVC.children[0] as? ItemsVC else { return }
        
        self.itemsToShow.removeAll()
        
        if let category = outlineView.item(atRow: outlineView.selectedRow) as? Category {
            if category.name == "Favourites" {
                guard let windowVC = self.windowVC else { return }
                self.itemsToShow = windowVC.appLogic.favouritesAsArray
            } else {
                self.itemsToShow = category.allItemsInCategory
            }
        } else if let subcategory = outlineView.item(atRow: outlineView.selectedRow) as? Subcategory {
            self.itemsToShow = subcategory.itemsAsArray
        } else {
            return
        }
        
        itemsVC.itemsToShow = self.itemsToShow
        itemsVC.itemsTableView.reloadData()
    }
    
    
}




// MARK: Set up:
extension CategoriesVC {
    
    private func setUp() {
        guard let splitVC = parent as? WindowSplitVC else { fatalError("Could not get the splitVC from CategoriesVC!")}
        
        categoriesOutline.delegate = self
        categoriesOutline.dataSource = self
    }
    
    func refreshSelf() {
        categoriesOutline.reloadData()
    }
    
}
