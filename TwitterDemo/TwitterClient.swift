//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Sanyam Satia on 2/17/17.
//  Copyright © 2017 Sanyam Satia. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let consumerKey = "Ig33ePdYSn89OTVoqjaWY6ghs"
    static let consumerSecret = "ahoq7nHPZs5ZjfLwD74onBvJCIBnOwVrRNVtmIVttOyqZK9fDG"
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(
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
                self.loginFailure?(error!)
            }
        )
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance?.fetchAccessToken(
            withPath: "oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: { (accessToken: (BDBOAuth1Credential?)) -> Void in
                
                self.currentAccount(success: { (user: User) in
                        User.currentUser = user
                        self.loginSuccess?()
                    }, failure: { (error: Error) in
                        self.loginFailure?(error)
                })
            },
            failure: { (error: Error?) -> Void in
                self.loginFailure?(error!)
            }
        )
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        TwitterClient.sharedInstance?.get(
            "1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsFromArray(dictionaries: dictionaries)
                success(tweets)
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                failure(error)
            }
        )
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        TwitterClient.sharedInstance?.get(
            "1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                
                success(user)
            },
            failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                failure(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
}
