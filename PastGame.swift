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
    let gameId: String
    let gameMode: String
    let gameType: String
    let subType: String
    let teamID: Int
    let championID: Int
    let spell1: Int
    let spell2: Int
    let createDate: String
    
    //personal stats for game:
    
    let gameLevel: Int
    let gold: Int
    var minionsKilled: Int?
    var barracksKilled: Int?
    var turretsKilled: Int?
    
    //KDA
    var championsKilled: Int?
    var numDeaths: Int?
    var assists: Int?
    
    let largestMultiKill: Int
    
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
}