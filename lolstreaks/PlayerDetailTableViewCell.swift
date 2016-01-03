//
//  PlayerDetailTableViewCell.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/18/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import UIKit

class PlayerDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var winImage: UIImageView!
    
    @IBOutlet weak var championImage: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var spell1Img: UIImageView!
    @IBOutlet weak var spell2Img: UIImageView!
    
    //items
    @IBOutlet weak var item0: UIImageView!
    @IBOutlet weak var item1: UIImageView!
    @IBOutlet weak var item2: UIImageView!
    @IBOutlet weak var item3: UIImageView!
    @IBOutlet weak var item4: UIImageView!
    @IBOutlet weak var item5: UIImageView!
    @IBOutlet weak var item6: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
