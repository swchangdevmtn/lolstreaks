//
//  SearchViewController.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/2/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var regionButtonWidth: NSLayoutConstraint!
    var bgView: UIImageView!
    var region = ""
    var regionTitle = ""
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var regionButtonLabel: UIButton!
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
        presentViewController(regionAlert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        usernameTextField.resignFirstResponder()
        if Reachability.isConnectedToNetwork() == false {
            print("Internet connection FAILED")
            let noInternetAlert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
            noInternetAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(noInternetAlert, animated: true, completion: nil)
        } else if region == "" {
            let noRegionAlert = UIAlertController(title: "No Region Selected", message: "Please press the Region button and select a region.", preferredStyle: .Alert)
            noRegionAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(noRegionAlert, animated: true, completion: nil)
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
                                        // MARK: Sleep
                                        NSThread.sleepForTimeInterval(3)
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.statusLabel.text = "current game found, please wait..."
                                        })
                                        //14 requests
                                        let allIds = CurrentGameController.sharedInstance.allIds
                                        var count = 0
                                        for id in allIds {
                                            // MARK: sleep 2
                                            NSThread.sleepForTimeInterval(1)
                                            PastGameController.sharedInstance.searchForTenRecentGames(self.region, summonerId: id, completion: { (success) -> Void in
                                                if success {
                                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                        self.statusLabel.text = "\(id): game history added"
                                                    })
                                                    print("past games appended to Player: \(id)")
                                                    count++
                                                    if count == CurrentGameController.sharedInstance.allParticipants.count {
                                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                            self.performSegueWithIdentifier("searchToTeams", sender: self)
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
                                        noGameAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                                        noGameAlert.addAction(UIAlertAction(title: "Go to profile", style: .Default, handler: { (action) -> Void in
                                            self.performSegueWithIdentifier("alertToProfile", sender: self)
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
                        }
                    }
                } else {
                    print("Firebase connection FAILED")
                    let noInternetAlert = UIAlertController(title: "No Server Connection", message: "Servers are currently down or busy, please try again later.", preferredStyle: .Alert)
                    noInternetAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(noInternetAlert, animated: true, completion: nil)
                }
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regionButtonLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        regionButtonLabel.layer.cornerRadius = 5
//        usernameTextField.layer.borderWidth = 1
//        usernameTextField.layer.borderColor = UIColor.whiteColor().CGColor
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
        statusLabel.text = " "
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        statusLabel.text = " "
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
