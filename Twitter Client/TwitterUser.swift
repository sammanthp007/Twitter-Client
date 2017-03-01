//
//  TwitterUser.swift
//  Twitter Client
//
//  Created by samman on 2/28/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit

class TwitterUser: NSObject {

    var name: String?
    var screenname: String?
    var profileURL: URL?
    var bio: String?
    
    
    init(dict: Dictionary) {
        // deserialization: taking a dictionary of array of information and populating the needed information
        name = dict["name"] as? String
        screenname = dict["screenname"] as? String
        profileURLString = dict["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        
        bio = dict["description"] as? String
        
    }
}
