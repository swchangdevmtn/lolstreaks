//
//  Player.swift
//  lolstreaks
//
//  Created by Sean Chang on 11/30/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class Player {
    static let IdKey = "id"
    static let NameKey = "name"
    static let LevelKey = "summonerLevel"
    static let IconKey = "profileIconId"
    
    let summonerID: String
    let name: String
    let level: Int
    let profileIconId: String
    
    //possible no game history
    var pastGames: [PastGame]
    var rKDA: Double
    var rWinrate: Int
    
    //CURRENT GAME
    //which team player is on, which champ selected, which 2 summoner spells
    var teamId: Int?
    var spell1Id: Int?
    var spell2Id: Int?
    var championId: Int?
    
    
    init(jsonDictionary:[String:AnyObject]) {
        if let summonerID = jsonDictionary[Player.IdKey] as? String {
            self.summonerID = summonerID
        }
        if let name = jsonDictionary[Player.NameKey] as? String {
            self.name = name
        }
        if let level = jsonDictionary[Player.LevelKey] as? Int {
            self.level = level
        }
        if let profileIconId = jsonDictionary[Player.IconKey] as? String {
            self.profileIconId = profileIconId
        }
    }
}