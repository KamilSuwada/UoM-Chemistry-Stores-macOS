//
//  OrderViewController.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 07/05/2022.
//

import Cocoa




class OrderViewController: NSViewController {
    
    
    @IBOutlet weak var copyButton: NSButton!
    @IBOutlet weak var orderTextView: NSTextView!
    
    
    var windowVC: WindowVC?
    var showPreference: OrderPreference?
    var order: Order?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderTextView.isEditable = false
        self.orderTextView.isFieldEditor = false
        self.orderTextView.isSelectable = true
        
        guard let showPreference = self.showPreference, let order = self.order else { return }
        
        switch showPreference {
        case .list:
            self.orderTextView.string = order.list
        case .email:
            self.orderTextView.string = order.email
        }
    }
    
    
    @IBAction func copyButtonTapped(_ sender: NSButton) {
        let pasteboard = NSPasteboard.general
        let _ = pasteboard.clearContents()
        pasteboard.setString(self.orderTextView.string, forType: .string)
        
        guard let windowVC = self.windowVC else { return }
        guard let popover = windowVC.activePopover else { return }
        popover.close()
    }
    
    
}




// MARK: setUp:
extension OrderViewController {
    
    
    func setUp(Order order: Order, showPreference show: OrderPreference) {
        self.showPreference = show
        self.order = order
    }
    
    
}
