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
    
    
    @IBOutlet weak var tweetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // set the name of the navigation controller
        self.title = tweet.name
        
        print ("this is the reply setup code")
        let rightButton = UIBarButtonItem(title: "Right Button", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onSend(_:)))
        
        self.navigationItem.rightBarButtonItem = rightButton

        // print all DEBUG
        // tweet.printTweetsUser()
        if reply == true {
            tweetTextField.text = "@\(tweet!.username) "
            tweetTextField.becomeFirstResponder()
        }
        else {
            print  ("this is a compose")
            tweetTextField.becomeFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSend(_ sender: Any) {
        TwitterClient.sharedTwitterClient?.reply(id: tweet.idString!, text: tweetTextField.text!, reply: reply, success: {(response: TwitterTweet) in
            print ("success >>>>>>>>>>>>>>>")
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
