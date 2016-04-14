//
//  CurrentGameController.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/8/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class CurrentGameController {
    
    static let sharedInstance = CurrentGameController()
    
    var ApiKey = ""
    var currentGame = CurrentGame(gameId: -1, mapId: -1, gameLength: -1, gameMode: "", gameType: "", gameQueueConfigId: -1, participants: [])
    var allParticipants: [Participant] = []
    var allIds: [Int] = []
    var parentCellIndex: Int?
    var teamblue: [Participant] = []
    var teamred: [Participant] = []
    var allteams: [[Participant]] = []
    var ddragonVersion: String = ""
    var levelDictionary: NSDictionary = [:]
    var savedRegion: String = ""
    var soloRanks: [RankSolo] = []
    
    let keystones: [Int] = [6161, 6162, 6164, 6361, 6362, 6363, 6261, 6262, 6263]
    let queueDictionary: [Int:String] = [0:"Custom Game", 8:"3v3 Normal", 2:"5v5 Normal Blind", 14:"5v5 Normal Draft", 4:"5v5 Ranked", 6:"5v5 Ranked Premade", 9:"3v3 Ranked Premade", 41:"3v3 Ranked Teams", 42:"5v5 Ranked Teams", 16:"5v5 Dominion Blind", 17:"5v5 Dominion Draft", 7:"Coop vs AI", 25:"Coop vs AI", 31:"Coop vs AI", 32:"Coop vs AI", 33:"Coop vs AI", 52:"Coop vs AI", 61:"5v5 Teambuilder", 65:"ARAM Howling Abyss", 70:"5v5 OneForAll", 72:"1v1 Showdown", 73:"2v2 Showdown", 75:"6v6 SR", 76:"5v5 URF", 83:"5v5 URF vs AI", 91:"Doombots Rank 1", 92:"Doombots Rank 2", 93:"Doombots Rank 5", 96:"5v5 Ascension", 98:"6v6 Twisted Treeline", 100:"ARAM Bilgewater", 300:"5v5 King Poro", 310:"5v5 Nemesis", 313:"Black Market Brawlers", 400:"5v5 Normal Draft", 410:"5v5 Ranked Draft"]
    
    func searchForDdragonVersion(region: String, completion:(success: Bool) -> Void) {
        if let ddragonVersionURL = NetworkController.ddragonVersion(region) as NSURL? {
            if let data = NSData(contentsOfURL: ddragonVersionURL) {
                let json = JSON(data: data)
                self.ddragonVersion = json[0].stringValue
                completion(success: true)
            } else {
                completion(success: false)
            }
        }
    }
    
    func searchForRanks(region: String, idString: String, completion:(success: Bool) -> Void) {
        self.soloRanks = []
        if let rankURL = NetworkController.playerRank(region, summonerId: idString) as NSURL? {
            if let rankData = NSData(contentsOfURL: rankURL) {
                let json = JSON(data: rankData)
                for id in self.allIds {
                    let idDictionaryKey = String(id)
                    let idInt = id as Int
                    var index = 0
                    let rankForPlayer = RankSolo(id: idInt, rank: "Unranked", division: "", wins: 0, losses: 0, lp: 0, series: "none")
                    if let idRankArray = json[idDictionaryKey].array {
                        while index < idRankArray.count {
                            let queueType = idRankArray[index]["queue"].stringValue
                            if queueType == "RANKED_SOLO_5x5" {
                                rankForPlayer.rank = idRankArray[index]["tier"].stringValue
                                rankForPlayer.division = idRankArray[index]["entries"][0]["division"].stringValue
                                rankForPlayer.wins = idRankArray[index]["entries"][0]["wins"].intValue
                                rankForPlayer.losses = idRankArray[index]["entries"][0]["losses"].intValue
                                rankForPlayer.lp = idRankArray[index]["entries"][0]["leaguePoints"].intValue
                                if let series = idRankArray[index]["entries"][0]["miniSeries"].dictionary {
                                    rankForPlayer.series = series["progress"]!.stringValue
                                }
                                self.soloRanks.append(rankForPlayer)
                                break
                            }
                            index += 1
                        }
                    }
                }
                completion(success: true)
            } else {
                completion(success: true)
            }
        }
    }
    
    func makeFakeGame(region: String, completion:(success: Bool) -> Void ) {
        let fakeParticipant = Participant(teamId: 0, spell1Id: 0, spell2Id: 0, championId: 0, profileIconId: PlayerController.sharedInstance.currentPlayer.profileIconId, summonerName: PlayerController.sharedInstance.currentPlayer.name, summonerId: PlayerController.sharedInstance.currentPlayer.summonerID)
        self.allIds = []
        self.teamblue = []
        self.allteams = []
        
        allIds.append(PlayerController.sharedInstance.currentPlayer.summonerID)
        
        
        self.searchForRanks(region, idString: String(fakeParticipant.summonerId)) { (success) in
            if success {
                if self.soloRanks.count > 0 {
                    fakeParticipant.rankSolo = self.soloRanks[0].rank
                    fakeParticipant.rankSoloDiv = self.soloRanks[0].division
                    fakeParticipant.rankSoloWins = self.soloRanks[0].wins
                    fakeParticipant.rankSoloLosses = self.soloRanks[0].losses
                    fakeParticipant.rankSoloLp = self.soloRanks[0].lp
                    fakeParticipant.rankSoloSeries = self.soloRanks[0].series
                } else {
                    fakeParticipant.rankSolo = "Unranked"
                    fakeParticipant.rankSoloDiv = ""
                    fakeParticipant.rankSoloWins = 0
                    fakeParticipant.rankSoloLosses = 0
                    fakeParticipant.rankSoloLp = 0
                    fakeParticipant.rankSoloSeries = "none"
                }
                self.teamblue.append(fakeParticipant)
                self.allteams.append(self.teamblue)
                self.allteams[0][0].summonerLevel = PlayerController.sharedInstance.currentPlayer.level
                completion(success: true)
                
            }
        }
        
    }
    
    func searchForCurrentGame(region: String, summonerId: Int, completion:(success: Bool) -> Void) {
        searchForDdragonVersion(region) { (success) -> Void in
            print(self.ddragonVersion)
            self.savedRegion = region
            if let currentGameURL = NetworkController.currentGame(region, summonerId: summonerId) as NSURL? {
                NetworkController.dataAtURL(currentGameURL, completion: { (resultData) -> Void in
                    guard let data = resultData else {
                        completion(success: false)
                        return
                    }
                    let json = JSON(data: data)
                    self.allIds = []
                    self.allParticipants = []
                    self.teamblue = []
                    self.teamred = []
                    self.allteams = []
                    self.currentGame.gameId = 0
                    if json["gameId"].intValue == 0 {
                        print("player is not in a valid current game")
                        completion(success: false)
                        return
                    }
                    self.currentGame.gameId = json["gameId"].intValue
                    self.currentGame.mapId = json["mapId"].intValue
                    self.currentGame.gameLength = json["gameLength"].intValue
                    self.currentGame.gameMode = json["gameMode"].stringValue
                    self.currentGame.gameType = json["gameType"].stringValue
                    self.currentGame.gameQueueConfigId = json["gameQueueConfigId"].intValue
                    print("gameId: \(self.currentGame.gameId), gameLength: \(self.currentGame.gameLength), gameMode: \(self.currentGame.gameMode), gameType: \(self.currentGame.gameType), gameQueue: \(self.currentGame.gameQueueConfigId)")
                    //String of IDs used to grab levels
                    var idString = ""
                    
                    do {
                        let resultsAnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                        if let resultsDictionary = resultsAnyObject as? [String:AnyObject] {
                            let participantArray = resultsDictionary["participants"] as? [[String:AnyObject]]
                            for participantDictionary in participantArray! {
                                let participant = Participant(json: participantDictionary)
                                
                                idString += String(participant.summonerId) + ","
                                self.allIds.append(participant.summonerId)
                            }
                            print("gameIds: \(idString)")
                            
                            self.searchForRanks(region, idString: idString, completion: { (success) -> Void in
                                if success {
                                    self.levelDictionary = [:]
                                    let levelURL = NetworkController.searchForLevels(region, ids: idString) as NSURL?
                                    
                                    NetworkController.dataAtURL(levelURL!, completion: { (resultData) -> Void in
                                        do {
                                            let resultsAnyObject = try NSJSONSerialization.JSONObjectWithData(resultData!, options: .AllowFragments)
                                            self.levelDictionary = resultsAnyObject as! NSDictionary
                                            for participantDictionary in participantArray! {
                                                let participant = Participant(json: participantDictionary)
                                                
                                                let levelDictionaryKey = String(participant.summonerId)
                                                if let playersDictionary = self.levelDictionary[levelDictionaryKey] {
                                                    participant.summonerLevel = playersDictionary["summonerLevel"] as? Int
                                                }
                                                
                                                if let masteriesArray = participantDictionary["masteries"] as? [[String:Int]] {
                                                    for masteriesDictionary in masteriesArray {
                                                        if let masteryId = masteriesDictionary["masteryId"] {
                                                            if self.keystones.contains(masteryId) {
                                                                participant.keystoneId = masteryId as Int
                                                                break
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                //grabbing champion image and name
                                                let championID = participant.championId
                                                var championImage: String = ""
                                                var championName: String = ""
                                                if let championURL = NetworkController.champion(championID) as NSURL? {
                                                    if let championData = NSData(contentsOfURL: championURL) {
                                                        let json = JSON(data: championData)
                                                        championImage = json["image"]["full"].stringValue
                                                        championName = json["name"].stringValue
                                                    }
                                                }
                                                
                                                //grabbing spell images
                                                let spell1ID = participant.spell1Id
                                                var spell1Image: String = ""
                                                if let spell1URL = NetworkController.spell(spell1ID) as NSURL? {
                                                    if let spellData = NSData(contentsOfURL: spell1URL) {
                                                        let json = JSON(data: spellData)
                                                        spell1Image = json["image"]["full"].stringValue
                                                    }
                                                }
                                                let spell2ID = participant.spell2Id
                                                var spell2Image: String = ""
                                                if let spell2URL = NetworkController.spell(spell2ID) as NSURL? {
                                                    if let spellData = NSData(contentsOfURL: spell2URL) {
                                                        let json = JSON(data: spellData)
                                                        spell2Image = json["image"]["full"].stringValue
                                                    }
                                                }
                                                
                                                participant.rankSolo = "Unranked"
                                                participant.rankSoloDiv = ""
                                                participant.rankSoloWins = 0
                                                participant.rankSoloLosses = 0
                                                participant.rankSoloLp = 0
                                                participant.rankSoloSeries = "none"
                                                
                                                if self.soloRanks.count > 0 {
                                                    for playerRank in self.soloRanks {
                                                        if participant.summonerId == playerRank.id {
                                                            participant.rankSolo = playerRank.rank as String
                                                            participant.rankSoloDiv = playerRank.division as String
                                                            participant.rankSoloWins = playerRank.wins as Int
                                                            participant.rankSoloLosses = playerRank.losses as Int
                                                            participant.rankSoloLp = playerRank.lp as Int
                                                            participant.rankSoloSeries = playerRank.series as String
                                                            break
                                                        }
                                                    }
                                                }
                                                // manually add champion info and spellImages data to participant
                                                participant.spell1Img = spell1Image
                                                participant.spell2Img = spell2Image
                                                participant.championImg = championImage
                                                participant.championName = championName
                                                print(participant.keystoneId)
                                                self.allParticipants.append(participant)
                                            }
                                            self.teamblue = self.allParticipants.filter({$0.teamId == 100})
                                            self.teamred = self.allParticipants.filter({$0.teamId == 200})
                                            self.allteams.append(self.teamred)
                                            self.allteams.append(self.teamblue)
                                            
                                            print("---REDTEAM---")
                                            for i in self.teamred {
                                                let participant = i
                                                print("\(participant.summonerName)")
                                            }
                                            print("---BLUETEAM---")
                                            for i in self.teamblue {
                                                let participant = i
                                                print("\(participant.summonerName)")
                                            }
                                            print(self.allIds)
                                            completion(success: true)
                                        } catch {
                                            completion(success: false)
                                        }
                                    })
                                }
                            })
                        } else {
                            completion(success: false)
                        }
                    } catch {
                        completion(success: false)
                    }
                })
            }
        }
    }
}

    
