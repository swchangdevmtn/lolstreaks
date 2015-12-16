//
//  CurrentGamePlayerCollectionViewCell.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/3/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import UIKit

class CurrentGamePlayerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var championImage: UIImageView!
    @IBOutlet weak var championName: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var spell1Image: UIImageView!
    @IBOutlet weak var spell2Image: UIImageView!
    
    @IBOutlet weak var lastGameLabel: UILabel!

    @IBOutlet weak var rKDALabel: UILabel!
    @IBOutlet weak var rWinRateLabel: UILabel!
    @IBOutlet weak var rCountedGamesLabel: UILabel!
    @IBOutlet weak var streakImage: UIImageView!
}
