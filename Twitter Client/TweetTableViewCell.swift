//
//  TweetTableViewCell.swift
//  Twitter Client
//
//  Created by samman on 3/1/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var tweet : TwitterTweet! {
        didSet {
            print(tweet.text!)
            print(String(describing: tweet.imageUrl))
            tweetText.text = tweet.text
            thumbnailImageView.setImageWith(tweet.imageUrl as! URL)
            print(tweet.name)
            displayNameLabel.text = tweet.name
            print(tweet.username)
            usernameLabel.text = "@\(tweet.username)"
            print(tweet.retweetCount)
            print(tweet.favoritesCount)
            retweetCountLabel.text = String(tweet.retweetCount)
            favCountLabel.text = String(tweet.favoritesCount)
            
            // for time label
            if let timeStamp = tweet.timeStamp {
                timeStampLabel.text = TwitterClient.timeSince(timeStamp: timeStamp as Date)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailImageView.layer.cornerRadius = 3
        thumbnailImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
