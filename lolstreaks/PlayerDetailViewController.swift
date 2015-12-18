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
        let cell = tableView.dequeueReusableCellWithIdentifier("pastGameCell")
        cell?.textLabel!.text = "\(selectedPlayer.pastGames![indexPath.row].gameId)"
        return cell!
    }

}
