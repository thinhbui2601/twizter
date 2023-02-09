//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Thomas Bui on 2/21/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    var favorited:Bool = false
    var tweetId:Int = -1
    var retweeted: Bool = false
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tweetcontentLabel: UILabel!
    
    @IBOutlet weak var FavButton: UIButton!
    
    @IBOutlet weak var ReTweetButton: UIButton!
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        if (toBeFavorited){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (error) in
                print("this is the moment in life when you feel extremely desperate because you cant like that tweet because of this god damn \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print("this is the moment in life when you feel extremely desperate because you cant unlike that tweet because of this god damn \(error)")
            })
        }
    }
    
    @IBAction func Retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
             print("i am hungry \(error)")
        })
    }
    
    
    func setRetweeted(_ isRetweeted: Bool){
        if (isRetweeted){
            ReTweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            ReTweetButton.isEnabled = false
        } else {
            ReTweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            ReTweetButton.isEnabled = true
        }
    }
    
    
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if (favorited){
            FavButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            FavButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
