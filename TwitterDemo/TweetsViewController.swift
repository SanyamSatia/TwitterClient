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
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.33, green:0.67, blue:0.93, alpha:1.0)
        navigationController?.navigationBar.isTranslucent = false
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
