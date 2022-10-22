//
//  AppDelegate.swift
//  UoM Chemistry Stores
//
//  Created by Kamil Suwada on 04/05/2022.
//

import Cocoa
import RealmSwift


@main
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            let _ = AppDestructor()
//        }
        
    }

    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    

}

