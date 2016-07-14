//
//  LanguageInterfaceController.swift
//  Speaker
//
//  Created by Thomas Mac on 12/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import WatchKit
import Foundation


class LanguageInterfaceController: WKInterfaceController {

    @IBOutlet private var table: WKInterfaceTable!
    
    private var interfaceController = InterfaceController()
    
    private let languagesArray: NSArray = ["Français", "Français Canadien", "English-GB", "English-USA", "Deutsch", "Italiano", "Español", "Hrvatski", "Svenska"]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.table.setNumberOfRows(self.languagesArray.count, withRowType:"row")
        
        var i = 0
        while (i < self.languagesArray.count)
        {
            let row = self.table.rowControllerAtIndex(i) as! TextRow
            row.label.setText(String(self.languagesArray[i]))
            i += 1
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.interfaceController.setLanguage(self.languagesArray[rowIndex] as! String)
        self.dismissController()
    }

}
