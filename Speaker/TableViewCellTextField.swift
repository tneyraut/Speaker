//
//  TableViewCellTextField.swift
//  CellLibrary
//
//  Created by Thomas Mac on 06/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class TableViewCellTextField: UITableViewCell {

    internal let textField = UITextField()
    internal let button = UIButton(type: UIButtonType.RoundedRect)
    
    internal var mainTableViewController = MainTableViewController()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let decalage = CGFloat(10.0)
        
        self.button.frame = CGRectMake(self.frame.size.width - decalage - self.frame.size.height, 0.0, self.frame.size.height, self.frame.size.height)
        
        self.button.setBackgroundImage(UIImage(named:"iconSpeak.png"), forState:.Normal)
        
        self.button.addTarget(self, action:#selector(self.buttonActionListener), forControlEvents:UIControlEvents.TouchUpInside)
        
        self.imageView?.hidden = true
        
        self.textLabel?.hidden = true
        
        self.textField.frame = CGRectMake(decalage, (self.frame.size.height - self.textField.frame.size.height) / 2, self.frame.size.width - self.button.frame.size.width - 3 * decalage, 2 * self.frame.size.height / 3)
        
        self.textField.borderStyle = UITextBorderStyle.RoundedRect
        
        self.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        
        self.layer.borderWidth = 2.5
        self.layer.cornerRadius = 7.5
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
        
        self.addSubview(self.textField)
        self.addSubview(self.button)
    }
    
    @objc private func buttonActionListener()
    {
        self.mainTableViewController.speak(self.textField.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
