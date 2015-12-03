//
//  PlayerController.swift
//  lolstreaks
//
//  Created by Sean Chang on 12/2/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class PlayerController {
    
    static let sharedInstance = PlayerController()
    
    func searchForPlayerId(region: String, playerName: String, completion:(result: Player?) -> Void) {
        let url = NetworkController.searchForId(region, searchTerm: playerName)

//        let modifiedName = playerName.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString
        
        NetworkController.dataAtURL(url) { (resultData) -> Void in
            guard let resultData = resultData
                else {
                    print("No data returned")
                    completion(result: nil)
                    return
            }
            
            do {
                let playerAnyObject = try NSJSONSerialization.JSONObjectWithData(resultData, options: NSJSONReadingOptions.AllowFragments)
                var playerModelObject: Player?
                if let playerDictionary = playerAnyObject as? [String: AnyObject] {
                    playerModelObject = Player(jsonDictionary: playerDictionary)
                }
                completion(result: playerModelObject)
            } catch {
                completion(result: nil)
            }
        }
    }
}