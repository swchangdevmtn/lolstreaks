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
    //gameMode: CLASSIC, ODIN, ARAM, TUTORIAL, ONEFORALL, ASCENSION, FIRSTBLOOD, KINGPORO
    //gameType: CUSTOM_GAME, MATCHED_GAME, TUTORIAL_GAME
    //subType: NONE, NORMAL, BOT, RANKED_SOLO_5x5, RANKED_PREMADE_3x3, RANKED_PREMADE_5x5, ODIN_UNRANKED, RANKED_TEAM_3x3, RANKED_TEAM_5x5, NORMAL_3x3, BOT_3x3, CAP_5x5, ARAM_UNRANKED_5x5, ONEFORALL_5x5, FIRSTBLOOD_1x1, FIRSTBLOOD_2x2, SR_6x6, URF, URF_BOT, NIGHTMARE_BOT, ASCENSION, HEXAKILL, KING_PORO, COUNTER_PICK, BILGEWATER
    
    let usedModes = ["CLASSIC"]
    let usedTypes = ["MATCHED_GAME"]
    let usedSubTypes = ["NORMAL", "RANKED_SOLO_5x5", "RANKED_PREMADE_3x3", "RANKED_PREMADE_5x5", "RANKED_TEAM_3x3", "RANKED_TEAM_5x5", "NORMAL_3x3", "CAP_5x5"]
    
    func badDay(countedGames:[PastGame]) -> Bool {
        if countedGames.count >= 5 {
            var totalGamesPast12hours = 0
            var wins = 0
            for game in countedGames {
                //milliseconds
                let currentTime: Double = NSDate().timeIntervalSince1970 * 1000
                //12 hours = 43200000 ms
                if currentTime - game.createDate > 43200000 {
                    break
                } else {
                    if game.stats!.win == true {
                        wins += 1
                        totalGamesPast12hours += 1
                    } else {
                        totalGamesPast12hours += 1
                    }
                }
            }
            let winrate = Double(wins) / Double(totalGamesPast12hours)
            if (totalGamesPast12hours >= 5 && winrate <= 0.3){
                print("badDay out of \(totalGamesPast12hours)")
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func goodDay(countedGames:[PastGame]) -> Bool {
        if countedGames.count >= 5 {
            var totalGamesPast12hours = 0
            var wins = 0
            for game in countedGames {
                //milliseconds
                let currentTime: Double = NSDate().timeIntervalSince1970 * 1000
                //12 hours = 43200000 ms
                if currentTime - game.createDate > 43200000 {
                    break
                } else {
                    if game.stats!.win == true {
                        wins += 1
                        totalGamesPast12hours += 1
                    } else {
                        totalGamesPast12hours += 1
                    }
                }
            }
            let winrate = Double(wins) / Double(totalGamesPast12hours)
            if (totalGamesPast12hours >= 5 && winrate >= 0.7){
                print("goodDay out of \(totalGamesPast12hours)")
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    
    func coldStreak(countedGames:[PastGame]) -> Bool {
        if countedGames.count >= 3 {
            if countedGames[0].stats!.win == false && countedGames[1].stats!.win == false && countedGames[2].stats!.win == false {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func hotStreak(countedGames:[PastGame]) -> Bool {
        if countedGames.count >= 3 {
            if countedGames[0].stats!.win == true && countedGames[1].stats!.win == true && countedGames[2].stats!.win == true {
                return true
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
            if usedModes.contains(game.gameMode) && usedTypes.contains(game.gameType) && usedSubTypes.contains(game.subType) && game.invalid == false {
                allGames += 1
            }
        }
        return allGames
    }
    
    func getRKDA(pastgames:[PastGame]) -> (rkda: Float, rkills: Float, rdeaths: Float, rassists: Float) {
        var allKills: Float = 0
        var allDeaths: Float = 0
        var allAssists: Float = 0
        for game in pastgames {
            if usedModes.contains(game.gameMode) && usedTypes.contains(game.gameType) && usedSubTypes.contains(game.subType) && game.invalid == false {
                
                allKills += Float((game.stats?.championsKilled)!)
                allDeaths += Float((game.stats?.numDeaths)!)
                allAssists += Float((game.stats?.assists)!)
            }
        }
        if allDeaths == 0 {
            return (-100, allKills, allDeaths, allAssists)
        } else {
            let rawValue = ((allKills + allAssists)/allDeaths)
        
            return (rawValue, allKills, allDeaths, allAssists)
        }
    }
    
    func getRWinrate(pastgames:[PastGame]) -> Float {
        var allWins: Float = 0
        var allLosses: Float = 0
        for game in pastgames {
            if usedModes.contains(game.gameMode) && usedTypes.contains(game.gameType) && usedSubTypes.contains(game.subType) {
                if game.stats!.win == true {
                    allWins += 1
                }
                if game.stats!.win == false {
                    allLosses += 1
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
                                
                                //champion info from Id value:
                                let championId = pastGame.championId
                                var championImage = ""
                                var championName = ""
                                if let championURL = NetworkController.champion(championId) as NSURL? {
                                    if let championData = NSData(contentsOfURL: championURL) {
                                        let json = JSON(data: championData)
                                        championImage = json["image"]["full"].stringValue
                                        championName = json["name"].stringValue
                                        pastGame.championImg = championImage
                                        pastGame.championName = championName
                                    }
                                }
                                
                                //
                                let spell1Id = pastGame.spell1Id
                                var spell1Image = ""
                                if let spell1URL = NetworkController.spell(spell1Id) as NSURL? {
                                    if let spell1Data = NSData(contentsOfURL: spell1URL) {
                                        let json = JSON(data: spell1Data)
                                        spell1Image = json["image"]["full"].stringValue
                                        pastGame.spell1Img = spell1Image
                                    }
                                }
                                let spell2Id = pastGame.spell2Id
                                var spell2Image = ""
                                if let spell2URL = NetworkController.spell(spell2Id) as NSURL? {
                                    if let spell2Data = NSData(contentsOfURL: spell2URL) {
                                        let json = JSON(data: spell2Data)
                                        spell2Image = json["image"]["full"].stringValue
                                        pastGame.spell2Img = spell2Image
                                    }
                                }
                                
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
                    } else {
                        completion(success: false)
                    }
                    for i in 0 ..< CurrentGameController.sharedInstance.allteams.count {
                        for j in 0 ..< CurrentGameController.sharedInstance.allteams[i].count {
                            if CurrentGameController.sharedInstance.allteams[i][j].summonerId == summonerId {
                                CurrentGameController.sharedInstance.allteams[i][j].pastGames = tenPastGamesForPlayer
                                if CurrentGameController.sharedInstance.allteams[i][j].pastGames!.count >= 1 {
                                    let rKDA = self.getRKDA(CurrentGameController.sharedInstance.allteams[i][j].pastGames!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rKDA = rKDA.rkda
                                    let rWinRate = self.getRWinrate(CurrentGameController.sharedInstance.allteams[i][j].pastGames!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rWinrate = rWinRate
                                    let rGameCount = self.getRGameCount(CurrentGameController.sharedInstance.allteams[i][j].pastGames!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rCountedGames = rGameCount
                                    
                                    if rGameCount >= 1 {
                                        CurrentGameController.sharedInstance.allteams[i][j].rKillAvg = rKDA.rkills/Float(rGameCount)
                                        CurrentGameController.sharedInstance.allteams[i][j].rDeathAvg = rKDA.rdeaths/Float(rGameCount)
                                        CurrentGameController.sharedInstance.allteams[i][j].rAssistAvg = rKDA.rassists/Float(rGameCount)
                                    } else {
                                        CurrentGameController.sharedInstance.allteams[i][j].rKillAvg = 0
                                        CurrentGameController.sharedInstance.allteams[i][j].rDeathAvg = 0
                                        CurrentGameController.sharedInstance.allteams[i][j].rAssistAvg = 0
                                    }
                                    
                                    let rCountedGames = self.getRCountedGames(CurrentGameController.sharedInstance.allteams[i][j].pastGames!)
                                    CurrentGameController.sharedInstance.allteams[i][j].pastGamesCounted = rCountedGames
                                    let coldStreak = self.coldStreak(CurrentGameController.sharedInstance.allteams[i][j].pastGamesCounted!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rColdStreak = coldStreak
                                    let hotStreak = self.hotStreak(CurrentGameController.sharedInstance.allteams[i][j].pastGamesCounted!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rHotStreak = hotStreak
                                    let badDay = self.badDay(CurrentGameController.sharedInstance.allteams[i][j].pastGamesCounted!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rBadDay = badDay
                                    let goodDay = self.goodDay(CurrentGameController.sharedInstance.allteams[i][j].pastGamesCounted!)
                                    CurrentGameController.sharedInstance.allteams[i][j].rGoodDay = goodDay
                                    
                                } else {
                                    print("new player, no games")
                                }
                                break
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