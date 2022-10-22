////
////  AppDestructor.swift
////  UoM Chemistry Stores
////
////  Created by Kamil Suwada on 09/05/2022.
////
//
//import Cocoa
//
//
//
//class AppDestructor {
//
//    init() {
//
//        let alert = NSAlert()
//
//        //Ref date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let expDate = dateFormatter.date(from: "08/01/2022")!
//
//        //Get just MM/dd/yyyy from current date
//        let todayString = dateFormatter.string(from: Date())
//        let today = dateFormatter.date(from: todayString)!
//
//        if today > expDate {
//
//            // Initiate destruction via alert:
//
//            alert.messageText = "Testing has finished."
//            alert.informativeText = "Testing of the app has finished and the app will no longer work. Thank you for testing!"
//            alert.alertStyle = .critical
//            alert.addButton(withTitle: "OK")
//
//            let response: NSApplication.ModalResponse = alert.runModal()
//            if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
//                self.destroySelf()
//            }
//
//        } else {
//
//            alert.messageText = "Testing version of the Stores App"
//            alert.informativeText = "Thank you for testing! Please contact: kamilsuwada@icloud.com and UoM Chemistry H&S office for feedback."
//            alert.alertStyle = .informational
//            alert.addButton(withTitle: "OK")
//
//            let response: NSApplication.ModalResponse = alert.runModal()
//            if (response == NSApplication.ModalResponse.alertFirstButtonReturn) { return }
//        }
//    }
//
//
//    private func destroySelf() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            exit(-1)
//        }
//    }
//
//}
