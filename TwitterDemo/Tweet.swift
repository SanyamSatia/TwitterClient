//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Sanyam Satia on 2/17/17.
//  Copyright © 2017 Sanyam Satia. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var id: Int?
    var username: String?
    var handle: String?
    var profileImageUrl: URL?
    var timeStamp: Date?
    var retweetCount: Int?
    var retweeted: Bool?
    var favoriteCount: Int?
    var favorited: Bool?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        id = dictionary["id"] as? Int
        
        let userData = dictionary["user"] as! NSDictionary
        username = userData["name"] as? String
        handle = userData["screen_name"] as? String
        
        let imageUrl = userData["profile_image_url_https"] as? String
        if let imageUrl = imageUrl {
            profileImageUrl = URL(string: imageUrl)
        }
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as? Bool
        
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        favorited = dictionary["favorited"] as? Bool
        
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampString)
        }
        
    }
    
    class func tweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets: [Tweet] = []
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
