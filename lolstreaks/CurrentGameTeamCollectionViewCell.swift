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


    
}

extension CurrentGameTeamCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("playerCell", forIndexPath: indexPath) as! CurrentGamePlayerCollectionViewCell
        
        if let cellIndex = CurrentGameController.sharedInstance.parentCellIndex {
            cell.playerName.text = CurrentGameController.sharedInstance.allteams[cellIndex][indexPath.item].summonerName
            let championImage = CurrentGameController.sharedInstance.allteams[cellIndex][indexPath.item].championImg!
            let version = CurrentGameController.sharedInstance.ddragonVersion
            cell.championImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/champion/\(championImage)")!)!)
            let spell1Image = CurrentGameController.sharedInstance.allteams[cellIndex][indexPath.item].spell1Img!
            let spell2Image = CurrentGameController.sharedInstance.allteams[cellIndex][indexPath.item].spell2Img!
            cell.spell1Image.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell1Image)")!)!)
            cell.spell2Image.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ddragon.leagueoflegends.com/cdn/\(version)/img/spell/\(spell2Image)")!)!)
            return cell
        }
        return cell
    }
    


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cellIndex = CurrentGameController.sharedInstance.parentCellIndex {
            return CurrentGameController.sharedInstance.allteams[cellIndex].count
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 280, height: 50)
    }
    
}