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
    
    
    var expandedIndexPaths: [NSIndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width

        let navLabel = UILabel(frame: CGRectMake(0,0, 0.8*screenWidth ,50))
        navLabel.numberOfLines = 2
        navLabel.textAlignment = .Right
        navLabel.font = UIFont.systemFontOfSize(14.0)
        navLabel.textColor = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
        
        let queueId = CurrentGameController.sharedInstance.currentGame.gameQueueConfigId
        
        
        let gameTime = CurrentGameController.sharedInstance.currentGame.gameLength
        let gameMinutes: Int = gameTime/60
        let gameSeconds: Int = gameTime - gameMinutes*60
        var timeText = ""
        switch gameTime {
        case Int.min..<0 :
            if gameSeconds > -10 {
                timeText = "-\(abs(gameMinutes)):0\(abs(gameSeconds))"
            } else {
                timeText = "-\(abs(gameMinutes)):\(abs(gameSeconds))"
            }
        default:
            if gameSeconds < 10 {
                timeText = "\(gameMinutes):0\(gameSeconds)"
            } else {
                timeText = "\(gameMinutes):\(gameSeconds)"
            }
        }
        
        
        if let navText = CurrentGameController.sharedInstance.queueDictionary[queueId] {
            navLabel.text = "\(navText)\n\(timeText)"
        } else {
            navLabel.text = "Unknown\n\(timeText)"
        }
        
        self.navigationItem.titleView = navLabel
        
    }

    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
       
    }

 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "playerCellsToDetail" {
            
            if let detailViewController = segue.destinationViewController as? PlayerDetailViewController {
                _ = detailViewController.view
                
                if let indexPath = sender as? NSIndexPath {
                
                    let player = CurrentGameController.sharedInstance.allteams[indexPath.section][indexPath.row]
                    detailViewController.updateWithPlayer(player)
                }
            }
        }
    }
    
    func imageResize(image: UIImage) -> UIImage {
        let originalHeight = image.size.height
        let originalWidth = image.size.width
        let newHeight = 0.9*originalHeight
        let newWidth = 0.9*originalWidth
        
        let crop = CGRectMake((originalWidth-newWidth)/2, (originalHeight-newHeight)/2, newWidth, newHeight)
        let cgImage = CGImageCreateWithImageInRect(image.CGImage, crop)
        let newImage = UIImage(CGImage: cgImage!)
        return newImage
    }
}

extension CurrGameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "teamCell", forIndexPath: indexPath) as! CurrGameTeamCollectionReusableView
        
        
        let imageString = TeamController.sharedInstance.turrets[indexPath.section]
        view.teamImage.image = UIImage(named: imageString)
        
        
        let redTeamTextAttributes = [NSStrokeColorAttributeName : UIColor.whiteColor(),
                                     NSForegroundColorAttributeName : UIColor(red: 130/255, green: 52/255, blue: 47/255, alpha: 1),
                                     NSStrokeWidthAttributeName : -5.0]
        let blueTeamTextAttributes = [NSStrokeColorAttributeName : UIColor.whiteColor(),
                                      NSForegroundColorAttributeName : UIColor(red: 43/255, green: 88/255, blue: 139/255, alpha: 1),
                                      NSStrokeWidthAttributeName : -5.0]
        
        switch
        indexPath.section {
        case 0:
            view.teamLabel.attributedText = NSAttributedString(string: TeamController.sharedInstance.teams[indexPath.section], attributes: redTeamTextAttributes)
        case 1:
            view.teamLabel.attributedText = NSAttributedString(string: TeamController.sharedInstance.teams[indexPath.section], attributes: blueTeamTextAttributes)
        default:
            view.teamLabel.textColor = UIColor.grayColor()
        }
        return view
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("playerCell", forIndexPath: indexPath) as! CurrGamePlayerCollectionViewCell
        
        let parentIndex = indexPath.section
        
        switch
        parentIndex {
        case 0:
            //red
            cell.backgroundColor = UIColor(red: 255/255, green: 82/255, blue: 63/255, alpha: 0.5)
        case 1:
            //blue
            cell.backgroundColor = UIColor(red: 82/255, green: 160/255, blue: 255/255, alpha: 0.5)
        default:
            cell.backgroundColor = UIColor.grayColor()
        }
        
        let redStrokeTextAttributes = [NSStrokeColorAttributeName : UIColor(red: 226/255, green: 0, blue: 0, alpha: 1),
            NSStrokeWidthAttributeName : -5.0]
        
        let greenStrokeTextAttributes = [NSStrokeColorAttributeName : UIColor(red: 0, green: 200/255, blue: 70/255, alpha: 1),
            NSStrokeWidthAttributeName : -5.0]
        
        if let pastGames = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].pastGames as [PastGame]? {
            if let _ = pastGames.first as PastGame? {
                if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA == -100 {
                    if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames == 0 {
                        cell.kdaLabel.text = "-"
                        cell.winrateLabel.text = "-"
                        cell.numberOfGamesLabel.text = "in 0 games:"
                    } else {
                        cell.kdaLabel.attributedText = NSAttributedString(string: "Perfect!", attributes: greenStrokeTextAttributes)
                        if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames >= 3 && CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate >= 0.7 {
                            let winString = String(format: "%.0f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate! * 100) + "%"
                            cell.winrateLabel.attributedText = NSAttributedString(string: winString, attributes: greenStrokeTextAttributes)
                        } else if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames >= 3 && CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate <= 0.3 {
                            let winString = String(format: "%.0f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate! * 100) + "%"
                            cell.winrateLabel.attributedText = NSAttributedString(string: winString, attributes: redStrokeTextAttributes)
                        } else {
                            cell.winrateLabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate!)
                        }
                        cell.numberOfGamesLabel.text = String("in \(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames!) games:")
                    }
                } else {
                    if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames >= 3 && CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA >= 3.5 {
                        let kdaString = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA!)
                        cell.kdaLabel.attributedText = NSAttributedString(string: kdaString, attributes: greenStrokeTextAttributes)
                    } else if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames >= 3 && CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA <= 1.50 {
                        let kdaString = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA!)
                        cell.kdaLabel.attributedText = NSAttributedString(string: kdaString, attributes: redStrokeTextAttributes)
                    } else {
                        cell.kdaLabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA!)
                    }
                    if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames >= 3 && CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate >= 0.7 {
                        let winString = String(format: "%.0f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate! * 100) + "%"
                        cell.winrateLabel.attributedText = NSAttributedString(string: winString, attributes: greenStrokeTextAttributes)
                    } else if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames >= 3 && CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate <= 0.3 {
                        let winString = String(format: "%.0f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate! * 100) + "%"
                        cell.winrateLabel.attributedText = NSAttributedString(string: winString, attributes: redStrokeTextAttributes)
                    } else {
                        cell.winrateLabel.text = String(format: "%.0f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate! * 100) + "%"
                    }
                    
                    cell.numberOfGamesLabel.text = String("in \(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames!) games:")
                }
            } else {
                cell.kdaLabel.text = "-"
                cell.winrateLabel.text = "-"
                cell.numberOfGamesLabel.text = "in 0 games:"
            }
        } else {
            cell.kdaLabel.text = "-"
            cell.winrateLabel.text = "-"
            cell.numberOfGamesLabel.text = "in 0 games:"
        }
        
        if let killAvg = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKillAvg {
            if let deathAvg = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rDeathAvg {
                if let assistAvg = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rAssistAvg {
                    if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames > 0 {
                        cell.kdaAvgLabel.text = "\(String(format: "%.1f", killAvg))/\(String(format: "%.1f", deathAvg))/\(String(format: "%.1f", assistAvg))"
                    } else {
                        cell.kdaAvgLabel.text = "- / - / -"
                    }
                    
                }
            }
        }
        
        let version = CurrentGameController.sharedInstance.ddragonVersion
        if let championImage = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].championImg {
            let champImgURL = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/champion/\(championImage)")
            if let originalChampImageData = NSData(contentsOfURL: champImgURL!){
                let originalChampImage = UIImage(data: originalChampImageData)
                cell.champImg.image = imageResize(originalChampImage!)
                cell.champImg.layer.cornerRadius = 17.5
            }
            
        }
        
        if let keystoneImage = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].keystoneId {
            let keystoneImageURL = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/mastery/\(keystoneImage).png")
            if let keystoneImageData = NSData(contentsOfURL: keystoneImageURL!) {
                cell.keystoneImg.image = UIImage(data: keystoneImageData)
                
                cell.keystoneImg.layer.borderColor = UIColor.whiteColor().CGColor
                cell.keystoneImg.layer.borderWidth = 0.6
            }
        }
        
        if let spell1Image = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].spell1Img {
            let spell1ImgURL = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell1Image)")
            if let spell1ImgData = NSData(contentsOfURL: spell1ImgURL!) {
                cell.spell1Img.image = UIImage(data: spell1ImgData)
                cell.spell1Img.layer.borderColor = UIColor.whiteColor().CGColor
                cell.spell1Img.layer.borderWidth = 0.6
            }
        }
        
        if let spell2Image = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].spell2Img {
            let spell2ImgURL = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell2Image)")
            if let spell2ImgData = NSData(contentsOfURL: spell2ImgURL!) {
                cell.spell2Img.image = UIImage(data: spell2ImgData)
                
                cell.spell2Img.layer.borderColor = UIColor.whiteColor().CGColor
                cell.spell2Img.layer.borderWidth = 0.6
            }
        }
        
        let strokeTextAttributes = [NSStrokeColorAttributeName : UIColor.whiteColor(),
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -5.0]
        
        if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSolo == "Unranked" {
            cell.lpLabel.text = " "
            cell.rankWinLossLabel.text = " "
        } else {
            cell.lpLabel.text = "(\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloLp!) LP)"
            cell.rankWinLossLabel.text = "\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloWins!)/\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloLosses!)"
        }
        cell.playerName.text = String("\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].summonerName)")
        
        cell.champName.text = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].championName
        
        cell.levelLabel.text = String("lvl:\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].summonerLevel!)")
        
        
        
        cell.rankDivLabel.attributedText = NSAttributedString(string: "\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.row].rankSoloDiv!)", attributes: strokeTextAttributes)
        
        
        
        let rankMedal = String("\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSolo!.capitalizedString) \(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloDiv!)")

        if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloSeries != "none" {
            let seriesString = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rankSoloSeries!
            var xoString = ""
            
            let check: Character = "✓"
            let xmark: Character = "✕"
            let dash: Character = "-"
            for i in seriesString.characters {
                if i == "W" {
                    xoString.append(check)
                }
                if i == "L" {
                    xoString.append(xmark)
                }
                if i == "N" {
                    xoString.append(Character(" "))
                    xoString.append(dash)
                }
            }
            
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
        
        cell.streakImage.image = UIImage(named: "blank")
        cell.goodBadDayImage.image = UIImage(named: "blank")
        if CurrentGameController.sharedInstance.allteams[indexPath.section][indexPath.item].rHotStreak == true {
            cell.streakImage.image = UIImage(named: "hotstreak")
        }
        if CurrentGameController.sharedInstance.allteams[indexPath.section][indexPath.item].rColdStreak == true {
            cell.streakImage.image = UIImage(named: "coldstreak2")
        }
        
        if CurrentGameController.sharedInstance.allteams[indexPath.section][indexPath.item].rGoodDay == true {
            if CurrentGameController.sharedInstance.allteams[indexPath.section][indexPath.item].rHotStreak == false && CurrentGameController.sharedInstance.allteams[indexPath.section][indexPath.item].rColdStreak == false {
                cell.streakImage.image = UIImage(named: "sunshine")
            } else {
                cell.goodBadDayImage.image = UIImage(named: "sunshine")
            }
        }
        
        if CurrentGameController.sharedInstance.allteams[indexPath.section][indexPath.item].rBadDay == true {
            if CurrentGameController.sharedInstance.allteams[indexPath.section][indexPath.item].rHotStreak == false && CurrentGameController.sharedInstance.allteams[indexPath.section][indexPath.item].rColdStreak == false {
                cell.streakImage.image = UIImage(named: "raincloud")
            } else {
                cell.goodBadDayImage.image = UIImage(named: "raincloud")
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        if expandedIndexPaths.contains(indexPath) {
//            let indexOfItem = expandedIndexPaths.indexOf(indexPath)
//            expandedIndexPaths.removeAtIndex(indexOfItem!)
//            collectionView.reloadItemsAtIndexPaths([indexPath])
//        } else {
//            expandedIndexPaths.append(indexPath)
//            collectionView.reloadItemsAtIndexPaths([indexPath])
//        }
        let playerName = CurrentGameController.sharedInstance.allteams[indexPath.section][indexPath.item].summonerName
        let toProfileAlert = UIAlertController(title: "Go to profile?", message: "Continue to \(playerName)'s profile?", preferredStyle: .Alert)
        toProfileAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            dispatch_async(dispatch_get_main_queue(), { 
                self.performSegueWithIdentifier("playerCellsToDetail", sender: indexPath)
            })
            
        }))
        toProfileAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        self.presentViewController(toProfileAlert, animated: true, completion: nil)
    }
    
//    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        let cell = collectionView.cellForItemAtIndexPath(indexPath)
//        switch indexPath.section {
//        case 0:
//            //red
//            cell?.backgroundColor = UIColor(red: 255/255, green: 82/255, blue: 63/255, alpha: 0.5)
//        case 1:
//            //blue
//            cell?.backgroundColor = UIColor(red: 82/255, green: 160/255, blue: 255/255, alpha: 0.5)
//        default:
//            cell?.backgroundColor = UIColor.grayColor()
//            
//        }
//    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if expandedIndexPaths.contains(indexPath) {
            return CGSize(width: collectionView.frame.size.width, height: CurrGamePlayerCollectionViewCell.expandedHeight)
        } else {
            return CGSize(width: collectionView.frame.size.width, height: CurrGamePlayerCollectionViewCell.defaultHeight)
        }
    }
}