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
    
    func getRKDA(pastgames:[PastGame]) -> Double {
        var allKills = 0
        var allDeaths = 0
        var allAssists = 0
        for game in pastgames {
            allKills += (game.stats?.championsKilled)!
            allDeaths += (game.stats?.numDeaths)!
            allAssists += (game.stats?.assists)!
        }
        if allDeaths == 0 {
            return -100
        } else {
            return Double(((allKills + allAssists)/allDeaths))
        }
        
    }
    
    func getRWinrate(pastgames:[PastGame]) -> Double {
        var allWins = 0
        var allLosses = 0
        for game in pastgames {
            if game.stats!.win == true {
                allWins++
            }
            if game.stats!.win == false {
                allLosses++
            }
        }
        return Double(allWins / (allWins + allLosses))
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
                    if let resultsDictionary = resultsAnyObject as? [String: AnyObject] {
                        let pastGameArray = resultsDictionary["games"] as? [[String: AnyObject]]
                        for pastGameDictionary in pastGameArray! {
                            let pastGame = PastGame(json: pastGameDictionary)
                            let pastPlayerArray = pastGameDictionary["fellowPlayers"] as? [PastPlayer]
                            pastGame.fellowPlayers = pastPlayerArray
                            if let stats = pastGameDictionary["stats"] as? [String : AnyObject]{
                                if let win = stats["win"] {
                                    pastGame.stats!.win = win as! Bool
                                } else {
                                    pastGame.stats!.win = false
                                }
                                if let team = stats["team"] {
                                    pastGame.stats!.team = team as! Int
                                } else {
                                    pastGame.stats!.team = 100
                                }
                                if let timePlayed = stats["timePlayed"] {
                                    pastGame.stats!.timePlayed = timePlayed as! Int
                                } else {
                                    pastGame.stats!.timePlayed = 0
                                }
                                print(pastGame.stats!.timePlayed)
                                if let level = stats["level"] {
                                    pastGame.stats!.level = level as! Int
                                } else {
                                    pastGame.stats!.level = 0
                                }
                                if let goldEarned = stats["goldEarned"] {
                                    pastGame.stats!.goldEarned = goldEarned as! Int
                                } else {
                                    pastGame.stats!.goldEarned = 0
                                }
                                if let goldSpent = stats["goldSpent"] {
                                    pastGame.stats!.goldSpent = goldSpent as! Int
                                } else {
                                    pastGame.stats!.goldSpent = 0
                                }
                                if let kills = stats["championsKilled"] {
                                    pastGame.stats!.championsKilled = kills as! Int
                                } else {
                                    pastGame.stats!.championsKilled = 0
                                }
                                if let deaths = stats["numDeaths"] {
                                    pastGame.stats!.numDeaths = deaths as! Int
                                } else {
                                    pastGame.stats!.numDeaths = 0
                                }
                                if let assists = stats["assists"] {
                                    pastGame.stats!.assists = assists as! Int
                                } else {
                                    pastGame.stats!.assists = 0
                                }
                                if let turrets = stats["turretsKilled"] {
                                    pastGame.stats!.turretsKilled = turrets as! Int
                                } else {
                                    pastGame.stats!.turretsKilled = 0
                                }
                                if let minions = stats["minionsKilled"] {
                                    pastGame.stats!.minionsKilled = minions as! Int
                                } else {
                                    pastGame.stats!.minionsKilled = 0
                                }
                                if let enemyJungle = stats["neutralMinionsKilledEnemyJungle"] {
                                    pastGame.stats!.neutralMinionsKilledEnemyJungle = enemyJungle as! Int
                                } else {
                                    pastGame.stats!.neutralMinionsKilledEnemyJungle = 0
                                }
                                if let teamJungle = stats["neutralMinionsKilledYourJungle"] {
                                    pastGame.stats!.neutralMinionsKilledYourJungle = teamJungle as! Int
                                } else {
                                    pastGame.stats!.neutralMinionsKilledYourJungle = 0
                                }
                                if let totalDamageDealt = stats["totalDamageDealt"] {
                                    pastGame.stats!.totalDamageDealt = totalDamageDealt as! Int
                                } else {
                                    pastGame.stats!.totalDamageDealt = 0
                                }
                                if let totalDamageTaken = stats["totalDamageTaken"] {
                                    pastGame.stats!.totalDamageTaken = totalDamageTaken as! Int
                                } else {
                                    pastGame.stats!.totalDamageTaken = 0
                                }
                                if let physicalDamageDealt = stats["physicalDamageDealtPlayer"] {
                                    pastGame.stats!.physicalDamageDealtPlayer = physicalDamageDealt as! Int
                                } else {
                                    pastGame.stats!.physicalDamageDealtPlayer = 0
                                }
                                if let magicDamageDealt = stats["magicDamageDealtPlayer"] {
                                    pastGame.stats!.magicDamageDealtPlayer = magicDamageDealt as! Int
                                } else {
                                    pastGame.stats!.magicDamageDealtPlayer = 0
                                }
                                if let criticalStrike = stats["largestCriticalStrike"] {
                                    pastGame.stats!.largestCriticalStrike = criticalStrike as! Int
                                } else {
                                    pastGame.stats!.largestCriticalStrike = 0
                                }
                                if let physicalDamageTaken = stats["physicalDamageTaken"] {
                                    pastGame.stats!.physicalDamageTaken = physicalDamageTaken as! Int
                                } else {
                                    pastGame.stats!.physicalDamageTaken = 0
                                }
                                if let magicDamageTaken = stats["magicDamageTaken"] {
                                    pastGame.stats!.magicDamageTaken = magicDamageTaken as! Int
                                } else {
                                    pastGame.stats!.magicDamageTaken = 0
                                }
                                if let totalHeal = stats["totalHeal"] {
                                    pastGame.stats!.totalHeal = totalHeal as! Int
                                } else {
                                    pastGame.stats!.totalHeal = 0
                                }
                                if let largestMultikill = stats["largestMultiKill"] {
                                    pastGame.stats!.largestMultiKill = largestMultikill as! Int
                                } else {
                                    pastGame.stats!.largestMultiKill = 0
                                }
                                if let largestKillingSpree = stats["largestKillingSpree"] {
                                    pastGame.stats!.largestKillingSpree = largestKillingSpree as! Int
                                } else {
                                    pastGame.stats!.largestKillingSpree = 0
                                }
                                if let item0 = stats["item0"] {
                                    pastGame.stats!.item0 = item0 as! Int
                                } else {
                                    pastGame.stats!.item0 = 0
                                }
                                if let item1 = stats["item1"] {
                                    pastGame.stats!.item1 = item1 as! Int
                                } else {
                                    pastGame.stats!.item1 = 0
                                }
                                if let item2 = stats["item2"] {
                                    pastGame.stats!.item2 = item2 as! Int
                                } else {
                                    pastGame.stats!.item2 = 0
                                }
                                if let item3 = stats["item3"] {
                                    pastGame.stats!.item3 = item3 as! Int
                                } else {
                                    pastGame.stats!.item3 = 0
                                }
                                if let item4 = stats["item4"] {
                                    pastGame.stats!.item4 = item4 as! Int
                                } else {
                                    pastGame.stats!.item4 = 0
                                }
                                if let item5 = stats["item5"] {
                                    pastGame.stats!.item5 = item5 as! Int
                                } else {
                                    pastGame.stats!.item5 = 0
                                }
                                if let item6 = stats["item6"] {
                                    pastGame.stats!.item6 = item6 as! Int
                                } else {
                                    pastGame.stats!.item6 = 0
                                }
                                if let magicDealtToChamps = stats["magicDamageDealtToChampions"] {
                                    pastGame.stats!.magicDamageDealtToChampions = magicDealtToChamps as! Int
                                } else {
                                    pastGame.stats!.magicDamageDealtToChampions = 0
                                }
                                if let physDealtToChamps = stats["physicalDamageDealtToChampions"] {
                                    pastGame.stats!.physicalDamageDealtToChampions = physDealtToChamps as! Int
                                } else {
                                    pastGame.stats!.physicalDamageDealtToChampions = 0
                                }
                                if let totalDealtToChamps = stats["totalDamageDealtToChampions"] {
                                    pastGame.stats!.totalDamageDealtToChampions = totalDealtToChamps as! Int
                                } else {
                                    pastGame.stats!.totalDamageDealtToChampions = 0
                                }
                                if let trueDamageDealt = stats["trueDamageDealtPlayer"] {
                                    pastGame.stats!.trueDamageDealtPlayer = trueDamageDealt as! Int
                                } else {
                                    pastGame.stats!.trueDamageDealtPlayer = 0
                                }
                                if let trueDamageToChamps = stats["trueDamageDealtToChampions"] {
                                    pastGame.stats!.trueDamageDealtToChampions = trueDamageToChamps as! Int
                                } else {
                                    pastGame.stats!.trueDamageDealtToChampions = 0
                                }
                                if let trueDamageTaken = stats["trueDamageTaken"] {
                                    pastGame.stats!.trueDamageTaken = trueDamageTaken as! Int
                                } else {
                                    pastGame.stats!.trueDamageTaken = 0
                                }
                                if let wardPlaced = stats["wardPlaced"] {
                                    pastGame.stats!.wardPlaced = wardPlaced as! Int
                                } else {
                                    pastGame.stats!.wardPlaced = 0
                                }
                                if let wardKilled = stats["wardKilled"] {
                                    pastGame.stats!.wardKilled = wardKilled as! Int
                                } else {
                                    pastGame.stats!.wardKilled = 0
                                }
                                if let visionWardsBought = stats["visionWardsBought"] {
                                    pastGame.stats!.visionWardsBought = visionWardsBought as! Int
                                } else {
                                    pastGame.stats!.visionWardsBought = 0
                                }
                                completion(success: true)
                            }
                        }
                    }
                } catch {
                    completion(success: false)
                }
            })
        }
    }
}