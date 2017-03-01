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
    
    var tweet : TwitterTweet! {
        didSet {
            print(tweet.text!)
            print(String(describing: tweet.imageUrl))
            tweetText.text = tweet.text
            thumbnailImageView.setImageWith(tweet.imageUrl as! URL)
            print(tweet.name)
            displayNameLabel.text = tweet.name
            
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
