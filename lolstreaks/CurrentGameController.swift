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
    
    func searchForCurrentGame(region: String, summonerId: Int, completion:(success: Bool) -> Void) {
        if let url = NetworkController.currentGame(region, summonerId: summonerId) as NSURL? {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                
                if json["gameId"] > -1 {
                    
                }
            }
        }
    }
    
}