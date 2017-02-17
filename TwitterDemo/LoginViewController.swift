//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Sanyam Satia on 2/16/17.
//  Copyright © 2017 Sanyam Satia. All rights reserved.
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
    
    @IBAction func onLoginButtonClicked(_ sender: AnyObject) {
        let consumerKey = "Ig33ePdYSn89OTVoqjaWY6ghs"
        let consumerSecret = "ahoq7nHPZs5ZjfLwD74onBvJCIBnOwVrRNVtmIVttOyqZK9fDG"
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: consumerKey, consumerSecret: consumerSecret)
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "twitterdemo://oauth"),
            scope: nil,
            success: { (accessToken: BDBOAuth1Credential?) -> Void in
                print("I got a token")
                
                let urlPath = "https://api.twitter.com/oauth/authorize?oauth_token=" + (accessToken?.token)!
                let url = URL(string: urlPath)!
                UIApplication.shared.open(url)
            },
            failure: { (error: Error?) -> Void in
                print("Error: \(error?.localizedDescription)")
            }
        )
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
