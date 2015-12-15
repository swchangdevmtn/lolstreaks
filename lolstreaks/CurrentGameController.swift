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
    
    func searchForDdragonVersion(region: String, completion:(success: Bool) -> Void) {
        if let ddragonVersionURL = NetworkController.ddragonVersion(region) as NSURL? {
            NetworkController.dataAtURL(ddragonVersionURL, completion: { (resultData) -> Void in
                guard let data = resultData else {
                    print("no ddragon version found")
                    completion(success: false)
                    return
                }
                let json = JSON(data: data)
                self.ddragonVersion = json[0].stringValue
                completion(success: true)
            })
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
                                        
                                        // manually add champion info and spellImages data to participant
                                        participant.spell1Img = spell1Image
                                        participant.spell2Img = spell2Image
                                        participant.championImg = championImage
                                        participant.championName = championName
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
                    } catch {
                        completion(success: false)
                    }
                })
            }
        }
    }
}


    //        if let url = NetworkController.currentGame(region, summonerId: summonerId) as NSURL? {
    //            if let data = try? NSData(contentsOfURL: url, options: []) {
    //                let json = JSON(data: data)
    //                allParticipants = []
    //                teamblue = []
    //                teamred = []
    //                allteams = []
    //                if json["gameId"] > -1 {
    //                    self.currentGame.gameId = json["gameId"].intValue
    //                    self.currentGame.mapId = json["mapId"].intValue
    //                    self.currentGame.gameLength = json["gameLength"].intValue
    //                    self.currentGame.gameMode = json["gameMode"].stringValue
    //                    self.currentGame.gameType = json["gameType"].stringValue
    //                    self.currentGame.gameQueueConfigId = json["gameQueueConfigId"].intValue
    //                    print("gameId: \(currentGame.gameId), gameLength: \(currentGame.gameLength), gameMode: \(currentGame.gameMode), gameType: \(currentGame.gameType), gameQueue: \(currentGame.gameQueueConfigId)")
    //
    //                    if json["participants"][0]["teamId"].intValue > -1 {
    //                        do{
    //                            let resultsAnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
    //                            if let resultsDictionary = resultsAnyObject as? [String: AnyObject] {
    //                                let participantArray = resultsDictionary["participants"] as? [[String: AnyObject]]
    //                                var idString = ""
    //                                for levelDictionary in participantArray! {
    //                                    //id String for summoner levels
    //                                    let participant = Participant(json: levelDictionary)
    //                                    idString += String(participant.summonerId) + ","
    //                                }
    //                                print(idString)
    //                                //saving dictionary for grabbing levels
    //                                levelDictionary = [:]
    //                                if let levelURL = NetworkController.searchForLevels(region, ids: idString) as NSURL? {
//                                        if let levelData = NSData(contentsOfURL: levelURL) {
//                                            do {
//                                                let resultsAnyObject = try NSJSONSerialization.JSONObjectWithData(levelData, options: .AllowFragments)
//                                                levelDictionary = resultsAnyObject as! NSDictionary
//    
//                                            } catch {
//                                                completion(success: false)
//                                            }
//                                        }
    //                                }
    //
    //                                for participantDictionary in participantArray! {
    //
    //                                    //participant created from the dicionary without image info
    //                                    let participant = Participant(json: participantDictionary)
    //
    //                                    //grabbing level for participant from saved dictionary (levelDictionary)
    //                                    let levelDictionaryKey = String(participant.summonerId)
    //                                    if let playersDictionary = levelDictionary[levelDictionaryKey] {
    //
    //                                        participant.summonerLevel = playersDictionary["summonerLevel"] as? Int
    //                                    }
    //
    //
    //                                    //grabbing champion image and name
    //                                    let championID = participant.championId
    //                                    var championImage: String = ""
    //                                    var championName: String = ""
    //                                    if let championURL = NetworkController.champion(championID) as NSURL? {
    //                                        if let championData = NSData(contentsOfURL: championURL) {
    //                                            let json = JSON(data: championData)
    //                                            championImage = json["image"]["full"].stringValue
    //                                            championName = json["name"].stringValue
    //                                        }
    //                                    }
    //
    //                                    //grabbing spell images
    //                                    let spell1ID = participant.spell1Id
    //                                    var spell1Image: String = ""
    //                                    if let spell1URL = NetworkController.spell(spell1ID) as NSURL? {
    //                                        if let spellData = NSData(contentsOfURL: spell1URL) {
    //                                            let json = JSON(data: spellData)
    //                                            spell1Image = json["image"]["full"].stringValue
    //                                        }
    //                                    }
    //                                    let spell2ID = participant.spell2Id
    //                                    var spell2Image: String = ""
    //                                    if let spell2URL = NetworkController.spell(spell2ID) as NSURL? {
    //                                        if let spellData = NSData(contentsOfURL: spell2URL) {
    //                                            let json = JSON(data: spellData)
    //                                            spell2Image = json["image"]["full"].stringValue
    //                                        }
    //                                    }
    //
    //                                    // manually add champion info and spellImages data to participant
    //                                    participant.spell1Img = spell1Image
    //                                    participant.spell2Img = spell2Image
    //                                    participant.championImg = championImage
    //                                    participant.championName = championName
    //                                    self.allParticipants.append(participant)
    //                                }
    //
    //                                teamblue = allParticipants.filter({$0.teamId == 100})
    //                                teamred = allParticipants.filter({$0.teamId == 200})
    //                                allteams.append(teamred)
    //                                allteams.append(teamblue)
    //
    //                                print("---REDTEAM---")
    //                                for i in teamred {
    //                                    let participant = i
    //                                    print("\(participant.summonerName)")
    //                                }
    //                                print("---BLUETEAM---")
    //                                for i in teamblue {
    //                                    let participant = i
    //                                    print("\(participant.summonerName)")
    //                                }
    //
    //                                completion(success: true)
    //                            } else {
    //                                completion(success: false)
    //                            }
    //                        } catch {
    //                            completion(success: false)
    //                        }
    //                    }
    //                }
    //            }
    //        }
    
    
