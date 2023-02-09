//
//  TweetViewController.swift
//  Twitter
//
//  Created by Thomas Bui on 2/27/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        TweetTextView.becomeFirstResponder()
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func TweetPost(_ sender: Any) {
        if (!TweetTextView.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: TweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure:{ (error) in
                print("Eh..eh try again ?\(error)")
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var TweetTextView: UITextView!
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
