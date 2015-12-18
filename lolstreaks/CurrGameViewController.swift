//
//  CurrGameViewController.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/17/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import UIKit

class CurrGameViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongGesture:")
//        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
//    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
//        
//        switch(gesture.state) {
//            
//        case UIGestureRecognizerState.Began:
//            guard let selectedIndexPath = self.collectionView.indexPathForItemAtPoint(gesture.locationInView(self.collectionView)) else {
//                break
//            }
//            collectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
//        case UIGestureRecognizerState.Changed:
//            collectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
//        case UIGestureRecognizerState.Ended:
//            collectionView.endInteractiveMovement()
//        default:
//            collectionView.cancelInteractiveMovement()
//        }
//    }
    

 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playerCellToDetail" {
            if let detailViewController = segue.destinationViewController as? PlayerDetailViewController {
                _ = detailViewController.view
                
                let cell = sender as? CurrGamePlayerCollectionViewCell
                if let indexPath = collectionView.indexPathForCell(cell!) {
                    let parentIndex = indexPath.section
                    let player = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.row]
                    detailViewController.updateWithPlayer(player)
                }
            }
        }
    }
}

extension CurrGameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

//    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        var parentIndex = -1
//        
//        if sourceIndexPath.section == 0 {
//            parentIndex = 0
//        } else {
//            parentIndex = 1
//        }
//        
//        if sourceIndexPath.section == destinationIndexPath.section {
//            let temp = CurrentGameController.sharedInstance.allteams[parentIndex][sourceIndexPath.row]
//            CurrentGameController.sharedInstance.allteams[parentIndex][sourceIndexPath.row] = CurrentGameController.sharedInstance.allteams[parentIndex][destinationIndexPath.row]
//            CurrentGameController.sharedInstance.allteams[parentIndex][destinationIndexPath.row] = temp
//        } else {
//            CurrentGameController.sharedInstance.allteams[parentIndex][sourceIndexPath.row] = CurrentGameController.sharedInstance.allteams[parentIndex][sourceIndexPath.row]
//            CurrentGameController.sharedInstance.allteams[parentIndex][destinationIndexPath.row] = CurrentGameController.sharedInstance.allteams[parentIndex][destinationIndexPath.row]
//        }
//        
//    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return CurrentGameController.sharedInstance.allteams.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return CurrentGameController.sharedInstance.allteams[0].count
        } else {
            return CurrentGameController.sharedInstance.allteams[1].count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("playerCell", forIndexPath: indexPath) as! CurrGamePlayerCollectionViewCell
        var parentIndex = 0
        
        if indexPath.section == 0 {
            parentIndex = 0
        } else {
            parentIndex = 1
        }
        
        switch
        parentIndex {
        case 0:
            //red
            cell.backgroundColor = UIColor(red: 208/255, green: 127/255, blue: 115/255, alpha: 0.5)
        case 1:
            //blue
            cell.backgroundColor = UIColor(red: 116/255, green: 168/255, blue: 204/255, alpha: 0.5)
        default:
            cell.backgroundColor = UIColor.grayColor()
        }
        
        let borderBottom = CALayer()
        let borderWidth = CGFloat(3.0)
        if parentIndex == 0 {
            borderBottom.borderColor = UIColor(red: 148/255, green: 48/255, blue: 33/255, alpha: 1).CGColor
        }
        if parentIndex == 1 {
            borderBottom.borderColor = UIColor(red: 27/255, green: 91/255, blue: 135/255, alpha: 1).CGColor
        }
        borderBottom.frame = CGRect(x: 0, y: cell.frame.height - 1.0, width: cell.frame.width , height: cell.frame.height - 1.0)
        borderBottom.borderWidth = borderWidth
        cell.layer.addSublayer(borderBottom)
        cell.layer.masksToBounds = true
        
        if let pastGames = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].pastGames as [PastGame]? {
            if let _ = pastGames.first as PastGame? {
                if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA == -100 {
                    if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames == 0 {
                        cell.kdaLabel.text = "-"
                        cell.winrateLabel.text = "-"
                        cell.numberOfGamesLabel.text = "in 0 games"
                    } else {
                        cell.kdaLabel.text = "Perfect KDA!"
                        cell.winrateLabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate!)
                        cell.numberOfGamesLabel.text = String("in \(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames!) games")
                    }
                } else {
                    cell.kdaLabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA!)
                    cell.winrateLabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate!)
                    cell.numberOfGamesLabel.text = String("in \(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames!) games")
                }
            } else {
                cell.kdaLabel.text = "-"
                cell.winrateLabel.text = "-"
                cell.numberOfGamesLabel.text = "in 0 games"
            }
            
        }
        
        let version = CurrentGameController.sharedInstance.ddragonVersion
        let championImage = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].championImg!
        let spell1Image = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].spell1Img!
        let spell2Image = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].spell2Img!
        
        cell.champImg.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/champion/\(championImage)")!)!)
        cell.spell1Img.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell1Image)")!)!)
        cell.spell2Img.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell2Image)")!)!)
        
        cell.playerName.text = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].summonerName
        cell.champName.text = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].championName
        cell.levelLabel.text = String("\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].summonerLevel!)")
        
        if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rHotStreak == true {
            cell.streakImage.image = UIImage(named: "fire.png")
        }
        if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rColdStreak == true {
            cell.streakImage.image = UIImage(named: "icecube.png")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 40)
    }
    
    
}