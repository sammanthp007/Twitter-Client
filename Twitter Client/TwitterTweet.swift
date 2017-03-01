//
//  TwitterTweet.swift
//  Twitter Client
//
//  Created by samman on 2/28/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit

class TwitterTweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var userDictionary: NSDictionary
    var name: String
    var username: String
    var imageUrl: NSURL
    var favorite: Bool?
    var retweet: Bool?
    var retweet_status: Tweet?
    var currentUserRetweet: Tweet?
    var idString: String?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String as NSString?
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount  = (dictionary["favorite_count"] as? Int) ?? 0
        idString = dictionary["id_str"] as? String
        userDictionary = dictionary["user"] as! NSDictionary
        name = userDictionary["name"] as! String
        username = NSString(string: userDictionary["screen_name"] as! String!) as String
        imageUrl = NSURL(string: userDictionary["profile_image_url_https"] as! String)!
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        
        let currentUserRetweetDict = (dictionary["current_user_retweet"] as? NSDictionary)
        if currentUserRetweetDict != nil {
            currentUserRetweet = TwitterTweet(dictionary: currentUserRetweetDict!)
        } else {
            currentUserRetweet = nil
        }
        
        retweet = dictionary["retweeted"] as? Bool
        let retweet_status_dict = (dictionary["retweeted_status"] as? NSDictionary) ?? nil
        if retweet_status_dict != nil {
            retweet_status = TwitterTweet(dictionary: retweet_status_dict!)
        } else {
            retweet_status = nil
        }
        favorite = dictionary["favorited"] as? Bool
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

}
