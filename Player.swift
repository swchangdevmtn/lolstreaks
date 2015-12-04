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
    
    let summonerID: String
    let name: String
    let level: Int
    let profileIconId: String
    
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
    
    
    init(jsonDictionary:[[String: AnyObject]]) {
        if let summonerID = jsonDictionary[0][IdKey] as? String {
            self.summonerID = summonerID
        } else {
            self.summonerID = ""
        }
        if let name = jsonDictionary[NameKey] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        if let level = jsonDictionary[LevelKey] as? Int {
            self.level = level
        } else {
            self.level = -1
        }
        if let profileIconId = jsonDictionary[IconKey] as? String {
            self.profileIconId = profileIconId
        } else {
            self.profileIconId = ""
        }
    }
}