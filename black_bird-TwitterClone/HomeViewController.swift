//
//  HomeViewController.swift
//  black_bird-TwitterClone
//
//  Created by Kevin Douglass on 5/23/20.
//  Copyright © 2020 Kevin Douglass. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activeLoading: UIActivityIndicatorView!
    
    var tweetRef = Database.database().reference()
    var loggedInUser: NSDictionary? = .none
    
    // store tweets from database
    var tweets: [NSDictionary?] = []       // tweets init to empty array
    var loggedInUserData: AnyObject? = .none
    
    var defaultImageViewHeightConstraint: CGFloat = 77.0
    
    @IBOutlet weak var homeTableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.loggedInUser = Auth.auth().currentUser
       /**
         Get logged in user
         */
        let loggedIn_uid = Auth.auth().currentUser?.uid
        
        // get the logged in user details
        self.tweetRef.child("user_profiles").child(loggedIn_uid!).observeSingleEvent(of: .value) {
            (snapshot: DataSnapshot) in
            
            // store logged in user details into a variable
            self.loggedInUserData = snapshot.value as? NSDictionary
            print(self.loggedInUser)
            
            // get all the tweets that are made by the user
            //self.tweetRef = Database.database().reference().child("tweets")
            print("about to look at tweet snapshot")
            
            self.tweetRef.child("tweets").child(loggedIn_uid!).observe(.childAdded, with: { (snapshot: DataSnapshot) in
                // make sure there is tweets
                if snapshot.childrenCount > 0 {
                    print("(1) success!!")
                    
                        // append [tweets] array together for user-view
                    self.tweets.append(snapshot.value as! NSDictionary)
                    
                    self.homeTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
                    
                    self.activeLoading.stopAnimating()
                    
                }
                
            }) {(error) in
                
                print(error.localizedDescription)
            }
            
        }
        
        //self.homeTableView.rowHeight = UITableView.automaticDimension
        self.homeTableView.rowHeight = 100
        self.homeTableView.estimatedRowHeight = 140
        
        
    }
            

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
     }
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }

      // Cell for row at table view
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        let cell: HomeViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath) as! HomeViewTableViewCell

       // let cell: HomeViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath) as! HomeViewTableViewCell
        
        /**
         *For each row.. put tweets in this tweet variable
            -* because you want to show the "latest" tweet on top you need to pull from database in reverse order
         
         */
     //let tweet = (tweets[(self.tweets.count-1) - indexPath.row] as AnyObject).value(forKey: "text")
        let tweet = tweets[(self.tweets.count-1) - (indexPath.row)]!["text"] as! String
        /*
        if(tweets[(self.tweets.count-1) - (indexPath.row)]["picture"] != nil){
            cell.tweet
        }
 */
        if tweets.isEmpty {
            print("its empty")
        } else {
            print("something - not empty")
            for t in tweets{
                print(t)
            }
        }
        
        
       // let tweet = tweets[indexPath.row]

        cell.configure(profilePic: nil, name: self.loggedInUserData!.value(forKey: "name") as! String, handle: self.loggedInUserData!.value(forKey: "handle") as! String, tweet: tweet as! String)
        
        //cell.configure(profilePic: nil, name: "Preston", handle: "NIGGER", tweet: "Reaper")
        
         return cell
      }
    

}

