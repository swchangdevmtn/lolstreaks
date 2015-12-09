//
//  CurrentGame.swift
//  lolstreaks
//
//  Created by Sean Chang on 11/30/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class CurrentGame {
    var gameId: Int
    var mapId: Int
    var gameLength: Int
    var gameMode: String
    var gameType: String
    var gameQueueConfigId: Int
    var participants: [Participant]
    
    init(gameId: Int, mapId: Int, gameLength: Int, gameMode: String, gameType: String, gameQueueConfigId: Int, participants: [Participant]) {
        self.gameId = gameId
        self.mapId = mapId
        self.gameLength = gameLength
        self.gameMode = gameMode
        self.gameType = gameType
        self.gameQueueConfigId = gameQueueConfigId
        self.participants = participants
    }
    
    init(json:[String:AnyObject]) {
        guard let gameId = json["gameId"] as? Int,
            let mapId = json["mapId"] as? Int,
            let gameLength = json["gameLength"] as? Int,
            let gameMode = json["gameMode"] as? String,
            let gameType = json["gameType"] as? String,
            let gameQueueConfigId = json["gameQueueConfigId"] as? Int,
            let participants = json["participants"] as? NSArray
            else {
                self.gameId = -1
                self.mapId = -1
                self.gameLength = -1
                self.gameMode = ""
                self.gameType = ""
                self.gameQueueConfigId = -1
                self.participants = []
                return
        }
        self.gameId = gameId
        self.mapId = mapId
        self.gameLength = gameLength
        self.gameMode = gameMode
        self.gameType = gameType
        self.gameQueueConfigId = gameQueueConfigId
        self.participants = participants as! [Participant]
    }
}