//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Thomas Bui on 2/21/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    @IBAction func onLogOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    var tweetArray = [NSDictionary]()
    var numberoftweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.usernameLabel.text = (user["name"] as? String)
        cell.tweetcontentLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        let imgUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imgUrl!)
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        return cell
    }
    
    @objc func tweetsload(){
        
        numberoftweets = 25

        let theUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count":numberoftweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: theUrl, parameters: params, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("failed, bleh!")
        })
    }
    
    func tweetsmore(){
        let theUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberoftweets = numberoftweets + 25
        let params = ["count": numberoftweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: theUrl, parameters: params, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("failed, bleh!")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath:IndexPath){
        if indexPath.row+1 == tweetArray.count {
            tweetsmore()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRefreshControl.addTarget(self, action: #selector(tweetsload), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        tweetsload()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 140
         
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tweetsload()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }


}
