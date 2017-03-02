//
//  UserProfileViewController.swift
//  TwitterDemo
//
//  Created by Sanyam Satia on 3/1/17.
//  Copyright © 2017 Sanyam Satia. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    var screenName: String!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TwitterClient.sharedInstance.userInfo(screenName: screenName, success: { (user: User) in
            self.user = user
            self.setupView()
        }) { (error: Error) in
            print("Error: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        usernameLabel.text = user.name
        handleLabel.text = "@" + user.screenName!
        
        if user.headerImageUrl != nil {
            headerImageView.setImageWith(user.headerImageUrl!)
        }
        
        if user.profileImageUrl != nil {
            userProfileImageView.setImageWith(user.profileImageUrl!)
            userProfileImageView.layer.cornerRadius = 3
            userProfileImageView.layer.borderColor = UIColor.white.cgColor
            userProfileImageView.layer.borderWidth = 3
            userProfileImageView.clipsToBounds = true
        }
        
        descriptionLabel.text = user.tagline
        tweetCountLabel.text = "\(user.tweetCount!)"
        followerCountLabel.text = "\(user.followerCount!)"
        followingCountLabel.text = "\(user.followingCount!)"
    }

}
