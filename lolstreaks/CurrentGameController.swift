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
    var parentCellIndex: Int?
    var teamblue: [Participant] = []
    var teamred: [Participant] = []
    var allteams: [[Participant]] = []
    var ddragonVersion: String = ""
    
    func searchForCurrentGame(region: String, summonerId: Int, completion:(success: Bool) -> Void) {
        if let ddragonVersionURL = NetworkController.ddragonVersion(region) as NSURL? {
            if let data = try? NSData(contentsOfURL: ddragonVersionURL, options: []) {
                let json = JSON(data: data)
                ddragonVersion = ""
                if json[0] != "" {
                    ddragonVersion = json[0].stringValue
                    print(ddragonVersion)
                }
            }
        }
        if let url = NetworkController.currentGame(region, summonerId: summonerId) as NSURL? {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                allParticipants = []
                teamblue = []
                teamred = []
                allteams = []
                if json["gameId"] > -1 {
                    self.currentGame.gameId = json["gameId"].intValue
                    self.currentGame.mapId = json["mapId"].intValue
                    self.currentGame.gameLength = json["gameLength"].intValue
                    self.currentGame.gameMode = json["gameMode"].stringValue
                    self.currentGame.gameType = json["gameType"].stringValue
                    self.currentGame.gameQueueConfigId = json["gameQueueConfigId"].intValue
//                    print("gameId: \(currentGame.gameId), gameLength: \(currentGame.gameLength), gameMode: \(currentGame.gameMode), gameType: \(currentGame.gameType), gameQueue: \(currentGame.gameQueueConfigId)")
                    
                    if json["participants"][0]["teamId"].intValue > -1 {
                        do{
                            let resultsAnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                            if let resultsDictionary = resultsAnyObject as? [String: AnyObject] {
                                let participantArray = resultsDictionary["participants"] as? [[String: AnyObject]]
                                for participantDictionary in participantArray! {
                                    
                                    //participant created from the dicionary without image info
                                    let participant = Participant(json: participantDictionary)
                                    
                                    //grabbing champion image
                                    let championID = participant.championId
                                    var championImage: String = ""
                                    if let championURL = NetworkController.champion(championID) as NSURL? {
                                        if let championData = NSData(contentsOfURL: championURL) {
                                            let json = JSON(data: championData)
                                            championImage = json["image"]["full"].stringValue
                                            
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
                                    
                                    // manually add championImage and spellImages data to participant
                                    participant.spell1Img = spell1Image
                                    participant.spell2Img = spell2Image
                                    participant.championImg = championImage
                                    self.allParticipants.append(participant)
                                }
                                teamblue = allParticipants.filter({$0.teamId == 100})
                                teamred = allParticipants.filter({$0.teamId == 200})
                                allteams.append(teamred)
                                allteams.append(teamblue)

                                
//                                print("---REDTEAM---")
//                                for i in teamred {
//                                    let participant = i
//                                    print("\(participant.summonerName) - \(participant.championImg!) ")
//                                }
//                                print("---BLUETEAM---")
//                                for i in teamblue {
//                                    let participant = i
//                                    print("\(participant.summonerName) - \(participant.championImg!)")
//                                }
                            
                                
                                
                                completion(success: true)
                            } else {
                                completion(success: false)
                            }
                        } catch {
                            completion(success: false)
                        }
                    }
                }
            }
        }
    }
}