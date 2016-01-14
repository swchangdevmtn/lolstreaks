//
//  FireBaseController.swift
//  lolstreaks
//
//  Created by Sean Chang on 1/14/16.
//  Copyright © 2016 Sean Chang. All rights reserved.
//

import Foundation
import Firebase

class FireBaseController {
    static let baseString = "https://lolstreaks.firebaseio.com"
    
    static let base = Firebase(url: "https://lolstreaks.firebaseio.com")
    
    static func dataAtEndPoint(endpoint: String, completion:(data: AnyObject?) -> Void) {
        let firebaseEndpoint = FireBaseController.base.childByAppendingPath(endpoint)
        firebaseEndpoint.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
}