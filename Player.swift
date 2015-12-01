//
//  Player.swift
//  lolstreaks
//
//  Created by Sean Chang on 11/30/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class Player {
    let summonerID: String
    let name: String
    let level: Int
    let profileIconId: String
    var gameIds: [String]?
    
    init(json:[String:AnyObject]) {
        guard let summonerID = json["id"] as? String,
            let name = json["name"] as? String,
            let level = json["summonerLevel"] as? Int,
            let profileIconId = json["profileIconId"] as? String
            else {
                self.summonerID = ""
                self.name = ""
                self.level = 0
                self.profileIconId = ""
                return
        }
        self.summonerID = summonerID
        self.name = name
        self.level = level
        self.profileIconId = profileIconId
    }
}