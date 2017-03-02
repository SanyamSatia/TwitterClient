//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Sanyam Satia on 2/24/17.
//  Copyright © 2017 Sanyam Satia. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
        
        let refreshControl  = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogoutButtonClicked(_ sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(TweetsViewController.profileImageClicked(gesture:)))
        cell.profileImageView.addGestureRecognizer(profileImageTapGesture)
        cell.profileImageView.isUserInteractionEnabled = true
        
        return cell
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
                refreshControl.endRefreshing()
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tweetDetailsSegue", sender: nil)
    }
    
    func profileImageClicked(gesture: UIGestureRecognizer) {
        performSegue(withIdentifier: "userProfileSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            if segue.identifier == "tweetDetailsSegue" {
                let viewController = segue.destination as! TweetDetailsViewController
                viewController.tweet = self.tweets[indexPath.row]
            }
            else if segue.identifier == "userProfileSegue" {
                let viewController = segue.destination as! UserProfileViewController
            }
        }
    }

}
