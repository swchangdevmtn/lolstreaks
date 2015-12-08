//
//  Player.swift
//  lolstreaks
//
//  Created by Sean Chang on 11/30/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class Player {
    let IdKey = "id"
    let NameKey = "name"
    let LevelKey = "summonerLevel"
    let IconKey = "profileIconId"
    
    var summonerID: Int
    var name: String
    var level: Int
    var profileIconId: Int
    
//    //possible no game history
//    var pastGames: [PastGame]
//    var rKDA: Double
//    var rWinrate: Int
//    
//    //CURRENT GAME
//    //which team player is on, which champ selected, which 2 summoner spells
//    var teamId: Int?
//    var spell1Id: Int?
//    var spell2Id: Int?
//    var championId: Int?
    
    init(summonerID: Int, name: String, level: Int, profileIconId: Int) {
        self.summonerID = summonerID
        self.name = name
        self.level = level
        self.profileIconId = profileIconId
    }
    
    init(json:[String:AnyObject]) {
        guard let summonerID = json[IdKey] as? Int,
            let name = json[NameKey] as? String,
            let level = json[LevelKey] as? Int,
            let profileIconId = json[IconKey] as? Int else {
                self.summonerID = -1
                self.name = ""
                self.level = -1
                self.profileIconId = -1
                return
        }
        self.summonerID = summonerID
        self.name = name
        self.level = level
        self.profileIconId = profileIconId
    }
    
}