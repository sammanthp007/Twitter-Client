//
//  LoginViewController.swift
//  Twitter Client
//
//  Created by samman on 2/28/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func twitterLoginButton(_ sender: Any) {
        // session manager: for making Get or Post requests using sessions
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com") as URL!, consumerKey: "Egs4PG34sQWvqD2zCLMjrHdOI", consumerSecret: "90GSSJxs9j6NJzUXbWJ7rkhu7jVXCTHJKfVcosDYlPVZLEIT9i")
        
        // logout before loging in, this is a BDBO OAUTH 1  manager, logout first
        twitterClient?.deauthorize()
        
        // fetch request token using a generic OAUTH one process for twitter to verify that the actual api holder is making this call
        // the path to the request token can be found in app.twitter.com page
        // in even of a sucess, request for my request token
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: nil, scope: nil, success: {
            (requestToken: BDBOAuth1Credential?) -> Void in
            print ("Received request token: \(requestToken?.token!)")
            
            // the url we want to take the users to in SAFARI
            let authorizeURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            
            // UIApplication.shared.open method is used to open other apps
            UIApplication.shared.open(authorizeURL!, options: [:], completionHandler: nil)
            
            
            
            
        }, failure: {
            (Error) in
            print ("Error \(Error?.localizedDescription)")
        })
        
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
