//
//  NetworkController.swift
//  lolstreaks
//
//  Created by Sean Chang on 11/30/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

class NetworkController {
    static let ApiKey = "21f813d8-e04d-4065-8f3a-c7b595fd21a5"
    static func searchForId(region: String, searchTerm: String) -> NSURL {
        let modifiedSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString
        return NSURL(string: "https://\(region).api.pvp.net/api/lol/\(region)/v1.4/summoner/by-name/\(modifiedSearchTerm)?api_key=\(ApiKey)")!
    }
    
    static func currentGame(region: String, summonerId: String) -> NSURL {
        var platformId = ""
        if region == "na" {
            platformId = "NA1"
        }
        if region == "br" {
            platformId = "BR1"
        }
        if region == "lan" {
            platformId = "LA1"
        }
        if region == "las" {
            platformId = "LA2"
        }
        if region == "oce" {
            platformId = "OC1"
        }
        if region == "eune" {
            platformId = "EUN1"
        }
        if region == "tr" {
            platformId = "TR1"
        }
        if region == "ru" {
            platformId = "RU"
        }
        if region == "euw" {
            platformId = "EUW1"
        }
        if region == "kr" {
            platformId = "KR"
        }
        
        return NSURL(string: "https://\(region).api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/\(platformId)/\(summonerId)?api_key=\(ApiKey)")!
    }
    
    static func pastTenGames(region: String, summonerId: String) -> NSURL {
        return NSURL(string: "https://\(region).api.pvp.net/api/lol/\(region)/v1.3/game/by-summoner/\(summonerId)/recent?api_key=\(ApiKey)")!
    }
    
    static func summonerStats(region: String, summonerId: String) -> NSURL {
        return NSURL(string: "https://\(region).api.pvp.net/api/lol/\(region)/v1.3/stats/by-summoner/\(summonerId)/ranked?&api_key=\(ApiKey)")!
    }
    
    static func dataAtURL(url:NSURL, completion:(resultData: NSData?) -> Void) {
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(url) { (data, _, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            completion(resultData: data)
        }
        dataTask.resume()
    }
}