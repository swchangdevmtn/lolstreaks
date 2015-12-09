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
    
    var teamblue: [Participant] = []
    var teamred: [Participant] = []
    
    
    func searchForCurrentGame(region: String, summonerId: Int, completion:(success: Bool) -> Void) {
        if let url = NetworkController.currentGame(region, summonerId: summonerId) as NSURL? {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                allParticipants = []
                teamblue = []
                teamred = []
                if json["gameId"] > -1 {
                    self.currentGame.gameId = json["gameId"].intValue
                    self.currentGame.mapId = json["mapId"].intValue
                    self.currentGame.gameLength = json["gameLength"].intValue
                    self.currentGame.gameMode = json["gameMode"].stringValue
                    self.currentGame.gameType = json["gameType"].stringValue
                    self.currentGame.gameQueueConfigId = json["gameQueueConfigId"].intValue
                    print("gameId: \(currentGame.gameId), gameLength: \(currentGame.gameLength), gameMode: \(currentGame.gameMode), gameType: \(currentGame.gameType), gameQueue: \(currentGame.gameQueueConfigId)")
                    
                    if json["participants"][0]["teamId"].intValue > -1 {
                        do{
                            let resultsAnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                            if let resultsDictionary = resultsAnyObject as? [String: AnyObject] {
                                let participantArray = resultsDictionary["participants"] as? [[String: AnyObject]]
                                for participantDictionary in participantArray! {
                                    let participant = Participant(json: participantDictionary)
                                    self.allParticipants.append(participant)
                                    
                                    
                                }
                                teamblue = allParticipants.filter({$0.teamId == 100})
                                teamred = allParticipants.filter({$0.teamId == 200})
                                
                                print("Red Team:")
                                print(teamred[0].summonerName)
                                for i in teamred {
                                    let name = teamred[i].summonerName.
                                    print("\(name) ")
                                }
                                
                                print("Blue Team:")
                                for i in teamblue {
                                    let name = teamblue[i].summonerName
                                    print("\(name) ")
                                }
                                
                                
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