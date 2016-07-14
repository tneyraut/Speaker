//
//  InterfaceController.swift
//  Speak Extension
//
//  Created by Thomas Mac on 08/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet private var table: WKInterfaceTable!
    
    private let sauvegarde = NSUserDefaults()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.setTitle("Main Menu")
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        if (WCSession.defaultSession().reachable) {
            //This means the companion app is reachable
        }
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.setTable()
        
        let data = ["languageRequest" : "false", "data" : "getData"]
        
        WCSession.defaultSession().sendMessage(data, replyHandler: { (_: [String : AnyObject]) -> Void in }, errorHandler: { (NSError) -> Void in })
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func setTable()
    {
        self.table.setNumberOfRows(self.sauvegarde.integerForKey("numberOfItems") + 2, withRowType:"row")
        
        let firstRow = self.table.rowControllerAtIndex(0) as! TextRow
        firstRow.label.setText("Refresh")
        
        let secondRow = self.table.rowControllerAtIndex(1) as! TextRow
        secondRow.label.setText(self.sauvegarde.stringForKey("language"))
        
        var i = 0
        while (i < self.sauvegarde.integerForKey("numberOfItems"))
        {
            let row = self.table.rowControllerAtIndex(i + 2) as! TextRow
            row.label.setText(self.sauvegarde.stringForKey("titleOfItemN°" + String(i)))
            i += 1
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        self.sauvegarde.removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        
        self.sauvegarde.setObject(message["language"], forKey:"language")
        
        self.sauvegarde.setInteger(message.count - 1, forKey:"numberOfItems")
        
        var i = 0
        while (i < message.count - 1)
        {
            self.sauvegarde.setObject(message[String(i)], forKey:"titleOfItemN°" + String(i))
            
            i += 1
        }
        self.sauvegarde.synchronize()
        self.setTable()
    }
    
    internal func setLanguage(language: String)
    {
        self.sauvegarde.setObject(language, forKey:"language")
        self.sauvegarde.synchronize()
        self.setTable()
        
        let data = ["languageRequest" : "true", "data" : language]
        
        WCSession.defaultSession().sendMessage(data, replyHandler: { (_: [String : AnyObject]) -> Void in }, errorHandler: { (NSError) -> Void in })
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        if (rowIndex == 0)
        {
            let data = ["languageRequest" : "false", "data" : "getData"]
            
            WCSession.defaultSession().sendMessage(data, replyHandler: { (_: [String : AnyObject]) -> Void in }, errorHandler: { (NSError) -> Void in })
            
            return
        }
        else if (rowIndex == 1)
        {
            self.presentControllerWithName("languageInterface", context:["interfaceController" : self])
            return
        }
        let s : String = self.sauvegarde.stringForKey("titleOfItemN°" + String(rowIndex - 2))!
        
        let data = ["languageRequest" : "false", "data" : s]
        
        WCSession.defaultSession().sendMessage(data, replyHandler: { (_: [String : AnyObject]) -> Void in }, errorHandler: { (NSError) -> Void in })
    }

}
