//
//  CurrentGameTeamCollectionViewCell.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/3/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import UIKit

class CurrentGameTeamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var turretImage: UIImageView!

    var parentIndex : Int?
    var childIndex : Int?


    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "collectionToProfile" {
            if let detailViewController = segue.destinationViewController as? PlayerDetailViewController {
                _ = detailViewController.view
                print(sender?.identifier)
            }
        }
    }

}

extension CurrentGameTeamCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let temp = CurrentGameController.sharedInstance.allteams[parentIndex!][sourceIndexPath.item]
        CurrentGameController.sharedInstance.allteams[parentIndex!][sourceIndexPath.item] = CurrentGameController.sharedInstance.allteams[parentIndex!][destinationIndexPath.item]
        CurrentGameController.sharedInstance.allteams[parentIndex!][destinationIndexPath.item] = temp
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("playerCell", forIndexPath: indexPath) as! CurrentGamePlayerCollectionViewCell
        
        if let parentIndex = parentIndex {
            
            switch parentIndex {
            case 0:
                //red
                cell.backgroundColor = UIColor(red: 208/255, green: 127/255, blue: 115/255, alpha: 0.5)
            case 1:
                //blue
                cell.backgroundColor = UIColor(red: 116/255, green: 168/255, blue: 204/255, alpha: 0.5)
            default:
                cell.backgroundColor = UIColor.grayColor()
            }
            
            if let pastGames = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].pastGames as [PastGame]? {
                if let _ = pastGames.first as PastGame? {
                    if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA == -100 {
                        if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames == 0 {
                            cell.rKDALabel.text = "-"
                            cell.rWinRateLabel.text = "-"
                            cell.rCountedGamesLabel.text = "in 0 games"
                        } else {
                            cell.rKDALabel.text = "Perfect KDA!"
                            cell.rWinRateLabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate!)
                            cell.rCountedGamesLabel.text = String("in \(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames!) games")
                        }
                    } else {
                        cell.rKDALabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rKDA!)
                        cell.rWinRateLabel.text = String(format: "%.2f", CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rWinrate!)
                        cell.rCountedGamesLabel.text = String("in \(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rCountedGames!) games")
                    }
                } else {
                    cell.rKDALabel.text = "-"
                    cell.rWinRateLabel.text = "-"
                    cell.rCountedGamesLabel.text = "in 0 games"
                }
                
            }
            
        
            let version = CurrentGameController.sharedInstance.ddragonVersion
            let championImage = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].championImg!
            let spell1Image = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].spell1Img!
            let spell2Image = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].spell2Img!
            
            cell.playerName.text = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].summonerName
            cell.championName.text = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].championName
            cell.levelLabel.text = String("\(CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].summonerLevel!)")
        
            if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].summonerLevel < 30 {
                cell.levelLabel.textColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
            }
            
            if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rHotStreak == true {
                cell.streakImage.image = UIImage(named: "fire.png")
            }
            if CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].rColdStreak == true {
                cell.streakImage.image = UIImage(named: "icecube.png")
            }
            
            cell.championImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/champion/\(championImage)")!)!)
            cell.spell1Image.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell1Image)")!)!)
            cell.spell2Image.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell2Image)")!)!)
            
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
            
            return cell
        }
        
        return cell
    }
    


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let parentIndex = parentIndex {
            return CurrentGameController.sharedInstance.allteams[parentIndex].count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 40)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        childIndex = indexPath.item
        
        if let parentView = self.c as? CurrentGameViewController {
            parentView.performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
        }
        
    }

    
}