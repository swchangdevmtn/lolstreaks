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

    var parentIndex : Int?

    
}

extension CurrentGameTeamCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("playerCell", forIndexPath: indexPath) as! CurrentGamePlayerCollectionViewCell
        
        if let parentIndex = parentIndex {
        
            let version = CurrentGameController.sharedInstance.ddragonVersion
            let championImage = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].championImg!
            let spell1Image = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].spell1Img!
            let spell2Image = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].spell2Img!
            
            cell.playerName.text = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].summonerName
            cell.championName.text = CurrentGameController.sharedInstance.allteams[parentIndex][indexPath.item].championName
            cell.championImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/champion/\(championImage)")!)!)
            cell.spell1Image.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell1Image)")!)!)
            cell.spell2Image.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell2Image)")!)!)
            
            return cell
        }
        
        return cell
    }
    


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let myIndex = parentIndex {
            return CurrentGameController.sharedInstance.allteams[myIndex].count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width-2, height: 40)
    }
    
}