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
                        cell.numberOfGamesLabel.text = "in 0 games:"
                    } else {
                        cell.kdaLabel.text = "Perfect!"
                        cell.winrateLabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate!)
                        cell.numberOfGamesLabel.text = String("in \(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames!) games:")
                    }
                } else {
                    cell.kdaLabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA!)
                    cell.winrateLabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate!)
                    cell.numberOfGamesLabel.text = String("in \(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames!) games:")
                }
            } else {
                cell.kdaLabel.text = "-"
                cell.winrateLabel.text = "-"
                cell.numberOfGamesLabel.text = "in 0 games:"
            }
            
        }
        let killAvg = String(format: "%.1f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKillAvg!)
        let deathAvg = String(format: "%.1f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rDeathAvg!)
        let assistAvg = String(format: "%.1f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rAssistAvg!)
        
        cell.kdaAvgLabel.text = "\(killAvg)/\(deathAvg)/\(assistAvg)"
        
        let version = CurrentGameController.sharedInstance.ddragonVersion
        let championImage = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].championImg!
        let spell1Image = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].spell1Img!
        let spell2Image = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].spell2Img!
        
        cell.champImg.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/champion/\(championImage)")!)!)
        cell.spell1Img.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell1Image)")!)!)
        cell.spell2Img.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell2Image)")!)!)
        
        cell.playerName.text = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].summonerName
        cell.champName.text = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].championName
        cell.levelLabel.text = String("(lvl:\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].summonerLevel!))")
        cell.lpLabel.text = "(\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloLp!) LP)"
        
        let strokeTextAttributes = [NSStrokeColorAttributeName : UIColor.whiteColor(),
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -5.0]
        
        cell.rankDivLabel.attributedText = NSAttributedString(string: "\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.row].rankSoloDiv!)", attributes: strokeTextAttributes)
        
        cell.rankWinLossLabel.text = "\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloWins!)/\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloLosses!)"
        
        let rankMedal = String("\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSolo!.capitalizedString) \(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloDiv!)")

        if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloSeries != "none" {
            let seriesString = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloSeries!
            var xoString = ""
//            var xoStringArray = [Character]()
            let check: Character = "✓"
            let xmark: Character = "✕"
            let dash: Character = "-"
            for i in seriesString.characters {
                if i == "W" {
                    xoString.append(check)
//                    xoStringArray.append(check)
//                    xoStringArray.append(Character(" "))
                }
                if i == "L" {
                    xoString.append(xmark)
//                    xoStringArray.append(xmark)
//                    xoStringArray.append(Character(" "))
                }
                if i == "N" {
                    xoString.append(Character(" "))
                    xoString.append(dash)
                    
//                    xoStringArray.append(dash)
//                    xoStringArray.append(Character(" "))
                }
            }
//            let attributeXoString = NSMutableAttributedString(string: xoString)
//            
//            var redRange = [Int]()
//            var greenRange = [Int]()
//            var grayRange = [Int]()
//            for var i = 0; i < xoStringArray.count; i++ {
//                if xoStringArray[i] == check {
//                    greenRange.append(i)
//                }
//                if xoStringArray[i] == xmark {
//                    redRange.append(i)
//                }
//                if xoStringArray[i] == dash {
//                    grayRange.append(i)
//                }
//            }
//            for i in redRange {
//                attributeXoString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: i, length: 1))
//            }
//            for i in greenRange {
//                attributeXoString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location: i, length: 1))
//            }
//            for i in grayRange {
//                attributeXoString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSRange(location: i, length: 1))
//            }
            
            cell.rankSeriesLabel.text = "Series: "
            cell.rankSeriesProgress.text = xoString
        } else {
            cell.rankSeriesLabel.text = ""
            cell.rankSeriesProgress.text = ""
        }
        
        if rankMedal == "Unranked " {
            cell.rankImg.image = UIImage(named: "unranked")
        }
        if rankMedal == "Bronze I" {
            cell.rankImg.image = UIImage(named: "bronze_1")
        }
        if rankMedal == "Bronze II" {
            cell.rankImg.image = UIImage(named: "bronze_2")
        }
        if rankMedal == "Bronze III" {
            cell.rankImg.image = UIImage(named: "bronze_3")
        }
        if rankMedal == "Bronze IV" {
            cell.rankImg.image = UIImage(named: "bronze_4")
        }
        if rankMedal == "Bronze V" {
            cell.rankImg.image = UIImage(named: "bronze_5")
        }
        if rankMedal == "Silver I" {
            cell.rankImg.image = UIImage(named: "silver_1")
        }
        if rankMedal == "Silver II" {
            cell.rankImg.image = UIImage(named: "silver_2")
        }
        if rankMedal == "Silver III" {
            cell.rankImg.image = UIImage(named: "silver_3")
        }
        if rankMedal == "Silver IV" {
            cell.rankImg.image = UIImage(named: "silver_4")
        }
        if rankMedal == "Silver V" {
            cell.rankImg.image = UIImage(named: "silver_5")
        }
        if rankMedal == "Gold I" {
            cell.rankImg.image = UIImage(named: "gold_1")
        }
        if rankMedal == "Gold II" {
            cell.rankImg.image = UIImage(named: "gold_2")
        }
        if rankMedal == "Gold III" {
            cell.rankImg.image = UIImage(named: "gold_3")
        }
        if rankMedal == "Gold IV" {
            cell.rankImg.image = UIImage(named: "gold_4")
        }
        if rankMedal == "Gold V" {
            cell.rankImg.image = UIImage(named: "gold_5")
        }
        if rankMedal == "Platinum I" {
            cell.rankImg.image = UIImage(named: "platinum_1")
        }
        if rankMedal == "Platinum II" {
            cell.rankImg.image = UIImage(named: "platinum_2")
        }
        if rankMedal == "Platinum III" {
            cell.rankImg.image = UIImage(named: "platinum_3")
        }
        if rankMedal == "Platinum IV" {
            cell.rankImg.image = UIImage(named: "platinum_4")
        }
        if rankMedal == "Platinum V" {
            cell.rankImg.image = UIImage(named: "platinum_5")
        }
        if rankMedal == "Diamond I" {
            cell.rankImg.image = UIImage(named: "diamond_1")
        }
        if rankMedal == "Diamond II" {
            cell.rankImg.image = UIImage(named: "diamond_2")
        }
        if rankMedal == "Diamond III" {
            cell.rankImg.image = UIImage(named: "diamond_3")
        }
        if rankMedal == "Diamond IV" {
            cell.rankImg.image = UIImage(named: "diamond_4")
        }
        if rankMedal == "Diamond V" {
            cell.rankImg.image = UIImage(named: "diamond_5")
        }
        if rankMedal == "Master I" {
            cell.rankImg.image = UIImage(named: "master_1")
        }
        if rankMedal == "Challenger I" {
            cell.rankImg.image = UIImage(named: "challenger_1")
        }
        
        
        if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rHotStreak == true {
            cell.streakImage.image = UIImage(named: "hotstreak_.png")
        }
        if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rColdStreak == true {
            cell.streakImage.image = UIImage(named: "coldstreak_.png")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 40)
    }
    
    
}