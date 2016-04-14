//
//  Sprite.swift
//  lolstreaks
//
//  Created by Sean Chang on 3/18/16.
//  Copyright © 2016 Sean Chang. All rights reserved.
//

import Foundation

class Sprite {
    var id: Int
    var sprite: String
    
    var xPos: Int
    var yPos: Int
    var width: Int
    var height: Int
    
    init(id: Int, sprite: String, xPos: Int, yPos: Int, width: Int, height: Int) {
        self.id = id
        self.sprite = sprite
        
        self.xPos = xPos
        self.yPos = yPos
        self.width = width
        self.height = height
        
    }
}