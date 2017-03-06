//
//  TweetDetailViewController.swift
//  Twitter Client
//
//  Created by samman on 3/4/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: TwitterTweet!
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedOnLabel: UILabel!
    @IBOutlet weak var tweetCreatedTimeLabel: UILabel!
    @IBOutlet weak var countRetweetLabel: UILabel!
    @IBOutlet weak var countFavoritesLabel: UILabel!
    @IBOutlet weak var userPictureImage: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetedActionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userNameLabel.text = tweet.name
        userHandleLabel.text = tweet.username
        tweetTextLabel.text = tweet.text
        // tweetCreatedOnLabel.text = tweet.timeStamp as Date
        // tweetCreatedTimeLabel.text =
        
        if (tweet.favorite == true) {
            favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        }
        countRetweetLabel.text = String(tweet.retweetCount)

        
        if (tweet.retweet == true) {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
        } else {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        }
        countFavoritesLabel.text = String(tweet.favoritesCount)
        
        
        userPictureImage.setImageWith(tweet.imageUrl as URL)
        userPictureImage.layer.cornerRadius = 3
        userPictureImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if (tweet.retweet == true) {
            // unretweet
            TwitterClient.sharedTwitterClient?.unretweet(tweet: self.tweet, success: {(ret_tweet: TwitterTweet) in
                print ("untweeted")
                self.tweet = ret_tweet
                
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .selected)

                self.countRetweetLabel.text = String(self.tweet.retweetCount)
                self.tweet.retweet = false
            }, failure: {(error: Error) in
                print (error.localizedDescription)
            })
        } else {
            // retweet
            TwitterClient.sharedTwitterClient?.retweet(tweet: self.tweet, success: {(ret_tweet) -> () in
                self.tweet = ret_tweet
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
                self.countRetweetLabel.text = String(self.tweet.retweetCount)
                self.tweet.retweet = true

            }, failure: {(error: Error) in
                print (error.localizedDescription)
            })
        }
    }

    @IBAction func onFavorite(_ sender: Any) {
        if (tweet.favorite == true) {
            print("favorited")
            TwitterClient.sharedTwitterClient?.unfavorite(tweet: self.tweet, success: {(ret_tweet) in
                self.tweet = ret_tweet
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
                self.countFavoritesLabel.text = String(ret_tweet.favoritesCount)
            }, failure: {(error: Error) in
                print("Error: \(error)")
            })
        }
        else {
            TwitterClient.sharedTwitterClient?.favorite(tweet: self.tweet, success: {(ret_tweet) in
                self.tweet = ret_tweet
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
                self.countFavoritesLabel.text = String(ret_tweet.favoritesCount)
            }, failure: {(error) in
                print("Error: \(error)")
            })
        }
    }
    
    
    // on reply
    
    @IBAction func onReply(_ sender: Any) {
        self.performSegue(withIdentifier: "replySegue", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "replySegue" {
            let controller = segue.destination as! ReplyViewController
            
            // give user info to the next page
            
            var userInfo: NSDictionary
            userInfo = self.tweet.userDictionary
            
            controller.user = TwitterUser(dict: userInfo)
            
            // set that this is in reply to a status
            controller.reply = true
            
            print ("to reply Segue")
        }
    }

}
