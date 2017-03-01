//
//  tweetsViewController.swift
//  Twitter Client
//
//  Created by samman on 3/1/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit

class tweetsViewController: UIViewController {
    
    var tweets: [TwitterTweets]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // fetch tweets
        let twitterClient = TwitterClient.sharedTwitterClient
        
        twitterClient?.get_tweets(success: {(allTweets: [TwitterTweet]) -> Void in
            print ("I have the tweets: \(allTweets)")
            self.tweets = allTweets
            
        }, noSuccess: {(error: Error) -> Void in
            print ("\(error)")
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
