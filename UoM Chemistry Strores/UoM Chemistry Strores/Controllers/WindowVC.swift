//
//  MainWindowController.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Cocoa
import SwiftUI

class WindowVC: NSWindowController {
    
    
    @IBOutlet weak var infoButton: NSToolbarItem!
    @IBOutlet weak var orderUsualButton: NSToolbarItem!
    @IBOutlet weak var setUsualButton: NSToolbarItem!
    @IBOutlet weak var minusButton: NSToolbarItem!
    @IBOutlet weak var plusButton: NSToolbarItem!
    @IBOutlet weak var detailsButton: NSToolbarItem!
    @IBOutlet weak var orderButton: NSToolbarItem!
    @IBOutlet weak var deleteButton: NSToolbarItem!
    @IBOutlet weak var searchButton: NSSearchToolbarItem!
    @IBOutlet weak var collapseCategoriesViewButton: NSToolbarItem!
    @IBOutlet weak var inBasketButton: NSToolbarItem!
    @IBOutlet weak var settingsButtonTapped: NSToolbarItem!
    
    
    let appLogic = AppLogic()
    
    
    var windowSplitVC: WindowSplitVC?
    var categoriesVC: CategoriesVC?
    var itemsAndBasketSplitVC: ItemsAndBasketSplitVC?
    var itemsVC: ItemsVC?
    var basketVC: BasketVC?
    var activePopover: NSPopover?
    var locked: Bool = true
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.setUp()
    }
    
    
    @IBAction func inBasketButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
    }
    
    
    @IBAction func settingsButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
        
        if locked == false {
            guard let itemsVC = itemsVC else { return }

            let height = 700
            let width = 400
            
            let popoverContentController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(K.Popovers.settingsVC)) as! SettingsViewController
            
            popoverContentController.windowVC = self
            
            let popover = NSPopover()
            
            popover.contentSize = NSSize(width: width, height: height)
            popover.behavior = .semitransient
            popover.animates = true
            popover.contentViewController = popoverContentController
            
            self.activePopover = popover
            popover.show(relativeTo: itemsVC.view.frame, of: itemsVC.view, preferredEdge: .maxX)
        }
    }
    
    
    @IBAction func detailsButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
        
        if locked == false {
            guard let itemsVC = self.itemsVC else { return }

            let popoverContentController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(K.Popovers.updateDetailsVC)) as! UpdateDetailsViewController
            
            popoverContentController.windowVC = self
            popoverContentController.personalData = appLogic.currentPersonalData
            
            let popover = NSPopover()
            popover.contentSize = NSSize(width: 400, height: 700)
            popover.behavior = .semitransient
            popover.animates = true
            popover.contentViewController = popoverContentController
            self.activePopover = popover
            popover.show(relativeTo: itemsVC.view.frame, of: itemsVC.view, preferredEdge: .maxX)
        }
        
    }
    
    
    @IBAction func orderButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
        
        if locked == false {
            guard self.appLogic.userSettings.hasAgreedToTermsAndConditionsV0 == true else { return }
            
            guard let basketVC = self.basketVC else { return }
            guard let itemsVC = self.itemsVC else { return }
            
            guard appLogic.currentBasket.isEmpty != true else {
                let alert = NSAlert()
                
                alert.messageText = "Nothing in the basket!"
                alert.informativeText = "Please add items to the basket before generating the order."
                alert.alertStyle = .critical
                alert.addButton(withTitle: "OK")
                
                let response: NSApplication.ModalResponse = alert.runModal()
                if (response == NSApplication.ModalResponse.alertFirstButtonReturn) { return }
                return
            }
            
            guard appLogic.currentPersonalData?.name != "", appLogic.currentPersonalData?.code != "", appLogic.currentPersonalData?.lab != "", appLogic.currentPersonalData?.ppeCode != "" else {
                let alert = NSAlert()
                
                alert.messageText = "Missing personal data!"
                alert.informativeText = "Would you like to update the data now?"
                alert.alertStyle = .critical
                alert.addButton(withTitle: "OK")
                alert.addButton(withTitle: "Cancel")
                
                let response: NSApplication.ModalResponse = alert.runModal()
                if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
                    
                    let popoverContentController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(K.Popovers.updateDetailsVC)) as! UpdateDetailsViewController
                    
                    popoverContentController.windowVC = self
                    popoverContentController.personalData = appLogic.currentPersonalData
                    
                    let popover = NSPopover()
                    popover.contentSize = NSSize(width: 400, height: 700)
                    popover.behavior = .semitransient
                    popover.animates = true
                    popover.contentViewController = popoverContentController
                    self.activePopover = popover
                    popover.show(relativeTo: itemsVC.view.frame, of: itemsVC.view, preferredEdge: .maxX)
                    
                }
                return
            }
            
            let height = basketVC.view.frame.height - 120
            let width = basketVC.view.frame.width - 15

            let popoverContentController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(K.Popovers.orderVC)) as! OrderViewController
            
            popoverContentController.windowVC = self
            popoverContentController.order = appLogic.order
            popoverContentController.showPreference = .email
            
            let popover = NSPopover()
            popover.contentSize = NSSize(width: width, height: height)
            popover.behavior = .semitransient
            popover.animates = true
            popover.contentViewController = popoverContentController
            self.activePopover = popover
            popover.show(relativeTo: itemsVC.view.frame, of: itemsVC.view, preferredEdge: .maxX)
        }
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
        
        if locked == false {
            guard let basketVC = self.basketVC else { return }
            
            do {
                try appLogic.realm.write({
                    for entry in basketVC.selectedItems {
                        for item in appLogic.allItems {
                            if entry.id == item.id {
                                item.quantity = 0
                                break
                            }
                        }
                    }
                })
            } catch {
                print(error.localizedDescription)
            }
            
            self.refreshAll()
        }
    }
    
    
    @IBAction func searchButtonTapped(_ sender: NSSearchToolbarItem) {
        
        // search implementated via delegate methods
        
    }
    
    
    @IBAction func collapseCategoriesButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
        
        if locked == false {
            guard let splitVC = contentViewController as? WindowSplitVC else { return }
            splitVC.splitViewItems[0].isCollapsed.toggle()
        }
    }
    
    
    @IBAction func plusButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
        
        if locked == false {
            guard let basketVC = self.basketVC else { return }
            
            for entry in basketVC.selectedItems {
                for item in appLogic.allItems {
                    if entry.id == item.id {
                        item.plusOneTapped()
                        break
                    }
                }
            }
            
            self.refreshAll()
        }
    }
    
    
    
    @IBAction func minusButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
        
        if locked == false {
            guard let basketVC = self.basketVC else { return }
            
            for entry in basketVC.selectedItems {
                for item in appLogic.allItems {
                    if entry.id == item.id {
                        item.minusOneTapped()
                        break
                    }
                }
            }
            
            self.refreshAll()
        }
    }
    
    
    
    @IBAction func setUsualButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
        
        if locked == false {
            if appLogic.saveUsualOrder() == true {
                
                self.refreshAll()
                
                let alert = NSAlert()
                
                alert.messageText = "Usual order saved!"
                alert.informativeText = "To reorder the usual order, simply tap on the 'Order ususal' button."
                alert.alertStyle = .informational
                alert.addButton(withTitle: "OK")
                
                alert.runModal()
            }
        }
    }
    
    
    
    @IBAction func orderUsualButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
        
        if locked == false {
            appLogic.orderUsual()
            self.refreshAll()
        }
    }
    
    
    
    @IBAction func infoButtonTapped(_ sender: NSToolbarItem) {
        self.checkTermsAgreementStatus()
        
        if locked == false {
            guard let basketVC = basketVC else { return }
            guard let itemsVC = itemsVC else { return }

            let height = basketVC.view.frame.height - 120
            let width = basketVC.view.frame.width - 15
            
            let popoverContentController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(K.Popovers.infoVC)) as! InfoViewController
            
            popoverContentController.windowVC = self
            
            let popover = NSPopover()
            
            popover.contentSize = NSSize(width: width, height: height)
            popover.behavior = .semitransient
            popover.animates = true
            popover.contentViewController = popoverContentController
            
            self.activePopover = popover
            popover.show(relativeTo: itemsVC.view.frame, of: itemsVC.view, preferredEdge: .maxX)
        }
    }
    
    
}




// MARK: NSSearchFieldDelegate conformance:
extension WindowVC: NSSearchFieldDelegate {
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        
    }
    
    
    func controlTextDidChange(_ obj: Notification) {
        if locked == false {
            guard let field = obj.object as? NSSearchField, field == self.searchButton.searchField else { return }
            guard field.stringValue != "" else {
                appLogic.isSearching = false
                
                guard let splitVC = contentViewController as? WindowSplitVC else { return }
                guard let categoriesVC = splitVC.children[0] as? CategoriesVC else { return }
                guard let itemsAndBasketSplitVC = splitVC.children[1] as? ItemsAndBasketSplitVC else { return }
                guard let itemsVC = itemsAndBasketSplitVC.children[0] as? ItemsVC else { return }
                
                itemsVC.itemsToShow = categoriesVC.itemsToShow
                itemsVC.refreshSelf()
                
                return
            }
            appLogic.isSearching = true
            appLogic.searchText = field.stringValue
            refreshAll()
        }
    }
    
    
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        self.checkTermsAgreementStatus()
    }
    
}




// MARK: Order Popover:
extension WindowVC {
    
    
    private func showOrder() {
        let popoverContentController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(K.Popovers.orderVC)) as! OrderViewController
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 500)
        popover.behavior = .semitransient
        popover.animates = true
        popover.contentViewController = popoverContentController
    }
    
    
}




// MARK: setUp:
extension WindowVC {
    
    
    private func setUp() {
        
        if let screen = NSScreen.main {
            let height = screen.frame.height
            let width = screen.frame.width
            
            guard let window = self.window else { return }
            
            let frame = NSRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: width, height: height))
            
            window.setFrame(frame, display: true)
        }
        
        searchButton.searchField.delegate = self
        searchButton.searchField.tag = 1
        
        guard let splitVC = contentViewController as? WindowSplitVC else { return }
        guard let categoriesVC = splitVC.children[0] as? CategoriesVC else { return }
        guard let itemsAndBasketSplitVC = splitVC.children[1] as? ItemsAndBasketSplitVC else { return }
        guard let itemsVC = itemsAndBasketSplitVC.children[0] as? ItemsVC else { return }
        guard let basketVC = itemsAndBasketSplitVC.children[1] as? BasketVC else { return }
        
        
        splitVC.windowVC = self
        categoriesVC.windowVC = self
        itemsAndBasketSplitVC.windowVC = self
        itemsVC.windowVC = self
        basketVC.windowVC = self
        
        self.windowSplitVC = splitVC
        self.categoriesVC = categoriesVC
        self.itemsAndBasketSplitVC = itemsAndBasketSplitVC
        self.itemsVC = itemsVC
        self.basketVC = basketVC
        
        categoriesVC.refreshSelf()
        itemsVC.refreshSelf()
        basketVC.refreshSelf()
        
        self.inBasketButton.title = appLogic.formattedBasketTotal
    }
    
    
    func refreshAll() {
        guard let splitVC = contentViewController as? WindowSplitVC else { return }
        guard let categoriesVC = splitVC.children[0] as? CategoriesVC else { return }
        guard let itemsAndBasketSplitVC = splitVC.children[1] as? ItemsAndBasketSplitVC else { return }
        guard let itemsVC = itemsAndBasketSplitVC.children[0] as? ItemsVC else { return }
        guard let basketVC = itemsAndBasketSplitVC.children[1] as? BasketVC else { return }
        
        let selectedItems = basketVC.selectedItems
        
        //categoriesVC.categoriesOutline.reloadData()
        itemsVC.refreshSelf()
        basketVC.refreshSelf()
        
        var sequence = Array<Int>()
        
        for (index, item) in appLogic.currentBasket.enumerated() {
            for selectedItem in selectedItems {
                if item.id == selectedItem.id {
                    sequence.append(index)
                    break
                }
            }
        }
        
        let indexSet = IndexSet(sequence)
        
        basketVC.basketTableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        
        self.inBasketButton.title = appLogic.formattedBasketTotal
        
        self.checkTermsAgreementStatus()
    }
    
    
    
    public func checkTermsAgreementStatus() {
        
        guard let basketVC = self.basketVC else { return }
        guard let itemsVC = self.itemsVC else { return }
        
        self.locked = true
        
        if appLogic.userSettings.hasAgreedToTermsAndConditionsV0 == false {
            
            // Alert about T&Cs
            
            let alert = NSAlert()
            
            alert.messageText = "Terms of use"
            alert.informativeText = "Please read and agree with the app conditions to use the app."
            alert.alertStyle = .informational
            alert.addButton(withTitle: "Show T&Cs")
            
            let response: NSApplication.ModalResponse = alert.runModal()
            
            if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
                print("Read")
            }
            
            // Popup:
            
            let height = basketVC.view.frame.height - 120
            let width = basketVC.view.frame.width - 15
            
            let popoverContentController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(K.Popovers.infoVC)) as! InfoViewController
            
            popoverContentController.windowVC = self
            
            let popover = NSPopover()
            
            popover.contentSize = NSSize(width: width, height: height)
            popover.behavior = .semitransient
            popover.animates = true
            popover.contentViewController = popoverContentController
            
            self.activePopover = popover
            popover.show(relativeTo: itemsVC.view.frame, of: itemsVC.view, preferredEdge: .maxX)
            
        } else {
            self.locked = false
            return
        }
        
    }
    
    
}
