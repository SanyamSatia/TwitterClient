//
//  User.swift
//  TwitterDemo
//
//  Created by Sanyam Satia on 2/17/17.
//  Copyright © 2017 Sanyam Satia. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenName: String?
    var headerImageUrl: URL?
    var profileImageUrl: URL?
    var tagline: String?
    var tweetCount: Int?
    var followingCount: Int?
    var followerCount: Int?
    var dictionary: NSDictionary?
    static let userDataKey = "UserDataKey"
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let profileImageUrlString = dictionary["profile_image_url_https"] as? String
        if let profileImageUrlString = profileImageUrlString {
            profileImageUrl = URL(string: profileImageUrlString)!
        }
        
        let headerImageUrlString = dictionary["profile_banner_url"] as? String
        if let headerImageUrlString = headerImageUrlString {
            headerImageUrl = URL(string: headerImageUrlString)!
        }
        
        tagline = dictionary["description"] as? String
        tweetCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
        
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let userData = UserDefaults.standard.object(forKey: userDataKey) as? Data
                
                if userData != nil {
                     let dictionary = try! JSONSerialization.jsonObject(with: userData!) as! NSDictionary
                     _currentUser = User(dictionary: dictionary)
                }
            }
 
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!)
                UserDefaults.standard.set(data, forKey: userDataKey)
            } else {
                UserDefaults.standard.set(nil, forKey: userDataKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
}
