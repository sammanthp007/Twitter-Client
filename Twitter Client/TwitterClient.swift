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
    static let sharedTwitterClient = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as URL!, consumerKey: "r3tGDOF3D2xRgSYZ0ifo70ax2", consumerSecret: "lGxYLUpkV71peHS0huppgOIBMHr4ntQc7jDlZsDTdW0NdDgGQK")
    
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
            print ("Received request token to open login page authentically in safari: \(requestToken!.token!)")
            
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
    
    // handles logout
    func logOut(){
        TwitterUser.currentUser = nil
        deauthorize()
        
        // notify different classes and services that an event was triggered
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TwitterUser.userLoggedOutNotification), object: nil)
    }
    
    // handling the return url from the oauth request for token; comes here after safari opens us again, being redirected from AppDelegate
    func handleOpenURL(url: URL) {
        // to access the content in this session
        // url.query is received as query when ever we are opened from another application using UIApplication.shared.open
        let authorizedAccessToken = BDBOAuth1Credential(queryString: url.query)
        
        // DEBUGGING
        print ("Received the token from logging in by users: \(authorizedAccessToken)")
        
        // fetch the access token required for using the apis
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: authorizedAccessToken, success: {(requestToken: BDBOAuth1Credential?) -> Void in
            print ("Got the request token to use API:")
            
            // trying store the current user info in persistant memory
            self.get_user(success: { (user) in
                // call the setter and save the info about the current user
                TwitterUser.currentUser = user
                
                // OK, SO WE LOGIN HERE, UNDERSTOOD. But how do we get to loginViewController from here? how does loginSuccess work?
                self.loginSuccess?()
                
            }, noSuccess: {(error: Error) in
                self.loginFailure?((error))
            })            
            
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
    
    // make an api call to retweet tweets
    func retweet(tweet: TwitterTweet, success: @escaping (TwitterTweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/" + tweet.idString! + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = TwitterTweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    // make an api to favorite tweets
    func favorite(tweet: TwitterTweet, success: @escaping (TwitterTweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/create.json", parameters: ["id": tweet.idString!], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = TwitterTweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        })
    }
    
    
    // unretweeting api
    func unretweet(tweet: TwitterTweet, success: @escaping (TwitterTweet) -> (), failure: @escaping (Error) -> ()) {
        if tweet.retweet == true {
            var original_tweet_id: String?
            
            // check if it is a retweet itself form another tweet
            if tweet.retweet_status == nil {
                original_tweet_id = tweet.idString
            } else {
                original_tweet_id = tweet.retweet_status?.idString
            }
            
            get("1.1/statuses/show.json", parameters: ["id": original_tweet_id!, "include_my_retweet": true], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dicti = response as? NSDictionary

                // get the tweet and get the id of the retweet
                let original_tweet: TwitterTweet
                if (dicti != nil) {
                    original_tweet = TwitterTweet.init(dictionary: dicti!)
                } else {
                    original_tweet = TwitterTweet.init(dictionary: dicti!)
                }
                let retweet_id = original_tweet.currentUserRetweet
                
                // unretweet
                self.post("1.1/statuses/unretweet/" + retweet_id! + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                    let dictionary = response as? NSDictionary
                    let tweet = TwitterTweet(dictionary: dictionary!)
                    success(tweet)
                    
                }, failure: { (task: URLSessionDataTask?, error: Error) in
                    failure(error)
                })
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error.localizedDescription)
            })
        } else {
            success(tweet)
        }
    }
    
    // for unfavoriting
    func unfavorite(tweet: TwitterTweet, success: @escaping (TwitterTweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/destroy.json", parameters: ["id": tweet.g!], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = TwitterTweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    
    
    // for figuring when the tweet was made portion
    static func timeSince(timeStamp: Date) -> String {
        let since = timeStamp.timeIntervalSinceNow
        
        if since < 60 * 60 * 24 {
            let seconds = -Int(since.truncatingRemainder(dividingBy: 60))
            let minutes = -Int((since / 60).truncatingRemainder(dividingBy: 60))
            let hours = -Int((since / 3600))
            
            let result = (hours == 0 ? "" : "\(hours)h ") + (minutes == 0 ? "" : "\(minutes)m ") + (seconds == 0 ? "" : "\(seconds)s")
            return result
        } else {
            let formatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "EEE/MMM/d"
                return f
            }()
            return formatter.string(from: timeStamp as Date)
        }
    }
   
}
