//
//  CurrentGameViewController.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/2/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import UIKit

class CurrentGameViewController: UIViewController {

    
    @IBOutlet weak var teamCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do the recent game search here
        
        // array of Ids
        // 13 calls
        
//        let allIds = CurrentGameController.sharedInstance.allIds
//        NSThread.sleepForTimeInterval(3)
//        for id in allIds {
//            NSThread.sleepForTimeInterval(0.7)
//            PastGameController.sharedInstance.searchForTenRecentGames(CurrentGameController.sharedInstance.savedRegion, summonerId: id) { (success) -> Void in
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    print("person: \(CurrentGameController.sharedInstance.allteams[0][0].summonerId)")
//                    print("person's last game: \(CurrentGameController.sharedInstance.allteams[0][0].pastGames![0].gameId)")
//                })
//            }
//        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongGesture:")
        self.teamCollectionView.addGestureRecognizer(longPressGesture)
        
        
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.teamCollectionView.indexPathForItemAtPoint(gesture.locationInView(self.teamCollectionView)) else {
                break
            }
            teamCollectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            teamCollectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            teamCollectionView.endInteractiveMovement()
        default:
            teamCollectionView.cancelInteractiveMovement()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    

}

extension CurrentGameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let bgView = UIView()
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("teamCell", forIndexPath: indexPath) as! CurrentGameTeamCollectionViewCell
        cell.teamLabel.text = TeamController.sharedInstance.teams[indexPath.row]
        if indexPath.row == 0 {
            cell.teamLabel.textColor = UIColor(red: 77/255, green: 18/255, blue: 14/255, alpha: 1)
            bgView.backgroundColor = UIColor(patternImage: UIImage(named: "redside5.png")!)
            bgView.contentMode = .ScaleAspectFit
            cell.backgroundView = bgView
        }
        if indexPath.row == 1 {
            cell.teamLabel.textColor = UIColor(red: 20/255, green: 37/255, blue: 93/255, alpha: 1)
            bgView.backgroundColor = UIColor(patternImage: UIImage(named: "blueside5.png")!)
            bgView.contentMode = .ScaleAspectFit
            cell.backgroundView = bgView
        }
        cell.turretImage.image = UIImage(named: TeamController.sharedInstance.turrets[indexPath.row])
        cell.parentIndex = indexPath.item
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentGameController.sharedInstance.allteams.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfCells = CGFloat(CurrentGameController.sharedInstance.allteams[indexPath.row].count)
        return CGSize(width: self.view.frame.size.width-50, height: 42*numberOfCells+41)
    }
}
