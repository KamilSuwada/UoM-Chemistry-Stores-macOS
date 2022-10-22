//
//  SettingsCellView.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 09/05/2022.
//

import Cocoa

class SettingsCellView: NSTableCellView {
    
    
    @IBOutlet weak var cellLabel: NSTextField!
    @IBOutlet weak var cellSwitch: NSSwitch!
    
    
    var windowVC: WindowVC?
    var delegate: SettingsViewController?
    var row: Int?
    var setting: Setting?
    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    
    @IBAction func cellSwitchStateDidChange(_ sender: NSSwitch) {
        self.switchValueDidChange(switch: sender)
    }
    
    
    
}




// MARK: Switch handling:
extension SettingsCellView {
    
    
    func switchValueDidChange(switch sw: NSSwitch) {
        if sw.state.rawValue == 0 {
            self.setting?.changeSettingState(to: false)
        } else {
            self.setting?.changeSettingState(to: true)
        }
        
        guard let delegate = self.delegate else { fatalError("Could not get hold of the delegate form Settings Cell!") }
        guard let row = self.row else { fatalError("Could not get hold of the row form Settings Cell!") }
        guard let setting = self.setting else { fatalError("Could not get hold of the setting form Settings Cell!") }
        
        delegate.settingsChangeEvent(forCellRow: row, newSetting: setting)
    }
    
    
}




// MARK: setUp:
extension SettingsCellView {
    
    
    func setUp() {
        guard let _ = self.windowVC else { fatalError("Cannot get windowVC in Settings Cell") }
        guard let delegate = self.delegate else { fatalError("Cannot get delegate in Settings Cell") }
        guard let setting = self.setting else { fatalError("Cannot get setting in Settings Cell") }
        guard let row = self.row else { fatalError("Cannot get row in Settings Cell") }
        
        self.delegate = delegate
        self.setting = setting
        self.row = row
        
        cellLabel.stringValue = setting.label
        
        if setting.state == true {
            self.cellSwitch.state = .on
        } else {
            self.cellSwitch.state = .off
        }
    }
    
    
}
