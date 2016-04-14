//
//  CurrGamePlayerCollectionViewCell.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/17/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import UIKit

class CurrGamePlayerCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var champImg: UIImageView!
    
    @IBOutlet weak var keystoneImg: UIImageView!
    
    
    @IBOutlet weak var spell1Img: UIImageView!
    @IBOutlet weak var spell2Img: UIImageView!
    
    @IBOutlet weak var champName: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var streakImage: UIImageView!
    @IBOutlet weak var goodBadDayImage: UIImageView!
    
    @IBOutlet weak var winrateLabel: UILabel!
    @IBOutlet weak var kdaLabel: UILabel!
    @IBOutlet weak var kdaAvgLabel: UILabel!
    
    @IBOutlet weak var numberOfGamesLabel: UILabel!
    
    @IBOutlet weak var rankImg: UIImageView!
    @IBOutlet weak var rankDivLabel: UILabel!
    @IBOutlet weak var rankSeriesLabel: UILabel!
    @IBOutlet weak var rankSeriesProgress: UILabel!
    
    @IBOutlet weak var lpLabel: UILabel!
    @IBOutlet weak var rankWinLossLabel: UILabel!
    
    class var defaultHeight: CGFloat { get { return 39 }}
    class var expandedHeight: CGFloat { get { return 100 }}
    
}
