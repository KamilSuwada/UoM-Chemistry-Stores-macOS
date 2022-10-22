//
//  InfoViewController.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 07/05/2022.
//

import Cocoa

class InfoViewController: NSViewController {
    
    
    @IBOutlet weak var infoTextView: NSTextView!
    @IBOutlet weak var agreeButton: NSButton!
    @IBOutlet weak var disagreeButton: NSButton!
    
    
    var windowVC: WindowVC?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoTextView.string = K.HelpText.v0
    }
    
    
    @IBAction func agreeButtonTapped(_ sender: NSButton) {
        guard let windowVC = windowVC else { return }
        guard let popover = windowVC.activePopover else { return }
        
        do {
            try windowVC.appLogic.realm.write({
                windowVC.appLogic.userSettings.hasAgreedToTermsAndConditionsV0 = true
            })
        } catch {
            print(error.localizedDescription)
        }
        
        popover.close()
    }
    
    
    @IBAction func disagreeButtonTapped(_ sender: NSButton) {
        guard let windowVC = windowVC else { return }
        guard let popover = windowVC.activePopover else { return }
        
        do {
            try windowVC.appLogic.realm.write({
                windowVC.appLogic.userSettings.hasAgreedToTermsAndConditionsV0 = false
            })
        } catch {
            print(error.localizedDescription)
        }
        
        exit(10)
    }
    
    
}
