//
//  NetworkController.swift
//  lolstreaks
//
//  Created by Sean Chang on 11/30/15.
//  Copyright © 2015 Sean Chang. All rights reserved.
//

import Foundation

//items to update: API versions, regions

class NetworkController {
    
    //API from firebase
    static let ApiKey = CurrentGameController.sharedInstance.ApiKey
    
    static func searchForId(region: String, searchTerm: String) -> NSURL {
        
        return NSURL(string: "https://\(region).api.pvp.net/api/lol/\(region)/v1.4/summoner/by-name/\(searchTerm)?api_key=\(ApiKey)")!
    }
    
    static func searchForLevels(region: String, ids: String) -> NSURL {
        return NSURL(string: "https://\(region).api.pvp.net/api/lol/\(region)/v1.4/summoner/\(ids)?api_key=\(ApiKey)")!
    }
    
    static func currentGame(region: String, summonerId: Int) -> NSURL {
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
        if region == "jp" {
            platformId = "JP1"
        }
        
        return NSURL(string: "https://\(region).api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/\(platformId)/\(summonerId)?api_key=\(ApiKey)")!
    }
    
    static func pastTenGames(region: String, summonerId: Int) -> NSURL {
        return NSURL(string: "https://\(region).api.pvp.net/api/lol/\(region)/v1.3/game/by-summoner/\(summonerId)/recent?api_key=\(ApiKey)")!
    }
    
    //retrieve top played Champions in ranked
    static func summonerStats(region: String, summonerId: String) -> NSURL {
        return NSURL(string: "https://\(region).api.pvp.net/api/lol/\(region)/v1.3/stats/by-summoner/\(summonerId)/ranked?&api_key=\(ApiKey)")!
    }
    
    //rank of player:
    static func playerRank(region: String, summonerId: String) -> NSURL {
        return NSURL(string: "https://\(region).api.pvp.net/api/lol/\(region)/v2.5/league/by-summoner/\(summonerId)/entry?api_key=\(ApiKey)")!
    }
    
    

    
    //images:
    
    //datadragon version:
    static func ddragonVersion(region: String) -> NSURL {
        return NSURL(string: "https://global.api.pvp.net/api/lol/static-data/\(region)/v1.2/versions?api_key=\(ApiKey)")!
    }
    
    //all champions
    static func allChamps(region: String) -> NSURL {
        return NSURL(string: "https://global.api.pvp.net/api/lol/static-data/\(region)/v1.2/champion?champData=image&api_key=\(ApiKey)")!
    }
    
    //all spells
    static func allSpells(region: String) -> NSURL {
        return NSURL(string: "https://global.api.pvp.net/api/lol/static-data/\(region)/v1.2/summoner-spell?spellData=image&api_key=\(ApiKey)")!
    }
    //champion by ID
    static func champion(championId: Int) -> NSURL {
        return NSURL(string: "https://global.api.pvp.net/api/lol/static-data/\(CurrentGameController.sharedInstance.savedRegion)/v1.2/champion/\(championId)?champData=image&api_key=\(ApiKey)")!
    }
    
    //summoner spells by ID
    static func spell(spellId: Int) -> NSURL {
        return NSURL(string: "https://global.api.pvp.net/api/lol/static-data/\(CurrentGameController.sharedInstance.savedRegion)/v1.2/summoner-spell/\(spellId)?spellData=image&api_key=\(ApiKey)")!
    }
    
    //image examples:
    //profileicon: http://ddragon.leagueoflegends.com/cdn/5.23.1/img/profileicon/588.png 
    //championicon: http://ddragon.leagueoflegends.com/cdn/5.23.1/img/champion/Aatrox.png 
    //items: http://ddragon.leagueoflegends.com/cdn/5.23.1/img/item/1001.png
    //summoner spell: http://ddragon.leagueoflegends.com/cdn/5.24.1/img/spell/SummonerFlash.png
    
    static func dataAtURL(url: NSURL, completion: (resultData: NSData?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url) { (data, _, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
                completion(resultData: nil)
            }
            completion(resultData: data)
        }
        
        dataTask.resume()
    }
}