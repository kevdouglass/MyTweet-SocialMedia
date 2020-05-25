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
    
    var databaseRef = Database.database().reference()
    var loggedInUser: AnyObject? = .none
    
    // store tweets from database
    var tweets: [AnyObject?] = []       // tweets init to empty array
    var loggedInUserData: AnyObject? = .none
    
    
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
        self.databaseRef.child("user_profiles").child(loggedIn_uid!).observeSingleEvent(of: .value) {
            (snapshot: DataSnapshot) in
            
            // store logged in user details into a variable
            self.loggedInUserData = snapshot
            
            // get all the tweets that are made by the user
           //
            self.databaseRef.child("/tweets/\(loggedIn_uid!)").observeSingleEvent(of: .childAdded) {
                (snapshot: DataSnapshot) in
                
                // append [tweets] array together for user-view
                self.tweets.append(snapshot)
                
                //self.homeTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
                self.homeTableView.insertRows(at: [IndexPath(row:self.tweets.count-1,section:0)], with: UITableView.RowAnimation.automatic)

               // change behavior of active loading
                self.activeLoading.stopAnimating()
                } // error subroutine here
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
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
        let tweet = tweets[indexPath.row]

        cell.configure(profilePic: nil, name: self.loggedInUserData!.value(forKey: "Name") as! String, handle: self.loggedInUserData!.value(forKey: "handle") as! String, tweet: tweet as! String)
        
        
         return cell
      }
    

}

