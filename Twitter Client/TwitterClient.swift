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
    
    
    // make an api call to get who the curernt user is
    func get_user(success: @escaping (TwitterUser) -> (), noSuccess: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {(task, response) -> Void in
        let userDict = response as! NSDictionary
        let user = TwitterUser(dict: userDict)
        
        success(user)
        //print("\(response)")
        }, failure: {(task, error) -> Void in
            noSuccess(error)
        })
    }
   
    
    // make a get request to get tweets
    func get_tweets(success: @escaping ([TwitterTweet]) -> (), noSuccess: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: ["count": 20], progress: nil, success: {
            (task, response) -> Void in
            let tweetDict = response as! [NSDictionary]
            let allTweets = TwitterTweet.getArrayOfTweets(dictionaries: tweetDict)
            
            success(allTweets)
            
        }, failure: {(task, error) -> Void in
            noSuccess(error)
        })
    }
    
    // make an api call to get all mentions of me
    func get_mentions(success: @escaping ([NSDictionary]) -> (), noSuccess: @escaping (Error) -> ()) {
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: {(task, response) -> Void in
            let mentions = response as! [NSDictionary]
            success(mentions)
        }, failure: {(task, error) -> Void in
            noSuccess(error)
        })
    }
    
   
}
