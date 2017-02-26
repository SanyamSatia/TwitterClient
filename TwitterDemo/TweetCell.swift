//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Sanyam Satia on 2/25/17.
//  Copyright © 2017 Sanyam Satia. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleTimeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            usernameLabel.text = tweet.username
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd"
            let dateString = dateFormatter.string(from: tweet.timeStamp!)
            handleTimeLabel.text = tweet.handle! + " · " + dateString
            
            if tweet.profileImageUrl != nil {
                profileImageView.setImageWith(tweet.profileImageUrl!)
            }
            
            updateRetweetCount()
            
            if tweet.retweeted! {
                retweetIcon.image = UIImage(named: "retweet-icon-green")
            } else {
                retweetIcon.image = UIImage(named: "retweet-icon")
            }
            
            updateFavoriteCount()
            
            if tweet.favorited! {
                favoriteIcon.image = UIImage(named: "favor-icon-red")
            } else {
                favoriteIcon.image = UIImage(named: "favor-icon")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        let retweetTapGesture = UITapGestureRecognizer(target: self, action: #selector(TweetCell.retweetIconClicked(gesture:)))
        retweetIcon.addGestureRecognizer(retweetTapGesture)
        retweetIcon.isUserInteractionEnabled = true
        
        let favoriteTapGesture = UITapGestureRecognizer(target: self, action: #selector(TweetCell.favoriteIconClicked(gesture:)))
        favoriteIcon.addGestureRecognizer(favoriteTapGesture)
        favoriteIcon.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func retweetIconClicked(gesture: UIGestureRecognizer) {
        if tweet.retweeted! {
            TwitterClient.sharedInstance.unretweet(tweetId: tweet.id!, success: {
                    print("unretweeted")
                    self.tweet.retweeted = false
                    self.tweet.retweetCount = self.tweet.retweetCount! - 1
                    self.retweetIcon.image = UIImage(named: "retweet-icon")
                    self.updateRetweetCount()
                }, failure: { (error: Error) in
                    print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance.retweet(tweetId: tweet.id!, success: {
                    print("retweeted")
                    self.tweet.retweeted = true
                    self.tweet.retweetCount = self.tweet.retweetCount! + 1
                    self.retweetIcon.image = UIImage(named: "retweet-icon-green")
                    self.updateRetweetCount()
                }, failure: { (error: Error) in
                    print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    func favoriteIconClicked(gesture: UIGestureRecognizer) {
        if tweet.favorited! {
            TwitterClient.sharedInstance.unfavorite(tweetId: tweet.id!, success: {
                    print("unfavorited")
                    self.tweet.favorited = false
                    self.tweet.favoriteCount = self.tweet.favoriteCount! - 1
                    self.favoriteIcon.image = UIImage(named: "favor-icon")
                    self.updateFavoriteCount()
                }, failure: { (error: Error) in
                    print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance.favorite(tweetId: tweet.id!, success: {
                    print("favorited")
                    self.tweet.favorited = true
                    self.tweet.favoriteCount = self.tweet.favoriteCount! + 1
                    self.favoriteIcon.image = UIImage(named: "favor-icon-red")
                    self.updateFavoriteCount()
                }, failure: { (error: Error) in
                    print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    func updateRetweetCount() {
        if tweet.retweetCount! > 0 {
            retweetCountLabel.text = "\(tweet.retweetCount!)"
        } else {
            retweetCountLabel.text = ""
        }
    }
    
    func updateFavoriteCount() {
        if tweet.favoriteCount! > 0 {
            favoriteCountLabel.text = "\(self.tweet.favoriteCount!)"
        } else {
            favoriteCountLabel.text = ""
        }
    }

}
