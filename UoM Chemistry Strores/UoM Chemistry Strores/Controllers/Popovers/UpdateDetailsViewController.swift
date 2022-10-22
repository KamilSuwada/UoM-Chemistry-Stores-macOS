//
//  UpdateDetailsViewController.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 07/05/2022.
//

import Cocoa

class UpdateDetailsViewController: NSViewController {
    
    
    @IBOutlet weak var saveButton: NSButton!
    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var nameTextField: NSTextField!
    
    @IBOutlet weak var labLabel: NSTextField!
    @IBOutlet weak var labTextField: NSTextField!
    
    @IBOutlet weak var chargeAccountLabel: NSTextField!
    @IBOutlet weak var chargeAccountTextField: NSTextField!
    
    @IBOutlet weak var aaCodeLabel: NSTextField!
    @IBOutlet weak var aaCodeTextField: NSTextField!
    
    
    var windowVC: WindowVC?
    var personalData: PersonalData?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let personalData = self.personalData else { return }
                
        if personalData.name != "" {
            nameTextField.stringValue = personalData.name
        }
        
        if personalData.lab != "" {
            labTextField.stringValue = personalData.lab
        }
        
        if personalData.code != "" {
            chargeAccountTextField.stringValue = personalData.code
        }
        
        if personalData.ppeCode != "" {
            aaCodeTextField.stringValue = personalData.ppeCode
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: NSButton) {

        guard nameTextField.stringValue != "", labTextField.stringValue != "", chargeAccountTextField.stringValue != "", aaCodeTextField.stringValue != ""
        else {
            let alert = NSAlert()
            
            alert.messageText = "Incorrect!"
            alert.informativeText = "Please fill in all of the fields to save your data and start ordering. PS, no data is shared outside of the app."
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            
            let response: NSApplication.ModalResponse = alert.runModal()
            if (response == NSApplication.ModalResponse.alertFirstButtonReturn) { return }
            
            return
        }
        
        guard let windowVC = windowVC else { return }
        guard let personalData = windowVC.appLogic.currentPersonalData else { return }
        
        do {
            try windowVC.appLogic.realm.write({
                personalData.name = nameTextField.stringValue
                personalData.lab = labTextField.stringValue
                personalData.code = chargeAccountTextField.stringValue
                personalData.ppeCode = aaCodeTextField.stringValue
            })
        } catch {
            print(error.localizedDescription)
        }
        
        guard let popover = windowVC.activePopover else { return }
        popover.close()
    }
    
    
    
}
