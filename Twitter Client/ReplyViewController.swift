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
    
    
    @IBOutlet weak var tweetTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        print ("this is the reply setup code")
        // programmitically add the uibarbutton on the right
        let rightButton = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.done, target: self, action: #selector(onSend(_:)))
        
        self.navigationItem.rightBarButtonItem = rightButton

        // print all DEBUG
        // tweet.printTweetsUser()
        if reply == true {
            // set the name of the navigation controller
            self.title = self.tweet.name
            tweetTextField.text = "@\(tweet!.username) "
            tweetTextField.becomeFirstResponder()
        }
        else {
            // set the name of the navigation controller
            self.title = "Compose"
            print  ("this is a compose")
            tweetTextField.becomeFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSend(_ sender: Any) {
        let reply_id: String
        if self.reply == true {
            reply_id = tweet.idString!
        }
        else {
            reply_id = ""
        }
        TwitterClient.sharedTwitterClient?.reply(id: reply_id, text: tweetTextField.text!, reply: reply, success: {(response: TwitterTweet) in
            print ("Tweeted")
            print ("\(response)")
            
            // goes back one segue
            _ = self.navigationController!.popViewController(animated: true)
            
            
        }, faliure: {(error: Error) in
            print ("Error: \(error)")
            
            // also create a alert
            let errorAlertController = UIAlertController(title: "Error!", message: "\(error)", preferredStyle: .alert)
            // add ok button
            let errorAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                //dismiss
            }
            errorAlertController.addAction(errorAction)
            self.present(errorAlertController, animated: true)
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
