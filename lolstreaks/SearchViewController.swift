//
//  SearchViewController.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/2/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var regionButtonWidth: NSLayoutConstraint!
    var region = ""
    
    @IBOutlet weak var logoConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var regionButtonLabel: UIButton!
    @IBOutlet weak var searchButtonLabel: UIButton!
    @IBAction func regionButtonTapped(sender: AnyObject) {
        let regionAlert = UIAlertController(title: "Select a Region", message: "", preferredStyle: .ActionSheet)
        let na = UIAlertAction(title: "North America", style: .Default, handler: { (_) -> Void in
            self.region = "na"
            self.regionButtonLabel.setTitle("  North America:", forState: .Normal)
            self.regionButtonWidth.constant = 121
        })
        let br = UIAlertAction(title: "Brazil", style: .Default, handler: { (_) -> Void in
            self.region = "br"
            self.regionButtonLabel.setTitle("  Brazil:", forState: .Normal)
            self.regionButtonWidth.constant = 59
        })
        let lan = UIAlertAction(title: "Latin America North", style: .Default, handler: { (_) -> Void in
            self.region = "lan"
            self.regionButtonLabel.setTitle("  Latin America North:", forState: .Normal)
            self.regionButtonWidth.constant = 158
        })
        let las = UIAlertAction(title: "Latin America South", style: .Default, handler: { (_) -> Void in
            self.region = "las"
            self.regionButtonLabel.setTitle("  Latin America South:", forState: .Normal)
            self.regionButtonWidth.constant = 160
        })
        let oce = UIAlertAction(title: "Oceania", style: .Default, handler: { (_) -> Void in
            self.region = "oce"
            self.regionButtonLabel.setTitle("  Oceania:", forState: .Normal)
            self.regionButtonWidth.constant = 77
        })
        let euw = UIAlertAction(title: "EU West", style: .Default, handler: { (_) -> Void in
            self.region = "euw"
            self.regionButtonLabel.setTitle("  EU West:", forState: .Normal)
            self.regionButtonWidth.constant = 79
        })
        let eune = UIAlertAction(title: "EU Nordic & East", style: .Default, handler: { (_) -> Void in
            self.region = "eune"
            self.regionButtonLabel.setTitle("  EU Nordic & East:", forState: .Normal)
            self.regionButtonWidth.constant = 138
        })
        let tr = UIAlertAction(title: "Turkey", style: .Default, handler: { (_) -> Void in
            self.region = "tr"
            self.regionButtonLabel.setTitle("  Turkey:", forState: .Normal)
            self.regionButtonWidth.constant = 68
        })
        let ru = UIAlertAction(title: "Russia", style: .Default, handler: { (_) -> Void in
            self.region = "ru"
            self.regionButtonLabel.setTitle("  Russia:", forState: .Normal)
            self.regionButtonWidth.constant = 65
        })
        let kr = UIAlertAction(title: "Korea", style: .Default, handler: { (_) -> Void in
            self.region = "kr"
            self.regionButtonLabel.setTitle("  Korea:", forState: .Normal)
            self.regionButtonWidth.constant = 61
        })
        let jp = UIAlertAction(title: "Japan", style: .Default) { (_) -> Void in
            self.region = "jp"
            self.regionButtonLabel.setTitle("  Japan:", forState: .Normal)
            self.regionButtonWidth.constant = 62
        }
       
        regionAlert.addAction(na)
        regionAlert.addAction(br)
        regionAlert.addAction(lan)
        regionAlert.addAction(las)
        regionAlert.addAction(oce)
        regionAlert.addAction(euw)
        regionAlert.addAction(eune)
        regionAlert.addAction(tr)
        regionAlert.addAction(ru)
        regionAlert.addAction(kr)
        regionAlert.addAction(jp)
        
        regionAlert.popoverPresentationController?.sourceView = view
        regionAlert.popoverPresentationController?.sourceRect = sender.frame
        presentViewController(regionAlert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        usernameTextField.resignFirstResponder()
        
        self.regionButtonLabel.enabled = false
        self.searchButtonLabel.enabled = false
        self.usernameTextField.enabled = false
        self.searchButtonLabel.backgroundColor = UIColor(red: 26/255, green: 65/255, blue: 121/255, alpha: 0.40)
        self.searchButtonLabel.setTitle("Searching...", forState: .Normal)
        
        if Reachability.isConnectedToNetwork() == false {
            print("Internet connection FAILED")
            let noInternetAlert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
            noInternetAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(noInternetAlert, animated: true, completion: nil)
            
            self.regionButtonLabel.enabled = true
            self.searchButtonLabel.enabled = true
            self.usernameTextField.enabled = true
            self.searchButtonLabel.backgroundColor = UIColor(red: 26/255, green: 65/255, blue: 121/255, alpha: 1.0)
            self.searchButtonLabel.setTitle("Search", forState: .Normal)
            
        } else if region == "" {
            let noRegionAlert = UIAlertController(title: "No Region Selected", message: "Please press the Region button and select a region.", preferredStyle: .Alert)
            noRegionAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(noRegionAlert, animated: true, completion: nil)
            
            self.regionButtonLabel.enabled = true
            self.searchButtonLabel.enabled = true
            self.usernameTextField.enabled = true
            self.searchButtonLabel.backgroundColor = UIColor(red: 26/255, green: 65/255, blue: 121/255, alpha: 1.0)
            self.searchButtonLabel.setTitle("Search", forState: .Normal)
            
        } else if usernameTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "") == "" {
            let noNameAlert = UIAlertController(title: "No Name Entered", message: "Please enter a valid summoner name for search.", preferredStyle: .Alert)
            noNameAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(noNameAlert, animated: true, completion: nil)
            
            self.regionButtonLabel.enabled = true
            self.searchButtonLabel.enabled = true
            self.usernameTextField.enabled = true
            self.searchButtonLabel.backgroundColor = UIColor(red: 26/255, green: 65/255, blue: 121/255, alpha: 1.0)
            self.searchButtonLabel.setTitle("Search", forState: .Normal)
            
        } else {
            FireBaseController.dataAtEndPoint("apiKey") { (data) -> Void in
                if let key = data as? String {
                    CurrentGameController.sharedInstance.ApiKey = key
                    //1
                    PlayerController.sharedInstance.searchForPlayer(self.region, playerName: self.usernameTextField.text!) { (success) -> Void in
                        if success {
                            //4 calls
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.statusLabel.text = "player found, searching for current game..."
                            })
                            CurrentGameController.sharedInstance.searchForCurrentGame(self.region, summonerId: PlayerController.sharedInstance.currentPlayer.summonerID, completion: { (success) -> Void in
                                if success {
                                    if CurrentGameController.sharedInstance.currentGame.gameId != 0 && CurrentGameController.sharedInstance.currentGame.gameId != -1 {
                                        print("current game success")
                                        
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.statusLabel.text = "current game found, please wait..."
                                        })
                                        NSThread.sleepForTimeInterval(4)
                                        //14 requests
                                        let allIds = CurrentGameController.sharedInstance.allIds
                                        var count = 0
                                        for id in allIds {
                                            
                                        
                                            NSThread.sleepForTimeInterval(1)
                                            PastGameController.sharedInstance.searchForTenRecentGames(self.region, summonerId: id, completion: { (success) -> Void in
                                                if success {
                                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                        self.statusLabel.text = "\(id): game history added"
                                                    })
                                                    print("past games appended to Player: \(id)")
                                                    count += 1
                                                    if count == CurrentGameController.sharedInstance.allParticipants.count {
                                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                            self.performSegueWithIdentifier("searchToTeams", sender: self)
                                                            
                                                            self.regionButtonLabel.enabled = true
                                                            self.searchButtonLabel.enabled = true
                                                            self.usernameTextField.enabled = true
                                                            self.searchButtonLabel.backgroundColor = UIColor(red: 26/255, green: 65/255, blue: 121/255, alpha: 1.0)
                                                            self.searchButtonLabel.setTitle("Search", forState: .Normal)
                                                        })
                                                    }
                                                }
                                            })
                                        }
                                    }
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.statusLabel.text = " "
                                        print("try again")
                                        let noGameAlert = UIAlertController(title: "No game", message: "Player is currently not in a game", preferredStyle: .Alert)
                                        noGameAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                                            self.regionButtonLabel.enabled = true
                                            self.searchButtonLabel.enabled = true
                                            self.usernameTextField.enabled = true
                                            self.searchButtonLabel.backgroundColor = UIColor(red: 26/255, green: 65/255, blue: 121/255, alpha: 1.0)
                                            self.searchButtonLabel.setTitle("Search", forState: .Normal)
                                        }))
                                        noGameAlert.addAction(UIAlertAction(title: "Go to profile", style: .Default, handler: { (action) -> Void in
                                            CurrentGameController.sharedInstance.makeFakeGame(self.region, completion: { (success) in
                                                if success {
                                                    dispatch_async(dispatch_get_main_queue(), { 
                                                        self.statusLabel.text = "Please wait..."
                                                        PastGameController.sharedInstance.searchForTenRecentGames(self.region, summonerId: PlayerController.sharedInstance.currentPlayer.summonerID, completion: { (success) in
                                                            if success {
                                                                dispatch_async(dispatch_get_main_queue(), {
                                                                    self.performSegueWithIdentifier("alertToProfile", sender: self)
                                                                    self.regionButtonLabel.enabled = true
                                                                    self.searchButtonLabel.enabled = true
                                                                    self.usernameTextField.enabled = true
                                                                    self.searchButtonLabel.backgroundColor = UIColor(red: 26/255, green: 65/255, blue: 121/255, alpha: 1.0)
                                                                    self.searchButtonLabel.setTitle("Search", forState: .Normal)
                                                                })
                                                            }
                                                        })
                                                    })
                                                    
                                                }
                                            })
                                        }))
                                        self.presentViewController(noGameAlert, animated: true, completion: nil)
                                        
                                    })
                                    
                                }
                                
                            })
                            
                        } else {
                            print("error")
                            //alertcontroller
                            let noPlayerAlert = UIAlertController(title: "No player", message: "No player found by that name", preferredStyle:  .Alert)
                            noPlayerAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                            self.presentViewController(noPlayerAlert, animated: true, completion: nil)
                            self.regionButtonLabel.enabled = true
                            self.searchButtonLabel.enabled = true
                            self.usernameTextField.enabled = true
                            self.searchButtonLabel.backgroundColor = UIColor(red: 26/255, green: 65/255, blue: 121/255, alpha: 1.0)
                            self.searchButtonLabel.setTitle("Search", forState: .Normal)
                        }
                    }
                } else {
                    print("Firebase connection FAILED")
                    let noInternetAlert = UIAlertController(title: "No Server Connection", message: "Servers are currently down or busy, please try again later.", preferredStyle: .Alert)
                    noInternetAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(noInternetAlert, animated: true, completion: nil)
                    self.regionButtonLabel.enabled = true
                    self.searchButtonLabel.enabled = true
                    self.usernameTextField.enabled = true
                    self.searchButtonLabel.backgroundColor = UIColor(red: 26/255, green: 65/255, blue: 121/255, alpha: 1.0)
                    self.searchButtonLabel.setTitle("Search", forState: .Normal)
                }
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoConstraint.constant = view.frame.size.height / 8
        regionButtonLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        regionButtonLabel.layer.cornerRadius = 5
        
        searchButtonLabel.backgroundColor = UIColor(red: 26/255, green: 65/255, blue: 121/255, alpha: 1.0)
        searchButtonLabel.layer.cornerRadius = 5

        usernameTextField.layer.cornerRadius = 5
        usernameTextField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let noInternetAlert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
            noInternetAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(noInternetAlert, animated: true, completion: nil)
        }
        statusLabel.text = ""
        
        usernameTextField.delegate = self
        
    }
    
    func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "alertToProfile" {
            
            if let detailViewController = segue.destinationViewController as? PlayerDetailViewController {
                _ = detailViewController.view
                
                let player = CurrentGameController.sharedInstance.allteams[0][0]
                detailViewController.updateWithPlayer(player)
                
            }
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        statusLabel.text = ""
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        usernameTextField.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
