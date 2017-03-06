//
//  ReplyViewController.swift
//  Twitter Client
//
//  Created by sammanios on 3/6/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    var tweet: TwitterTweet!
    var reply: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // set the name of the navigation controller
        self.title = tweet.name
        
        // print all DEBUG
        tweet.printTweetsUser()
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
