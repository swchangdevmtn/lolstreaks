//
//  Stats.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/14/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class Stats {
    
    var win: Bool
    var team: Int
    var timePlayed: Int
    
    var level: Int
    var goldEarned: Int
    var goldSpent: Int
    
    var championsKilled: Int
    var numDeaths: Int
    var assists: Int
    var turretsKilled: Int
    
    var minionsKilled: Int
    var neutralMinionsKilledEnemyJungle: Int
    var neutralMinionsKilledYourJungle: Int
    
    var totalDamageDealt: Int
    var totalDamageTaken: Int
    
    var physicalDamageDealtPlayer: Int
    var magicDamageDealtPlayer: Int
    var largestCriticalStrike: Int
    
    var physicalDamageTaken: Int
    var magicDamageTaken: Int
    
    var totalHeal: Int
    
    var largestMultiKill: Int
    var largestKillingSpree: Int
    
    var item0: Int
    var item1: Int
    var item2: Int
    var item3: Int
    var item4: Int
    var item5: Int
    var item6: Int
    
    var magicDamageDealtToChampions: Int
    var physicalDamageDealtToChampions: Int
    var totalDamageDealtToChampions: Int
    var trueDamageDealtPlayer: Int
    var trueDamageDealtToChampions: Int
    var trueDamageTaken: Int
    
    var wardPlaced: Int
    var wardKilled: Int
    var visionWardsBought: Int
    
    init(win: Bool, team: Int, timePlayed: Int, level: Int, goldEarned: Int, goldSpent: Int, championsKilled: Int, numDeaths: Int, assists: Int, turretsKilled: Int, minionsKilled: Int, neutralMinionsKilledEnemyJungle: Int, neutralMinionsKilledYourJungle: Int, totalDamageDealt: Int, totalDamageTaken: Int, physicalDamageDealtPlayer: Int, magicDamageDealtPlayer: Int, largestCriticalStrike: Int, physicalDamageTaken: Int, magicDamageTaken: Int, totalHeal: Int, largestMultiKill: Int, largestKillingSpree: Int, item0: Int, item1: Int, item2: Int, item3: Int, item4: Int, item5: Int, item6: Int, magicDamageDealtToChampions: Int, physicalDamageDealtToChampions: Int, totalDamageDealtToChampions: Int, trueDamageDealtPlayer: Int, trueDamageDealtToChampions: Int, trueDamageTaken: Int, wardPlaced: Int, wardKilled: Int, visionWardsBought: Int) {
        
        self.win = win
        self.team = team
        self.timePlayed = timePlayed
        self.level = level
        self.goldEarned = goldEarned
        self.goldSpent = goldSpent
        self.championsKilled = championsKilled
        self.numDeaths = numDeaths
        self.assists = assists
        self.turretsKilled = turretsKilled
        self.minionsKilled = minionsKilled
        self.neutralMinionsKilledEnemyJungle = neutralMinionsKilledEnemyJungle
        self.neutralMinionsKilledYourJungle = neutralMinionsKilledYourJungle
        self.totalDamageDealt = totalDamageDealt
        self.totalDamageTaken = totalDamageTaken
        self.physicalDamageDealtPlayer = physicalDamageDealtPlayer
        self.magicDamageDealtPlayer = magicDamageDealtPlayer
        self.largestCriticalStrike = largestCriticalStrike
        self.physicalDamageTaken = physicalDamageTaken
        self.magicDamageTaken = magicDamageTaken
        self.totalHeal = totalHeal
        self.largestMultiKill = largestMultiKill
        self.largestKillingSpree = largestKillingSpree
        self.item0 = item0
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        self.item5 = item5
        self.item6 = item6
        self.magicDamageDealtToChampions = magicDamageDealtToChampions
        self.physicalDamageDealtToChampions = physicalDamageDealtToChampions
        self.totalDamageDealtToChampions = totalDamageDealtToChampions
        self.trueDamageDealtPlayer = trueDamageDealtPlayer
        self.trueDamageDealtToChampions = trueDamageDealtToChampions
        self.trueDamageTaken = trueDamageTaken
        self.wardPlaced = wardPlaced
        self.wardKilled = wardKilled
        self.visionWardsBought = visionWardsBought
    }

}