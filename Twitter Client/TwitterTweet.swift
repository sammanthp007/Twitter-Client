//
//  TwitterTweet.swift
//  Twitter Client
//
//  Created by samman on 2/28/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit

class TwitterTweet: NSObject {
    
    var text: String?
    var timeStamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var userDictionary: NSDictionary
    var name: String
    var username: String
    var imageUrl: NSURL
    var favorite: Bool?
    var retweet: Bool?
    var retweet_status: TwitterTweet?
    var currentUserRetweet: String?
    var idString: String?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount  = (dictionary["favorite_count"] as? Int) ?? 0
        idString = dictionary["id_str"] as? String
        let ss = dictionary["user"]
        //print (">>>>>>this is ss>>>>>>>>>\(ss) but dictionary is still \(dictionary)")
        userDictionary = ss as! NSDictionary
        name = userDictionary["name"] as! String
        username = (userDictionary["screen_name"] as? String)!
        imageUrl = NSURL(string: userDictionary["profile_image_url_https"] as! String)!
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timestampString) as NSDate?
        }
        
        let currentUserRetweetDict = dictionary["current_user_retweet"] as? NSDictionary
        if currentUserRetweetDict != nil {
            currentUserRetweet = (currentUserRetweetDict?["id_str"] as AnyObject) as? String
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
    
    class func getArrayOfTweets(dictionaries: [NSDictionary]) -> [TwitterTweet] {
        var tweets = [TwitterTweet]()
        for dictionary in dictionaries {
            let tweet = TwitterTweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

}
