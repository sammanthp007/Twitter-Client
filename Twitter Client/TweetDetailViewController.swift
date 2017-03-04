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
    @IBOutlet weak var retweetedActionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userNameLabel.text = tweet.name
        userHandleLabel.text = tweet.username
        tweetTextLabel.text = tweet.text
        // tweetCreatedOnLabel.text = tweet.timeStamp as Date
        // tweetCreatedTimeLabel.text =
        countRetweetLabel.text = String(tweet.retweetCount)
        countFavoritesLabel.text = String(tweet.favoritesCount)
        userPictureImage.setImageWith(tweet.imageUrl as URL)
        
        userPictureImage.layer.cornerRadius = 3
        userPictureImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReply(_ sender: Any) {
    }
    
    
    @IBAction func onRetweet(_ sender: Any) {
    }

    @IBAction func onFavorite(_ sender: Any) {
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
