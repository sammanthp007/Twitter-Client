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
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    // handling login
    func login(success: @escaping () -> (), noSuccess: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = noSuccess
        
        // logout before loging in, this is a BDBO OAUTH 1  manager, logout first
        deauthorize()
        
        // fetch request token using a generic OAUTH one process for twitter to verify that the actual api holder is making this call
        // the path to the request token can be found in app.twitter.com page
        // in even of a sucess, request for my request token
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "sammanstwitter://oauth"), scope: nil, success: {
            (requestToken: BDBOAuth1Credential?) -> Void in
            print ("Received request token in safari: \(requestToken!.token!)")
            
            // the url we want to take the users to in SAFARI
            let authorizeURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            
            // UIApplication.shared.open method is used to open other apps
            // opens safari for us in here
            UIApplication.shared.open(authorizeURL!, options: [:], completionHandler: nil)
        }, failure: {(error: Error?) -> Void in
            print ("Error \(error?.localizedDescription)")
            self.loginFailure?((error)!)
        })
    }
    
    // handling the return url from the oauth request for token
    func handleOpenURL(url: URL) {
        // to access the content in this session
        // url.query is received as query when ever we are opened from another application using UIApplication.shared.open
        let authorizedAccessToken = BDBOAuth1Credential(queryString: url.query)
        
        // fetch the access token required for using the apis
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: authorizedAccessToken,
                         success: {(requestToken: BDBOAuth1Credential?) -> Void in
            print ("Got the request token")
            self.loginSuccess?()
        }, failure: { (error: Error?) -> Void in
            print ("Error: \(error)")
            self.loginFailure?((error)!)
        }
    )}
    
    
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
