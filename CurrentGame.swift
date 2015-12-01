//
//  CurrentGame.swift
//  lolstreaks
//
//  Created by Sean Chang on 11/30/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class CurrentGame {
    let gameId: String
    let gameLength: Int
    let gameMode: String
    let gameType: String
    let participants: [Player]
    
    init(json:[String:AnyObject]) {
        guard let gameId = json["gameId"] as? String,
            let gameLength = json["gameLength"] as? Int,
            let gameMode = json["gameMode"] as? String,
            let gameType = json["gameType"] as? String,
            let participants = json["participants"] as? [Player]
            else {
                self.gameId = ""
                self.gameLength = 0
                self.gameMode = ""
                self.gameType = ""
                self.participants = []
                return
        }
        self.gameId = gameId
        self.gameLength = gameLength
        self.gameMode = gameMode
        self.gameType = gameType
        self.participants = participants
    }
}