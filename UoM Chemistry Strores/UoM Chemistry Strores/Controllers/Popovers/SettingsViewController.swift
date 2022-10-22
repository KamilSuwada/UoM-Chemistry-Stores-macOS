//
//  SettingsViewController.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 09/05/2022.
//

import Cocoa




class SettingsViewController: NSViewController {
    
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    var windowVC: WindowVC?
    var userSettings: UserSettings?
    var settings = Array<Setting>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    
    
    
    
}




// MARK: NSTableViewDelegate and DataSource conformance:
extension SettingsViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.settings.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let windowVC = self.windowVC else { fatalError("Could not get windowVC in Settings viewFor row!") }
        guard let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? SettingsCellView else { print("Returned nil rather than SettingsCellView"); return nil }
        
        cellView.windowVC = windowVC
        cellView.setting = self.settings[row]
        cellView.row = row
        cellView.delegate = self
        
        cellView.setUp()
        
        return cellView
    }
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        tableView.deselectRow(tableView.selectedRow)
    }
    
    
}




// MARK: setUp:
extension SettingsViewController {
    
    
    private func setUp() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let windowVC = self.windowVC else { fatalError("Could not get windowVC in Settings setUp!") }
        self.userSettings = windowVC.appLogic.userSettings
        guard let userSettings = self.userSettings else { fatalError("Could not get user settings in Settings setUp!") }
        
        
        let orderEmailOrList = Setting(type: .orderEmailOrList, label: "Prefer list to email orders:", description: "Dictates if the order will be presented as a generated email or simple list of items:", state: userSettings.prefersOrdersAsLists)
        
        self.settings.append(orderEmailOrList)
        
        tableView.reloadData()
    }
    
    
}




// MARK: Settings Cell delegate:
extension SettingsViewController {
    
    
    func settingsChangeEvent(forCellRow row: Int, newSetting setting: Setting) {
        self.settings[row] = setting
        self.saveCurrentState()
    }
    
    
    private func saveCurrentState() {
        guard let userSettings = self.userSettings else { fatalError("Could not get user settings in Settings setUp!") }
        
        for setting in self.settings {
            
            switch setting.type {
                
            case .orderEmailOrList:
                if setting.state != userSettings.prefersOrdersAsLists {
                    self.realmWrite {
                        userSettings.prefersOrdersAsLists = setting.state
                    }
                }
                
                
            }
            
        }
    }
    
    
    private func realmWrite(writeTransaction transaction: () -> ()) {
        guard let realm = windowVC?.appLogic.realm else { fatalError("Cannot access realm from SettingsVC") }
        
        do {
            try realm.write({
                transaction()
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}




// MARK: SettingTypes enum:
enum SettingType {
    case orderEmailOrList
}




// MARK: Setting struct:
struct Setting {
    
    let type: SettingType
    let label: String
    let description: String
    
    var state: Bool
    
    
    mutating func changeSettingState(to state: Bool) {
        self.state = state
    }
    
}
