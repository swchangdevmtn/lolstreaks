//
//  PlayerController.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/6/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class PlayerController {
    
    static let sharedInstance = PlayerController()
    
    var currentPlayer = Player(summonerID: -1, name: "", level: -1, profileIconId: -1)
    
    func searchForPlayer(region: String, playerName: String, completion: (success: Bool) -> Void) {
        let modifiedPlayerName = playerName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())?.lowercaseString
        
        let trimmedName = playerName.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString
        
        if let url = NetworkController.searchForId(region, searchTerm: modifiedPlayerName!) as NSURL? {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                
                if json[trimmedName]["summonerLevel"].intValue > -1 {
                    self.currentPlayer.summonerID = json[trimmedName]["id"].intValue
                    self.currentPlayer.name = json[trimmedName]["name"].stringValue
                    self.currentPlayer.level = json[trimmedName]["summonerLevel"].intValue
                    self.currentPlayer.profileIconId = json[trimmedName]["profileIconId"].intValue
                    
                    print("name: \(currentPlayer.name), id: \(currentPlayer.summonerID), lvl: \(currentPlayer.level), profileIcon: \(currentPlayer.profileIconId)")
                    
                }
                completion(success: true)
            }
        } else {
            completion(success: false)
        }
        
    }
    
    
}