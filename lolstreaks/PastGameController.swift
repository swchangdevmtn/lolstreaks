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
                            let pastPlayerDictionary = pastGameDictionary["fellowPlayers"] as? [PastPlayer]
                            
                        }
                    }
                    
                    
                } catch {
                    completion(success: false)
                }
                
                
            })
        }
    }
}