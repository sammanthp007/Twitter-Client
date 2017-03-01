//
//  TwitterClient.swift
//  Twitter Client
//
//  Created by samman on 3/1/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedTwitterClient = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as URL!, consumerKey: "Egs4PG34sQWvqD2zCLMjrHdOI", consumerSecret: "90GSSJxs9j6NJzUXbWJ7rkhu7jVXCTHJKfVcosDYlPVZLEIT9i")
    
}
