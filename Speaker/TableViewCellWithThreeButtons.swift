//
//  TableViewCellWithThreeButtons.swift
//  Speaker
//
//  Created by Thomas Mac on 17/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class TableViewCellWithThreeButtons: UITableViewCell {

    internal let buttonOne = UIButton(type: UIButtonType.RoundedRect)
    internal let buttonTwo = UIButton(type: UIButtonType.RoundedRect)
    internal let buttonThree = UIButton(type: UIButtonType.RoundedRect)
    
    internal var mainTableViewController = MainTableViewController()
    
    internal var indice = -1
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let decalage = CGFloat(10.0)
        let size = self.frame.size.height - 2 * decalage - 10.0
        
        self.buttonThree.frame = CGRectMake(self.frame.size.width - decalage - size, (self.frame.size.height - size) / 2, size, size)
        self.buttonThree.titleLabel?.hidden = true
        self.buttonThree.addTarget(self, action:#selector(self.buttonThreeActionListener), forControlEvents:UIControlEvents.TouchUpInside)
        
        self.buttonThree.setBackgroundImage(UIImage(named:"iconSuppr.png"), forState:.Normal)
        
        self.buttonTwo.frame = CGRectMake(self.buttonThree.frame.origin.x - decalage - self.buttonThree.frame.size.width, self.buttonThree.frame.origin.y, self.buttonThree.frame.size.width, self.buttonThree.frame.size.height)
        self.buttonTwo.titleLabel?.hidden = true
        self.buttonTwo.addTarget(self, action:#selector(self.buttonTwoActionListener), forControlEvents:UIControlEvents.TouchUpInside)
        
        self.buttonTwo.setBackgroundImage(UIImage(named:"iconMove.png"), forState:.Normal)
        
        self.buttonOne.frame = CGRectMake(self.buttonTwo.frame.origin.x - decalage - self.buttonTwo.frame.size.width, self.buttonTwo.frame.origin.y, self.buttonTwo.frame.size.width, self.buttonTwo.frame.size.height)
        self.buttonOne.titleLabel?.hidden = true
        self.buttonOne.addTarget(self, action:#selector(self.buttonOneActionListener), forControlEvents:UIControlEvents.TouchUpInside)
        
        self.buttonOne.setBackgroundImage(UIImage(named:"iconSpeak.png"), forState:.Normal)
        
        self.imageView?.hidden = true
        
        self.textLabel?.frame = CGRectMake(decalage, 0.0, self.frame.size.width - 4 * decalage - self.buttonOne.frame.width - self.buttonTwo.frame.width, self.frame.size.height)
        
        self.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        
        self.layer.borderWidth = 2.5
        self.layer.cornerRadius = 7.5
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
        
        self.addSubview(self.buttonOne)
        self.addSubview(self.buttonTwo)
        self.addSubview(self.buttonThree)
    }
    
    @objc private func buttonOneActionListener()
    {
        self.mainTableViewController.speak((self.textLabel?.text)!)
    }
    
    @objc private func buttonTwoActionListener()
    {
        let alertController = UIAlertController(title:"Déplacement de l'item", message:"Rentrez la nouvelle position de l'item (entier de 1 à " + String(self.mainTableViewController.getNumberOfFavoris()) + ")", preferredStyle:.Alert)
        
        alertController.addTextFieldWithConfigurationHandler{ (textField) in
            textField.placeholder = "nouvelle position"
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        
        let alertActionOne = UIAlertAction(title:"Valider", style:.Default) { (_) in
            let textField = alertController.textFields![0]
            if (!textField.hasText() || Int(textField.text!)! < 0 || Int(textField.text!)! > self.mainTableViewController.getNumberOfFavoris())
            {
                self.buttonTwoActionListener()
            }
            self.mainTableViewController.moveItemAtIndexToIndice(self.indice, indice:Int(textField.text!)!)
        }
        let alertActionTwo = UIAlertAction(title:"Annuler", style:.Destructive) { (_) in }
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        
        self.mainTableViewController.presentViewController(alertController, animated:true, completion:nil)
    }
    
    @objc private func buttonThreeActionListener()
    {
        let alertController = UIAlertController(title:"Suppression d'un favoris", message:"Êtes-vous sûr de vouloir supprimer ce favoris ?", preferredStyle:.Alert)
        let alertActionOne = UIAlertAction(title:"Oui", style:.Default) { (_) in self.mainTableViewController.removeFavoris(self.indice) }
        let alertActionTwo = UIAlertAction(title:"Non", style:.Default) { (_) in }
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        
        self.mainTableViewController.presentViewController(alertController, animated:true, completion:nil)
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
