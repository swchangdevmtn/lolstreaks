//
//  PastGameController.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/13/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class PastGameController {
    
    static let sharedInstance = PastGameController()
    
    var pastGames: [PastGame] = []
    
    //exceptions for:
    //gameMode: ODIN (dominion), ARAM ?(maybe selectable), TUTORIAL, ONEFORALL, ASCENSION, KINGPORO, FIRSTBLOOD
    //gameType: CUSTOM_GAME, TUTORIAL_GAME
    //subType: BOT, BOT_3x3, ODIN_UNRANKED, FIRSTBLOOD_1x1, FIRSTBLOOD_2x2, SR_6x6 (hexakill), URF, URF_BOT, NIGHTMARE_BOT, ASCENSION, HEXAKILL (twisted treeline hexakill), KING_PORO, COUNTER_PICK, BILGEWATER
    let usedModes = ["CLASSIC", "ARAM"]
    let usedTypes = ["MATCHED_GAME"]
    let usedSubTypes = ["NORMAL", "NORMAL_3x3", "ARAM_UNRANKED_5x5", "RANKED_SOLO_5x5", "RANKED_TEAM_3x3", "RANKED_TEAM_5x5", "CAP_5x5"]
    
    func coldStreak(countedGames:[PastGame]) -> Bool {
        if countedGames.count >= 3 {
            if countedGames[0].stats!.win == false {
                if countedGames[1].stats!.win == false {
                    if countedGames[2].stats!.win == false {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func hotStreak(countedGames:[PastGame]) -> Bool {
        if countedGames.count >= 3 {
            if countedGames[0].stats!.win == true {
                if countedGames[1].stats!.win == true {
                    if countedGames[2].stats!.win == true {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func getRCountedGames(pastgames:[PastGame]) -> [PastGame] {
        var countedGames = [PastGame]()
        for game in pastgames {
            if usedModes.contains(game.gameMode) && usedTypes.contains(game.gameType) && usedSubTypes.contains(game.subType) && game.invalid == false {
                countedGames.append(game)
            }
        }
        return countedGames
    }
    
    func getRGameCount(pastgames:[PastGame]) -> Int {
        var allGames: Int = 0
        for game in pastgames {
            if usedModes.contains(game.gameMode) && usedTypes.contains(game.gameType) && usedSubTypes.contains(game.subType) {
                allGames++
            }
        }
        return allGames
    }
    
    func getRKDA(pastgames:[PastGame]) -> Float {
        var allKills: Float = 0
        var allDeaths: Float = 0
        var allAssists: Float = 0
        for game in pastgames {
            if usedModes.contains(game.gameMode) && usedTypes.contains(game.gameType) && usedSubTypes.contains(game.subType) {
                
                allKills += Float((game.stats?.championsKilled)!)
                allDeaths += Float((game.stats?.numDeaths)!)
                allAssists += Float((game.stats?.assists)!)
            }
        }
        if allDeaths == 0 {
            return -100
        } else {
            let rawValue = ((allKills + allAssists)/allDeaths)
        
            return rawValue
        }
    }
    
    func getRWinrate(pastgames:[PastGame]) -> Float {
        var allWins: Float = 0
        var allLosses: Float = 0
        for game in pastgames {
            if usedModes.contains(game.gameMode) && usedTypes.contains(game.gameType) && usedSubTypes.contains(game.subType) {
                if game.stats!.win == true {
                    allWins++
                }
                if game.stats!.win == false {
                    allLosses++
                }
            }
        }
        let rawValue = allWins / (allWins + allLosses)
        return rawValue
    }
    
    func searchForTenRecentGames(region: String, summonerId: Int, completion:(success: Bool) -> Void) {
        if let tenRecentURL = NetworkController.pastTenGames(region, summonerId: summonerId) as NSURL? {
            NetworkController.dataAtURL(tenRecentURL, completion: { (resultData) -> Void in
                guard let data = resultData else {
                    print("no recent game data found")
                    completion(success: false)
                    return
                }
                do {
                    let resultsAnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    var tenPastGamesForPlayer = [PastGame]()
                    if let resultsDictionary = resultsAnyObject as? [String: AnyObject] {
                        // completely new player will have no key "games"
                        if let pastGameArray = resultsDictionary["games"] as? [[String: AnyObject]] {
                            for pastGameDictionary in pastGameArray {
                                let pastGame = PastGame(json: pastGameDictionary)
                                print("past game: \(pastGame.gameId)")
                                
                                //custom games can have no players
                                if let pastPlayerArray = pastGameDictionary["fellowPlayers"] as? [[String : AnyObject]] {
                                    let fellowPlayer = PastPlayer(summonerId: -1, teamId: -1, championId: -1)
                                    
                                    // fellowPlayers property of PastGame added to pastGame
                                    var pastGamePlayers = [PastPlayer]()
                                    for fellowPlayerDict in pastPlayerArray {
                                        fellowPlayer.summonerId = fellowPlayerDict["summonerId"] as! Int
                                        fellowPlayer.teamId = fellowPlayerDict["teamId"] as! Int
                                        fellowPlayer.championId = fellowPlayerDict["championId"] as! Int
                                        pastGamePlayers.append(fellowPlayer)
                                    }
                                    pastGame.fellowPlayers = pastGamePlayers
                                } else {
                                    pastGame.fellowPlayers = [PastPlayer]()
                                }
                                
                                // stats of pastGame
                                let playerStats = Stats(win: false, team: 100, timePlayed: 0, level: 1, goldEarned: 0, goldSpent: 0, championsKilled: 0, numDeaths: 0, assists: 0, turretsKilled: 0, minionsKilled: 0, neutralMinionsKilledEnemyJungle: 0, neutralMinionsKilledYourJungle: 0, totalDamageDealt: 0, totalDamageTaken: 0, physicalDamageDealtPlayer: 0, magicDamageDealtPlayer: 0, largestCriticalStrike: 0, physicalDamageTaken: 0, magicDamageTaken: 0, totalHeal: 0, largestMultiKill: 0, largestKillingSpree: 0, item0: 0, item1: 0, item2: 0, item3: 0, item4: 0, item5: 0, item6: 0, magicDamageDealtToChampions: 0, physicalDamageDealtToChampions: 0, totalDamageDealtToChampions: 0, trueDamageDealtPlayer: 0, trueDamageDealtToChampions: 0, trueDamageTaken: 0, wardPlaced: 0, wardKilled: 0, visionWardsBought: 0)
                                
                                if let stat = pastGameDictionary["stats"] as? [String : AnyObject] {
                                    if let win = stat["win"] as? Bool {
                                        playerStats.win = win
                                    }
                                    if let team = stat["team"] as? Int {
                                        playerStats.team = team
                                    }
                                    if let timePlayed = stat["timePlayed"] as? Int {
                                        playerStats.timePlayed = timePlayed
                                    }
                                    if let level = stat["level"] as? Int {
                                        playerStats.level = level
                                    }
                                    if let goldEarned = stat["goldEarned"] as? Int {
                                        playerStats.goldEarned = goldEarned
                                    }
                                    if let goldSpent = stat["goldSpent"] as? Int {
                                        playerStats.goldSpent = goldSpent
                                    }
                                    if let kills = stat["championsKilled"] as? Int {
                                        playerStats.championsKilled = kills
                                    }
                                    if let deaths = stat["numDeaths"] as? Int {
                                        playerStats.numDeaths = deaths
                                    }
                                    if let assists = stat["assists"] as? Int {
                                        playerStats.assists = assists
                                    }
                                    if let turrets = stat["turretsKilled"] as? Int {
                                        playerStats.turretsKilled = turrets
                                    }
                                    if let minions = stat["minionsKilled"] as? Int {
                                        playerStats.minionsKilled = minions
                                    }
                                    if let enemyJungle = stat["neutralMinionsKilledEnemyJungle"] as? Int {
                                        playerStats.neutralMinionsKilledEnemyJungle = enemyJungle
                                    }
                                    if let teamJungle = stat["neutralMinionsKilledYourJungle"] as? Int {
                                        playerStats.neutralMinionsKilledYourJungle = teamJungle
                                    }
                                    if let totalDamageDealt = stat["totalDamageDealt"] as? Int {
                                        playerStats.totalDamageDealt = totalDamageDealt
                                    }
                                    if let totalDamageTaken = stat["totalDamageTaken"] as? Int {
                                        playerStats.totalDamageTaken = totalDamageTaken
                                    }
                                    if let physicalDamageDealt = stat["physicalDamageDealtPlayer"] as? Int {
                                        playerStats.physicalDamageDealtPlayer = physicalDamageDealt
                                    }
                                    if let magicDamageDealt = stat["magicDamageDealtPlayer"] as? Int {
                                        playerStats.magicDamageDealtPlayer = magicDamageDealt
                                    }
                                    if let criticalStrike = stat["largestCriticalStrike"] as? Int {
                                        playerStats.largestCriticalStrike = criticalStrike
                                    }
                                    if let physicalDamageTaken = stat["physicalDamageTaken"] as? Int {
                                        playerStats.physicalDamageTaken = physicalDamageTaken
                                    }
                                    if let magicDamageTaken = stat["magicDamageTaken"] as? Int {
                                        playerStats.magicDamageTaken = magicDamageTaken
                                    }
                                    if let totalHeal = stat["totalHeal"] as? Int {
                                        playerStats.totalHeal = totalHeal
                                    }
                                    if let largestMultikill = stat["largestMultiKill"] as? Int {
                                        playerStats.largestMultiKill = largestMultikill
                                    }
                                    if let largestKillingSpree = stat["largestKillingSpree"] as? Int {
                                        playerStats.largestKillingSpree = largestKillingSpree
                                    }
                                    if let item0 = stat["item0"] as? Int {
                                        playerStats.item0 = item0
                                    }
                                    if let item1 = stat["item1"] as? Int {
                                        playerStats.item1 = item1
                                    }
                                    if let item2 = stat["item2"] as? Int {
                                        playerStats.item2 = item2
                                    }
                                    if let item3 = stat["item3"] as? Int {
                                        playerStats.item3 = item3
                                    }
                                    if let item4 = stat["item4"] as? Int {
                                        playerStats.item4 = item4
                                    }
                                    if let item5 = stat["item5"] as? Int {
                                        playerStats.item5 = item5
                                    }
                                    if let item6 = stat["item6"] as? Int {
                                        playerStats.item6 = item6
                                    }
                                    if let magicDealtToChamps = stat["magicDamageDealtToChampions"] as? Int {
                                        playerStats.magicDamageDealtToChampions = magicDealtToChamps
                                    }
                                    if let physDealtToChamps = stat["physicalDamageDealtToChampions"] as? Int {
                                        playerStats.physicalDamageDealtToChampions = physDealtToChamps
                                    }
                                    if let totalDealtToChamps = stat["totalDamageDealtToChampions"] as? Int {
                                        playerStats.totalDamageDealtToChampions = totalDealtToChamps
                                    }
                                    if let trueDamageDealt = stat["trueDamageDealtPlayer"] as? Int {
                                        playerStats.trueDamageDealtPlayer = trueDamageDealt
                                    }
                                    if let trueDamageToChamps = stat["trueDamageDealtToChampions"] as? Int {
                                        playerStats.trueDamageDealtToChampions = trueDamageToChamps
                                    }
                                    if let trueDamageTaken = stat["trueDamageTaken"] as? Int {
                                        playerStats.trueDamageTaken = trueDamageTaken
                                    }
                                    if let wardPlaced = stat["wardPlaced"] as? Int {
                                        playerStats.wardPlaced = wardPlaced
                                    }
                                    if let wardKilled = stat["wardKilled"] as? Int {
                                        playerStats.wardKilled = wardKilled
                                    }
                                    if let visionWardsBought = stat["visionWardsBought"] as? Int {
                                        playerStats.visionWardsBought = visionWardsBought
                                    }
                                    pastGame.stats = playerStats
                                }
                                tenPastGamesForPlayer.append(pastGame)
                            }
                        } else {
                            tenPastGamesForPlayer = [PastGame]()
                        }
                    }
                    for var i = 0; i < CurrentGameController.sharedInstance.allteams.count; i++ {
                        for var j = 0; j < CurrentGameController.sharedInstance.allteams[i].count; j++ {
                            if CurrentGameController.sharedInstance.allteams[i][j].summonerId == summonerId {
                                CurrentGameController.sharedInstance.allteams[i][j].pastGames = tenPastGamesForPlayer
                                if CurrentGameController.sharedInstance.allteams[i][j].pastGames!.count >= 1 {
                                    let rKDA = self.getRKDA(CurrentGameController.sharedInstance.allteams[i][j].pastGames!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rKDA = rKDA
                                    let rWinRate = self.getRWinrate(CurrentGameController.sharedInstance.allteams[i][j].pastGames!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rWinrate = rWinRate
                                    let rGameCount = self.getRGameCount(CurrentGameController.sharedInstance.allteams[i][j].pastGames!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rCountedGames = rGameCount
                                    
                                    
                                    let rCountedGames = self.getRCountedGames(CurrentGameController.sharedInstance.allteams[i][j].pastGames!)
                                    CurrentGameController.sharedInstance.allteams[i][j].pastGamesCounted = rCountedGames
                                    let coldStreak = self.coldStreak(CurrentGameController.sharedInstance.allteams[i][j].pastGamesCounted!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rColdStreak = coldStreak
                                    let hotStreak = self.hotStreak(CurrentGameController.sharedInstance.allteams[i][j].pastGamesCounted!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rHotStreak = hotStreak
                                    
                                } else {
                                    print("new player, no games")
                                }
                            }
                        }
                    }
                    completion(success: true)
                } catch {
                    completion(success: false)
                }
            })
        }
    }
}