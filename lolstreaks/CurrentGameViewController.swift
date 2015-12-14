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

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

extension CurrentGameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("teamCell", forIndexPath: indexPath) as! CurrentGameTeamCollectionViewCell
        cell.teamLabel.text = TeamController.sharedInstance.teams[indexPath.row]
        
        cell.parentIndex = indexPath.item
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentGameController.sharedInstance.allteams.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width-50, height: 40*5+45)
    }
}