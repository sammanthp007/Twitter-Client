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
    var dict: NSDictionary?
    
    
    init(dict: NSDictionary) {
        // for putting in persistant memory as NSData
        self.dict = dict
        
        // deserialization: taking a dictionary of array of information and populating the needed information
        name = dict["name"] as? String
        screenname = dict["screenname"] as? String
        let profileURLString = dict["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        
        bio = dict["description"] as? String
        
    }
    
    static var _currentUser: TwitterUser?
    
    // for persistant memory about the info of the user
    class var currentUser: TwitterUser? {
        get {
            if _currentUser == nil {
                // retrive the persistant key value pair called UserDefaults
                let defaults = UserDefaults.standard
                
                // get the currentUserData from the persistant memory (equivalent to cookie)
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: [])
                    _currentUser = TwitterUser(dict: dictionary as! NSDictionary)
                }
            }
            return _currentUser!
        }
        
        set (user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dict!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
            
        }
    }
}
