//
//  ItemVC.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 06/05/2022.
//

import Cocoa

class ItemsVC: NSViewController {

    
    @IBOutlet weak var itemsTableView: NSTableView!
    
    
    var selectedItems = Array<Item>()
    var itemsToShow = Array<Item>()
    var windowVC: WindowVC?
//    {
//        get {
//            guard let itemsAndBasketSplitVC = parent as? ItemsAndBasketSplitVC else { fatalError("Cannot get ItemsAndBasketSplitVC!") }
//            guard let windowSplitVC = itemsAndBasketSplitVC.parent as? WindowSplitVC else { fatalError("Cannot get WindowSplitVC!") }
//            guard let windowVC = windowSplitVC.parent?.view.window?.windowController as? WindowVC else { fatalError("Cannot get WindowVC!") }
//
//            return windowVC
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
}




// MARK: NSTableViewDelegate and DataSource conformance:
extension ItemsVC: NSTableViewDelegate, NSTableViewDataSource {
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let windowVC = self.windowVC else { return 0 }
        
        if windowVC.appLogic.isSearching == true {
            return windowVC.appLogic.searchResults.count
        } else if itemsToShow.isEmpty == true {
            return windowVC.appLogic.allItemsAsArray.count
        } else {
            return self.itemsToShow.count
        }
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? ItemCellView else { print("Returned nil rather than ItemCellView"); return nil }
        guard let windowVC = self.windowVC else { return nil }
        
        cellView.windowVC = windowVC
        
        if windowVC.appLogic.isSearching == true {
            cellView.setUp(for: windowVC.appLogic.searchResults[row].item, isSearching: true, searchHitTypes: windowVC.appLogic.searchResults[row].searchHits, searchText: windowVC.appLogic.searchText)
        } else if itemsToShow.isEmpty == true {
            cellView.setUp(for: windowVC.appLogic.allItems[row])
        } else {
            cellView.setUp(for: self.itemsToShow[row])
        }
        
        return cellView
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else { return }
        tableView.deselectRow(tableView.selectedRow)
    }
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    
}




// MARK: Set up:
extension ItemsVC {
    
    private func setUp() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
    
    func refreshSelf() {
        itemsTableView.reloadData()
    }
    
}
