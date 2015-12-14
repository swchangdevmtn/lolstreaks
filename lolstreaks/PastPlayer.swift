//
//  PastPlayer.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/13/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class PastPlayer {
    var summonerId: Int
    var teamId: Int
    var championId: Int
    
    init(summonerId: Int, teamId: Int, championId: Int) {
        self.summonerId = summonerId
        self.teamId = teamId
        self.championId = championId
    }
}