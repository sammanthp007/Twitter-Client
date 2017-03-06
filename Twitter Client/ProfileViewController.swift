//
//  ProfileViewController.swift
//  Twitter Client
//
//  Created by sammanios on 3/6/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user: TwitterUser!
    
    @IBOutlet weak var ProfilePicImageView: UIImageView!
    @IBOutlet weak var userHandlerLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var TweetsCountLabel: UILabel!
    @IBOutlet weak var BackgroundImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        ProfilePicImageView.setImageWith(user.profileURL!)
        userHandlerLabel.text = ("@\(user.screenname!)")
        userNameLabel.text = user.name!
        
        let followers = (user.dict?["followers_count"] as? Int) ?? 0
        followerCountLabel.text = "\(followers)"
        
        let following = (user.dict?["friends_count"] as? Int) ?? 0
        followingCountLabel.text =  "\(following)"
        
        let tweets = (user.dict?["statuses_count"] as? Int) ?? 0
        TweetsCountLabel.text = "\(tweets)"
        
        let bg_img_str = user.dict?["profile_background_image_url_https"] as! String
        let background_image_url = URL(string: bg_img_str)
        
        BackgroundImageView.setImageWith(background_image_url!)
        
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
