//
//  BasketVC.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 06/05/2022.
//

import Cocoa

class BasketVC: NSViewController {

    
    @IBOutlet weak var basketTableView: NSTableView!
    
    
    let appLogic = AppLogic()
    var selectedItems = Array<Item>()
    var windowVC: WindowVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    
}




// MARK: NSTableViewDelegate and DataSource conformance:
extension BasketVC: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.appLogic.currentBasketAsArray.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { print("Returned nil rather than NSTableCellView"); return nil }
        
        if let textField = cellView.textField {
            
            switch tableColumn?.title {
                
            case "Quantity":
                textField.stringValue = "\(self.appLogic.currentBasket[row].quantity) x \(self.appLogic.currentBasket[row].formattedPrice)"
                
            case "Item":
                textField.stringValue = self.appLogic.currentBasket[row].name
            
            default:
                fatalError("Unknown column was foun in BasketVC!")
                
            }
        }
        
        return cellView
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else { return }
        guard tableView.selectedRow != -1 else { self.selectedItems.removeAll(); return }
        
        let indexes = tableView.selectedRowIndexes
        self.selectedItems.removeAll()
        
        for i in indexes {
            self.selectedItems.append(appLogic.currentBasket[i])
        }
    }
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
}




// MARK: SetUp:
extension BasketVC {
    
    private func setUp() {
        basketTableView.delegate = self
        basketTableView.dataSource = self
    }
    
    
    func refreshSelf() {
        basketTableView.reloadData()
    }
    
    
}
