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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension CurrentGameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("teamCell", forIndexPath: indexPath) as! CurrentGameTeamCollectionViewCell
//        let team = CurrentGameController.sharedInstance.teams[indexPath.item]
        cell.teamLabel.text = CurrentGameController.sharedInstance.teams[indexPath.item].keys.first
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentGameController.sharedInstance.teams.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 300, height: 200)
    }
}