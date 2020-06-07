//
//  HomeViewTableViewCell.swift
//  black_bird-TwitterClone
//
//  Created by Kevin Douglass on 5/23/20.
//  Copyright © 2020 Kevin Douglass. All rights reserved.
//

/**
    Make this class *PUBLIC - so other parts of the program can access it
 */
import UIKit

public class HomeViewTableViewCell: UITableViewCell {

    /**
                Outlet to Prototype Cell/ Users msgs/ Tweets
     */
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var tweet: UITextView!
    //    struct homeCell {
//        var homeImage: UIImage
//    }
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    /**
     Configure a user
     */
    // takes string for profile pic - from profile(ME) tab to store in database
    // name, handle, tweet is passed in as of type string
    public func configure(profilePic: String?, name: String, handle: String, tweet: String) {
        
        self.tweet.text = tweet
        self.name.text = name
        self.handle.text = "@"+handle
        
        
        // check if there is a profile pic
        if(profilePic != nil){
           // force unwrap profilePic & force unwrap NSURL to get contents
            let imageData: Data = try! Data(contentsOf: URL(string: profilePic!)!)
            self.profilePic.image = UIImage(data: imageData)
            
        }
        else {
            // set the default as twitter logo
            self.profilePic.image = UIImage(named: "twitter")
        }
        
    }
    
    
    
}
