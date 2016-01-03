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
    @IBOutlet weak var pastGameTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        selectedPlayer = player
        let version = CurrentGameController.sharedInstance.ddragonVersion
        profileIconImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/profileicon/\(player.profileIconId).png")!)!)
        
        animateTable()
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
        let championImg = selectedPlayer.pastGames![indexPath.row].championImg!
        cell?.championImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/champion/\(championImg)")!)!)
        let spell1Img = selectedPlayer.pastGames![indexPath.row].spell1Img!
        let spell2Img = selectedPlayer.pastGames![indexPath.row].spell2Img!
        cell?.spell1Img.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell1Img)")!)!)
        cell?.spell2Img.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell2Img)")!)!)
        cell?.levelLabel.text = "\(selectedPlayer.pastGames![indexPath.row].stats!.level)"
        
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
        
        return cell!
    }
}
