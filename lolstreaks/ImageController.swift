//
//  ImageController.swift
//  lolstreaks
//
//  Created by Sean Chang on 3/18/16.
//  Copyright © 2016 Sean Chang. All rights reserved.
//

import Foundation

class ImageController {
    
    static let sharedInstance = ImageController()
    
    var championSprites: [String:Sprite] = [:]
    var spellSprites: [String:Sprite] = [:]
    var itemSprites: [String:Sprite] = [:]
    var keystoneSprites: [String:Sprite] = [:]
    
    var allSpriteData: [String:NSData] = [:]
    
    func loadImages() {
        
    }
}