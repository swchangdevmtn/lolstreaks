//
//  SearchViewController.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/2/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var regionTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        //1
        PlayerController.sharedInstance.searchForPlayer(regionTextField.text!, playerName: usernameTextField.text!) { (success) -> Void in
            if success {
                //3
                CurrentGameController.sharedInstance.searchForCurrentGame(self.regionTextField.text!, summonerId: PlayerController.sharedInstance.currentPlayer.summonerID, completion: { (success) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if CurrentGameController.sharedInstance.currentGame.gameId != 0 && CurrentGameController.sharedInstance.currentGame.gameId != -1 {
                            self.performSegueWithIdentifier("searchToCollection", sender: self.self)
                            print("success")
                        } else {
                            print("try again")
                            let noGameAlert = UIAlertController(title: "No game", message: "Player is currently not in a game", preferredStyle: .Alert)
                            noGameAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                            noGameAlert.addAction(UIAlertAction(title: "Go to profile", style: .Default, handler: { (action) -> Void in
                                self.performSegueWithIdentifier("alertToProfile", sender: self)
                            }))
                            self.presentViewController(noGameAlert, animated: true, completion: nil)
                        }
                    })
                })
                
            } else {
                print("error")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
