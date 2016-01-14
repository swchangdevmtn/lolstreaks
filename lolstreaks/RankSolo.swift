//
//  RankSolo.swift
//  lolstreaks
//
//  Created by Sean Chang on 1/5/16.
//  Copyright © 2016 Sean Chang. All rights reserved.
//

import Foundation

class RankSolo {
    var id: Int
    var rank: String
    var division: String
    var wins: Int
    var losses: Int
    var lp: Int
    var series: String
    
    init(id: Int, rank: String, division: String, wins: Int, losses: Int, lp: Int, series: String) {
        self.id = id
        self.rank = rank
        self.division = division
        self.wins = wins
        self.losses = losses
        self.lp = lp
        self.series = series
    }
}