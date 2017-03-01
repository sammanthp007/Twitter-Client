//
//  AppDelegate.swift
//  Twitter Client
//
//  Created by samman on 2/26/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url.description)
        
        // to access the content in this session
        let authorizedAccessToken = BDBOAuth1Credential(queryString: url.query)
        
        // Set the new session
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "Egs4PG34sQWvqD2zCLMjrHdOI", consumerSecret: "90GSSJxs9j6NJzUXbWJ7rkhu7jVXCTHJKfVcosDYlPVZLEIT9i")
        
        // for using the apis
        twitterClient?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: authorizedAccessToken, success: {
            (requestToken: BDBOAuth1Credential?) -> Void in
            print ("Got the request token")
            
            // make an api call to get who the curernt user is
            twitterClient?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {(task, response) -> Void in
                let userDict = response as! NSDictionary
                let user = TwitterUser(dict: userDict)
                
                print ("name: \(user.name!)")
                //print("\(response)")
            }, failure: {(task, error) -> Void in
                print ("Error: \(error)")
            })
            
            
            // make a get request to get tweets
            twitterClient?.get("1.1/statuses/home_timeline.json", parameters: ["count": 20], progress: nil, success: {
                (task, response) -> Void in
                let tweetDict = response as! [NSDictionary]
                
                let allTweets = TwitterTweet.tweetsWithArray(dictionaries: tweetDict)
                
                for tweet in allTweets {
                   print("Tweet content: \(tweet.text)")
                }
                
            }, failure: {(task, error) -> Void in
                print ("Error: \(error)")
            })
            
            // make an api call to get all mentions of me
//            twitterClient?.get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: {(task, response) -> Void in
//                let mentions = response as! [NSDictionary]
//                
//                print ("\(mentions)")
//            }, failure: {(task, error) -> Void in
//                print ("Error: \(error)")
//            })
        }, failure: {
            (Error) -> Void in
            print ("Error: \(Error)")
            
        })
        
            
        
        
        return true
    }

}

