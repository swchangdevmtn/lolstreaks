//
//  PastGame.swift
//  lolstreaks
//
//  Created by Sean Chang on 11/30/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

//  PastGame class used to calculate KDA/WinRate and details for profile

import Foundation

class PastGame {
    var gameId: Int
    var invalid: Bool
    var gameMode: String
    var gameType: String
    var subType: String
    var mapId: Int
    var teamId: Int
    var fellowPlayers: [PastPlayer]?
    var championId: Int
    var championImg: String?
    var championName: String?
    var spell1Id: Int
    var spell1Img: String?
    var spell2Id: Int
    var spell2Img: String?
    var createDate: Int
    var stats: Stats?
    
    init(gameId: Int, invalid: Bool, gameMode: String, gameType: String, subType: String, mapId: Int, teamId: Int, championId: Int, spell1Id: Int, spell2Id: Int, createDate: Int) {
        
        self.gameId = gameId
        self.invalid = invalid
        self.gameMode = gameMode
        self.gameType = gameType
        self.subType = subType
        self.mapId = mapId
        self.teamId = teamId
        self.championId = championId
        self.spell1Id = spell1Id
        self.spell2Id = spell2Id
        self.createDate = createDate
    }
    
    init(json:[String: AnyObject]) {
        guard let gameId = json["gameId"] as? Int,
            let invalid = json["invalid"] as? Bool,
            let gameMode = json["gameMode"] as? String,
            let gameType = json["gameType"] as? String,
            let subType = json["subType"] as? String,
            let mapId = json["mapId"] as? Int,
            let teamId = json["teamId"] as? Int,
            let championId = json["championId"] as? Int,
            let spell1Id = json["spell1"] as? Int,
            let spell2Id = json["spell2"] as? Int,
            let createDate = json["createDate"] as? Int else {
                self.gameId = -1
                self.invalid = false
                self.gameMode = ""
                self.gameType = ""
                self.subType = ""
                self.mapId = -1
                self.teamId = -1
                self.championId = -1
                self.spell1Id = -1
                self.spell2Id = -1
                self.createDate = -1
                return
        }
        self.gameId = gameId
        self.invalid = invalid
        self.gameMode = gameMode
        self.gameType = gameType
        self.subType = subType
        self.mapId = mapId
        self.teamId = teamId
        self.championId = championId
        self.spell1Id = spell1Id
        self.spell2Id = spell2Id
        self.createDate = createDate
    }
}

