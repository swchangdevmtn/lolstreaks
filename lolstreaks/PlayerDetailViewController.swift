//
//  PlayerDetailViewController.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/2/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileIconImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerLevelLabel: UILabel!
    @IBOutlet weak var playerRankLabel: UILabel!
    @IBOutlet weak var pastGameTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func animateTable() {
        pastGameTable.reloadData()
        
        let cells = pastGameTable.visibleCells
        let tableHeight: CGFloat = pastGameTable.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            
            
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .BeginFromCurrentState, animations: { () -> Void in
                cell.transform = CGAffineTransformMakeTranslation(0, 0)
                }, completion: nil)
            
            index += 1
        }
    }
    
    var selectedPlayer = Participant(teamId: -1, spell1Id: -1, spell2Id: -1, championId: -1, profileIconId: -1, summonerName: "", summonerId: -1)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWithPlayer(player: Participant) {
        playerNameLabel.text = player.summonerName
        playerLevelLabel.text = "Level: \(player.summonerLevel!)"
        let playerRankString = player.rankSolo!.capitalizedString + " " + player.rankSoloDiv!
        var rankTextColor = UIColor.blackColor()
        var rankOutlineColor = UIColor.whiteColor()
        switch player.rankSolo! {
        case "Unranked":
            rankTextColor = UIColor.grayColor()
            rankOutlineColor = UIColor.grayColor()
        case "BRONZE":
            rankTextColor = UIColor(red:0.83, green:0.75, blue:0.67, alpha:1.00)
            rankOutlineColor = UIColor(red: 0.49, green: 0.34, blue: 0.19, alpha: 1)
        case "SILVER":
            rankTextColor = UIColor(red: 0.80, green: 0.85, blue: 0.83, alpha: 1)
            rankOutlineColor = UIColor(red:0.34, green:0.44, blue:0.38, alpha:1.00)
        case "GOLD":
            rankTextColor = UIColor(red: 0.89, green: 0.74, blue: 0.24, alpha: 1)
            rankOutlineColor = UIColor(red:0.84, green:0.61, blue:0.27, alpha:1.00)
        case "PLATINUM":
            rankTextColor = UIColor(red: 0.34, green: 0.74, blue: 0.75, alpha: 1)
            rankOutlineColor = UIColor(red:0.31, green:0.60, blue:0.46, alpha:1.00)
        case "DIAMOND":
            rankTextColor = UIColor(red:0.90, green:0.91, blue:0.96, alpha:1.00)
            rankOutlineColor = UIColor(red: 0.66, green: 0.88, blue: 0.97, alpha: 1)
        case "MASTER":
            rankTextColor = UIColor(red:0.40, green:0.94, blue:0.87, alpha:1.00)
            rankOutlineColor = UIColor(red:0.74, green:0.82, blue:0.80, alpha:1.00)
        case "CHALLENGER":
            rankTextColor = UIColor(red:0.06, green:0.43, blue:0.98, alpha:1.00)
            rankOutlineColor = UIColor(red:1.00, green:0.85, blue:0.18, alpha:1.00)
        default:
            rankTextColor = UIColor.blackColor()
        }
        let rankTextAttributes = [NSStrokeColorAttributeName : rankOutlineColor,
                                  NSForegroundColorAttributeName : rankTextColor,
                                  NSStrokeWidthAttributeName : -3.5]
        playerRankLabel.attributedText = NSAttributedString(string: playerRankString, attributes: rankTextAttributes)
        
        selectedPlayer = player
        let version = CurrentGameController.sharedInstance.ddragonVersion
        let profileIconURL = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/profileicon/\(player.profileIconId).png")
        if let profileIconData = NSData(contentsOfURL: profileIconURL!) {
            profileIconImage.image = UIImage(data: profileIconData)
            profileIconImage.layer.cornerRadius = 37.5
            profileIconImage.layer.borderWidth = 4
            profileIconImage.layer.borderColor = UIColor.whiteColor().CGColor
            profileIconImage.clipsToBounds = true
        }
        animateTable()
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfGames = selectedPlayer.pastGames!.count as Int? {
            return numberOfGames
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pastGameCell") as? PlayerDetailTableViewCell
        let version = CurrentGameController.sharedInstance.ddragonVersion
        var winString = ""
        switch selectedPlayer.pastGames![indexPath.row].invalid {
        case true:
            cell?.backgroundColor = UIColor(red: 1, green: 0.93, blue: 0.72, alpha: 0.4)
            winString = "Prevented"
        default:
            if selectedPlayer.pastGames![indexPath.row].stats!.win == true {
                cell?.backgroundColor = UIColor(red: 0.00, green: 0.71, blue: 0.30, alpha: 0.4)
                winString = "Win"
            } else {
                cell?.backgroundColor = UIColor(red: 0.78, green: 0.12, blue: 0.1, alpha: 0.4)
                winString = "Loss"
            }
        }
        cell?.winLabel.text = winString
        
        if let championImg = selectedPlayer.pastGames![indexPath.row].championImg {
            let champImgURL = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/champion/\(championImg)")
            if let champImgData = NSData(contentsOfURL: champImgURL!) {
                cell?.championImage.image = UIImage(data: champImgData)
                cell?.championImage.layer.borderColor = UIColor.whiteColor().CGColor
                cell?.championImage.layer.borderWidth = 0.6
            }
        }
        
        if let spell1Img = selectedPlayer.pastGames![indexPath.row].spell1Img {
            let spell1ImgURL = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell1Img)")
            if let spell1ImgData = NSData(contentsOfURL: spell1ImgURL!) {
                cell?.spell1Img.image = UIImage(data: spell1ImgData)
                cell?.spell1Img.layer.borderColor = UIColor.whiteColor().CGColor
                cell?.spell1Img.layer.borderWidth = 0.6
            }
        }
        if let spell2Img = selectedPlayer.pastGames![indexPath.row].spell2Img {
            let spell2ImgURL = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell2Img)")
            if let spell2ImgData = NSData(contentsOfURL: spell2ImgURL!) {
                cell?.spell2Img.image = UIImage(data: spell2ImgData)
                cell?.spell2Img.layer.borderColor = UIColor.whiteColor().CGColor
                cell?.spell2Img.layer.borderWidth = 0.6
            }
        }
        
        cell?.levelLabel.text = "\(selectedPlayer.pastGames![indexPath.row].stats!.level)"
        
        cell?.killLabel.text = "\(selectedPlayer.pastGames![indexPath.row].stats!.championsKilled)"
        cell?.deathLabel.text = "\(selectedPlayer.pastGames![indexPath.row].stats!.numDeaths)"
        cell?.assistLabel.text = "\(selectedPlayer.pastGames![indexPath.row].stats!.assists)"
        
        switch selectedPlayer.pastGames![indexPath.row].stats!.largestMultiKill {
        case let x where x < 2:
            cell?.multikillLabel.text = " "
        case 2:
            cell?.multikillLabel.text = "Doublekill"
        case 3:
            cell?.multikillLabel.text = "Triplekill"
        case 4:
            cell?.multikillLabel.text = "Quadrakill"
        case 5:
            cell?.multikillLabel.text = "Pentakill"
        case 6:
            cell?.multikillLabel.text = "Hexakill"
        case 7:
            cell?.multikillLabel.text = "Septakill"
        case 8:
            cell?.multikillLabel.text = "Octokill"
        default:
            cell?.multikillLabel.text = "\(selectedPlayer.pastGames![indexPath.row].stats!.largestMultiKill)-kill"
        }
        switch selectedPlayer.pastGames![indexPath.row].stats!.goldEarned {
        case 0..<1000:
            cell?.goldLabel.text = " \(selectedPlayer.pastGames![indexPath.row].stats!.goldEarned)"
        default:
            let roundedGoldString = String(format: "%.0f", round(Double(selectedPlayer.pastGames![indexPath.row].stats!.goldEarned)/1000))
            cell?.goldLabel.text = " \(roundedGoldString)K"
        }
        
        let creepScore = selectedPlayer.pastGames![indexPath.row].stats!.minionsKilled + selectedPlayer.pastGames![indexPath.row].stats!.neutralMinionsKilledYourJungle + selectedPlayer.pastGames![indexPath.row].stats!.neutralMinionsKilledEnemyJungle
        cell?.csLabel.text = " \(creepScore)"
        
        cell?.gameTypeLabel.text = selectedPlayer.pastGames![indexPath.row].gameType.stringByReplacingOccurrencesOfString("_", withString: " ").capitalizedString
        cell?.gameSubTypeLabel.text = selectedPlayer.pastGames![indexPath.row].subType.stringByReplacingOccurrencesOfString("_", withString: " ").capitalizedString
        
        let currentTime: Double = NSDate().timeIntervalSince1970 * 1000
        switch currentTime - selectedPlayer.pastGames![indexPath.row].createDate {
        case 0..<60000:
            cell?.createDateLabel.text = "less than a minute ago"
        case 60000..<3600000:
            let minutes = round(currentTime - selectedPlayer.pastGames![indexPath.row].createDate)/60000
            if minutes < 2 {
                cell?.createDateLabel.text = "1 minute ago"
            } else {
                cell?.createDateLabel.text = String(format: "%.0f", minutes) + " minutes ago"
            }
        case 3600000..<86400000:
            let hours = round(currentTime - selectedPlayer.pastGames![indexPath.row].createDate)/3600000
            if hours < 2 {
                cell?.createDateLabel.text = "1 hour ago"
            } else {
                cell?.createDateLabel.text = String(format: "%.0f", hours) + " hours ago"
            }
        case 86400000..<2628000000:
            let days = round(currentTime - selectedPlayer.pastGames![indexPath.row].createDate)/86400000
            if days < 2 {
                cell?.createDateLabel.text = "1 day ago"
            } else {
                cell?.createDateLabel.text = String(format: "%.0f", days) + " days ago"
            }
        default:
            let months = round(currentTime - selectedPlayer.pastGames![indexPath.row].createDate)/2628000000
            if months < 2 {
                cell?.createDateLabel.text = "1 month ago"
            } else {
                cell?.createDateLabel.text = String(format: "%.0f", months) + " months ago"
            }
        }
        var timeString = ""
        if let gameTime = selectedPlayer.pastGames![indexPath.row].stats?.timePlayed {
            let gameMinutes: Int = gameTime/60
            let gameSeconds: Int = gameTime - gameMinutes*60
            
            if gameSeconds < 10 {
                timeString = "\(gameMinutes):0\(gameSeconds)"
            } else {
                timeString = "\(gameMinutes):\(gameSeconds)"
            }
        }
        cell?.gameLengthLabel.text = timeString
        
        if selectedPlayer.pastGames![indexPath.row].stats?.item0 == 0 {
            cell?.item0.image = UIImage(named: "blank")
        } else {
            let item0Int = selectedPlayer.pastGames?[indexPath.row].stats?.item0 as Int?
            if let item0Data = NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/item/\(item0Int!).png")!) {
                cell?.item0.image = UIImage(data: item0Data)
            } else {
                cell?.item0.image = UIImage(named: "blank")
            }
        }
        cell?.item0.layer.borderColor = UIColor.whiteColor().CGColor
        cell?.item0.layer.borderWidth = 0.6
        
        if selectedPlayer.pastGames![indexPath.row].stats?.item1 == 0 {
            cell?.item1.image = UIImage(named: "blank")
        } else {
            let item1Int = selectedPlayer.pastGames?[indexPath.row].stats?.item1 as Int?
            if let item1Data = NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/item/\(item1Int!).png")!) {
                cell?.item1.image = UIImage(data: item1Data)
            } else {
                cell?.item1.image = UIImage(named: "blank")
            }
        }
        cell?.item1.layer.borderColor = UIColor.whiteColor().CGColor
        cell?.item1.layer.borderWidth = 0.6
        
        if selectedPlayer.pastGames![indexPath.row].stats?.item2 == 0 {
            cell?.item2.image = UIImage(named: "blank")
        } else {
            let item2Int = selectedPlayer.pastGames?[indexPath.row].stats?.item2 as Int?
            if let item2Data = NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/item/\(item2Int!).png")!) {
                cell?.item2.image = UIImage(data: item2Data)
            } else {
                cell?.item2.image = UIImage(named: "blank")
            }
        }
        cell?.item2.layer.borderColor = UIColor.whiteColor().CGColor
        cell?.item2.layer.borderWidth = 0.6
        
        if selectedPlayer.pastGames![indexPath.row].stats?.item3 == 0 {
            cell?.item3.image = UIImage(named: "blank")
        } else {
            let item3Int = selectedPlayer.pastGames?[indexPath.row].stats?.item3 as Int?
            if let item3Data = NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/item/\(item3Int!).png")!) {
                cell?.item3.image = UIImage(data: item3Data)
            } else {
                cell?.item3.image = UIImage(named: "blank")
            }
        }
        cell?.item3.layer.borderColor = UIColor.whiteColor().CGColor
        cell?.item3.layer.borderWidth = 0.6
        
        if selectedPlayer.pastGames![indexPath.row].stats?.item4 == 0 {
            cell?.item4.image = UIImage(named: "blank")
        } else {
            let item4Int = selectedPlayer.pastGames?[indexPath.row].stats?.item4 as Int?
            if let item4Data = NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/item/\(item4Int!).png")!) {
                cell?.item4.image = UIImage(data: item4Data)
            } else {
                cell?.item4.image = UIImage(named: "blank")
            }
        }
        cell?.item4.layer.borderColor = UIColor.whiteColor().CGColor
        cell?.item4.layer.borderWidth = 0.6
        
        if selectedPlayer.pastGames![indexPath.row].stats?.item5 == 0 {
            cell?.item5.image = UIImage(named: "blank")
        } else {
            let item5Int = selectedPlayer.pastGames?[indexPath.row].stats?.item5 as Int?
            if let item5Data = NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/item/\(item5Int!).png")!) {
                cell?.item5.image = UIImage(data: item5Data)
            } else {
                cell?.item5.image = UIImage(named: "blank")
            }
        }
        cell?.item5.layer.borderColor = UIColor.whiteColor().CGColor
        cell?.item5.layer.borderWidth = 0.6
        
        if selectedPlayer.pastGames![indexPath.row].stats?.item6 == 0 {
            cell?.item6.image = UIImage(named: "blank")
        } else {
            let item6Int = selectedPlayer.pastGames?[indexPath.row].stats?.item6 as Int?
            if let item6Data = NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/item/\(item6Int!).png")!) {
                cell?.item6.image = UIImage(data: item6Data)
            } else {
                cell?.item6.image = UIImage(named: "blank")
            }
        }
        cell?.item6.layer.borderColor = UIColor.whiteColor().CGColor
        cell?.item6.layer.borderWidth = 0.6
        
        return cell!
    }
}
