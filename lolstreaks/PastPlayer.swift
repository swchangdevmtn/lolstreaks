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
    
    init(json:[String:AnyObject]){
        guard let summonerId = json["summonerId"] as? Int,
            let teamId = json["teamId"] as? Int,
            let championId = json["championId"] as? Int else {
                self.summonerId = -1
                self.teamId = -1
                self.championId = -1
                return
        }
        self.summonerId = summonerId
        self.teamId = teamId
        self.championId = championId
    }
}