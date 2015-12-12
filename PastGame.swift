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
    let summonerId: Int
    let gameId: Int
    let gameMode: String
    let gameType: String
    let subType: String
    let mapId: Int
    let teamId: Int
    let championId: Int
    let spell1Id: Int
    let spell2Id: Int
    let createDate: Int
    
    //personal stats for game:
    
    let gameLevel: Int
    var gold: Int?
    var minionsKilled: Int?
    var barracksKilled: Int?
    var turretsKilled: Int?
    
    //KDA
    var championsKilled: Int?
    var numDeaths: Int?
    var assists: Int?
    
    var largestMultiKill: Int?
    
    //calc damage contribution
    var totalDamageDealtToChampions: Int?
    var totalDamageTaken: Int?
    
    var totalHeal: Int?
    
    var item0: Int?
    var item1: Int?
    var item2: Int?
    var item3: Int?
    var item4: Int?
    var item5: Int?
    var item6: Int?
    
    var wardPlaced: Int?
    var wardKilled: Int?
    
    //win percentage
    let win: Bool
    
    init(summonerId: Int, gameId: Int, gameMode: String, gameType: String, subType: String, mapId: Int, teamId: Int, championId: Int, spell1Id: Int, spell2Id: Int, createDate: Int, gameLevel: Int, win: Bool) {
        self.summonerId = summonerId
        self.gameId = gameId
        self.gameMode = gameMode
        self.gameType = gameType
        self.subType = subType
        self.mapId = mapId
        self.teamId = teamId
        self.championId = championId
        self.spell1Id = spell1Id
        self.spell2Id = spell2Id
        self.createDate = createDate
        self.gameLevel = gameLevel
        self.win = win
    }
}

