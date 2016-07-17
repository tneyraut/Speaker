//
//  MainTableViewController.swift
//  Speaker
//
//  Created by Thomas Mac on 24/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit
import AVFoundation
import WatchConnectivity
import MediaPlayer

class MainTableViewController: UITableViewController, WCSessionDelegate {
    
    private let sauvegarde = NSUserDefaults()
    
    private let languagesArray: NSArray = ["Français", "Français Canadien", "English-GB", "English-USA", "Deutsch", "Italiano", "Español", "Hrvatski", "Svenska"]
    
    private let referenceLanguageArray: NSArray = ["fr-FR", "fr-CA", "en-GB", "en-US", "de-DE", "it-IT", "es-ES", "cs-CZ", "sv-SE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (!self.sauvegarde.boolForKey("init"))
        {
            self.sauvegarde.setBool(true, forKey:"init")
            self.sauvegarde.setObject(self.languagesArray[0], forKey:"language")
            self.sauvegarde.synchronize()
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.registerClass(TableViewCellTextField.classForCoder(), forCellReuseIdentifier:"cellTextField")
        //self.tableView.registerClass(TableViewCellWithTwoButtons.classForCoder(), forCellReuseIdentifier:"cellButton")
        self.tableView.registerClass(TableViewCellWithThreeButtons.classForCoder(), forCellReuseIdentifier:"cellButton")
        
        self.title = "Speaker"
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let addFavorisButton = UIBarButtonItem(title:"+", style:UIBarButtonItemStyle.Done, target:self, action:#selector(self.addFavorisButtonActionListener))
        addFavorisButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:30.0)!], forState:UIControlState.Normal)
        
        self.navigationItem.rightBarButtonItem = addFavorisButton
        
        let languageButton = UIBarButtonItem(title:self.sauvegarde.stringForKey("language")!, style:.Done, target:self, action:#selector(self.languageButtonActionListener))
        languageButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:15.0)!], forState:UIControlState.Normal)
        
        self.navigationItem.leftBarButtonItem = languageButton
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        if (WCSession.defaultSession().reachable) {
            //This means the companion app is reachable
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.sendData()
        
        self.tableView.reloadData()
        
        super.viewDidAppear(animated)
    }
    
    @objc private func languageButtonActionListener()
    {
        let alertController = UIAlertController(title:"Languages", message:"Choose a language", preferredStyle:.ActionSheet)
        
        var i = 0
        while (i < self.languagesArray.count)
        {
            let s = self.languagesArray[i]
            let alertAction = UIAlertAction(title:s as? String, style:.Default) { (_) in
                self.sauvegarde.setObject(s, forKey:"language")
                self.sauvegarde.synchronize()
                
                let shadow = NSShadow()
                shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
                shadow.shadowOffset = CGSizeMake(0, 1)
                
                let languageButton = UIBarButtonItem(title:self.sauvegarde.stringForKey("language")!, style:.Done, target:self, action:#selector(self.languageButtonActionListener))
                languageButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:15.0)!], forState:UIControlState.Normal)
                
                self.navigationItem.leftBarButtonItem = languageButton
                
                self.sendData()
            }
            alertController.addAction(alertAction)
            i += 1
        }
        let alertActionCancel = UIAlertAction(title:"Cancel", style:.Default) { (_) in }
        
        alertController.addAction(alertActionCancel)
        
        self.presentViewController(alertController, animated:true, completion:nil)
    }
    
    @objc private func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    internal func getNumberOfFavoris() -> Int
    {
        return self.sauvegarde.integerForKey("NumberOfFavoris")
    }
    
    private func addTextField(textField: UITextField!){
        textField.placeholder = "texte à dire"
    }
    
    internal func removeFavoris(indice: Int)
    {
        var i = indice
        while (i < self.getNumberOfFavoris())
        {
            self.sauvegarde.setObject(self.sauvegarde.objectForKey("Favoris" + String(indice + 1)), forKey:"Favoris" + String(indice))
            i += 1
        }
        self.sauvegarde.removeObjectForKey("Favoris" + String(self.getNumberOfFavoris()))
        self.sauvegarde.setInteger(self.getNumberOfFavoris() - 1, forKey:"NumberOfFavoris")
        self.sauvegarde.synchronize()
        
        self.sendData()
        self.tableView.reloadData()
    }
    
    @objc private func addFavorisButtonActionListener()
    {
        let alertController = UIAlertController(title:"Ajout d'un favoris", message:"Entrez le texte que vous souhaitez en favoris.", preferredStyle:UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler(self.addTextField)
        
        let alertActionOne = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default) { (_) in
            if (alertController.textFields![0].text != "")
            {
                self.sauvegarde.setInteger(self.sauvegarde.integerForKey("NumberOfFavoris") + 1, forKey:"NumberOfFavoris")
                self.sauvegarde.setObject(alertController.textFields![0].text, forKey:"Favoris" + String(self.sauvegarde.integerForKey("NumberOfFavoris")))
                self.sauvegarde.synchronize()
                
                self.sendData()
                self.tableView.reloadData()
            }
        }
        
        let alertActionTwo = UIAlertAction(title:"Annuler", style:UIAlertActionStyle.Default) { (_) in }
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        
        self.presentViewController(alertController, animated:true, completion:nil)
    }
    
    internal func speak(toSay: String)
    {
        (MPVolumeView().subviews.filter{ NSStringFromClass($0.classForCoder) == "MPVolumeSlider" }.first as? UISlider)?.setValue(1, animated:false)
        
        let sp = AVSpeechUtterance(string:toSay)
        let a = AVSpeechSynthesizer()
        
        sp.rate = 0.53
        sp.pitchMultiplier = 1
        sp.voice = AVSpeechSynthesisVoice(language:self.getLanguage())
        
        a.speakUtterance(sp)
        
        self.tableView.reloadData()
    }
    
    private func getLanguage() -> String
    {
        var i = 0
        while (i < self.languagesArray.count)
        {
            if (self.languagesArray[i] as? String == self.sauvegarde.stringForKey("language"))
            {
                return self.referenceLanguageArray[i] as! String
            }
            i += 1
        }
        return "fr-FR"
    }
    
    private func sendData()
    {
        let dictionnaire = NSMutableDictionary()
        
        var i = 0
        while (i < self.getNumberOfFavoris())
        {
            dictionnaire.setObject(self.sauvegarde.stringForKey("Favoris" + String(i + 1))!, forKey:String(i))
            i += 1
        }
        dictionnaire.setObject(self.sauvegarde.stringForKey("language")!, forKey:"language")
        
        let data = NSDictionary(dictionary:dictionnaire)
        
        WCSession.defaultSession().sendMessage(data as! [String : AnyObject], replyHandler: { (_: [String : AnyObject]) -> Void in }, errorHandler: { (NSError) -> Void in })
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        if (message["languageRequest"] as! String == "true")
        {
            self.sauvegarde.setObject(message["data"] as! String, forKey:"language")
            self.sauvegarde.synchronize()
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
            shadow.shadowOffset = CGSizeMake(0, 1)
            
            let languageButton = UIBarButtonItem(title:self.sauvegarde.stringForKey("language")!, style:.Done, target:self, action:#selector(self.languageButtonActionListener))
            languageButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:15.0)!], forState:UIControlState.Normal)
            
            self.navigationItem.leftBarButtonItem = languageButton
            return
        }
        if (message["data"] as! String == "getData")
        {
            self.sendData()
            return
        }
        self.speak(message["data"] as! String)
    }
    
    internal func moveItemAtIndexToIndice(index: Int, indice: Int)
    {
        let item = self.sauvegarde.stringForKey("Favoris" + String(index))
        
        self.sauvegarde.setObject(self.sauvegarde.stringForKey("Favoris" + String(indice)), forKey:"Favoris" + String(index))
        self.sauvegarde.setObject(item, forKey:"Favoris" + String(indice))
        
        self.sauvegarde.synchronize()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.getNumberOfFavoris() + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cellTextField", forIndexPath: indexPath) as! TableViewCellTextField
            
            cell.textField.placeholder = "texte à dire"
            
            cell.textField.textAlignment = .Center
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.mainTableViewController = self
            
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cellButton", forIndexPath: indexPath) as! TableViewCellWithThreeButtons

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.mainTableViewController = self
        
        cell.textLabel?.text = self.sauvegarde.stringForKey("Favoris" + String(indexPath.row))
        
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        
        cell.indice = indexPath.row
        
        return cell
    }

}
