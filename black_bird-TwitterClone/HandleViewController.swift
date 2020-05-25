//
//  HandleViewController.swift
//  black_bird-TwitterClone
//
//  Created by Kevin Douglass on 5/22/20.
//  Copyright © 2020 Kevin Douglass. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class HandleViewController: UIViewController {

   
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var handle: UITextField!
    @IBOutlet weak var startTweeting: UIBarButtonItem!
    @IBOutlet weak var errorMessage: UILabel!
    
    /** Define variable and store Optional<AnyObject> inside */
    // old swift 2.0 was var user = AnyObject?()
    var user: AnyObject? = .none
    // user = Optional<AnyObject>.init()
    
    // create database reference for twitter @handle
    var rootRef = Database.database().reference()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.user = Auth.auth().currentUser
        self.user = Auth.auth().currentUser
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapStartTweeting(_ sender: Any) {
        // ensure twitter handle NOT-IN-USE
        let uid = Auth.auth().currentUser?.uid
        /*
        //let handle: Void =
 */
       // let handle = self.rootRef.child("Handles").child(self.handle.text!).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
       
        let handle = self.rootRef.child("Handles").child(self.handle.text!).observeSingleEvent(of: .value) {
            (snapshot: DataSnapshot) in
        
            // check if the Handle node exists for the current user
            if(!snapshot.exists()){

                // update the handle in user_profiles and in the handles node
                self.rootRef.child("user_profiles").child(uid!).child("handle").setValue(self.handle.text!)
                // could make sure its lowercase by adding the .lowercaseString to end of functi
                // update the NAME of user to FULL NAME of the user
                self.rootRef.child("user_profiles").child(uid!).child("name").setValue(self.fullName.text!)

                // update the handle in the handle Node
                self.rootRef.child("Handles").child(self.handle.text!).setValue(uid)

                // send the user to the Home Screen
                // by segue
                self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)

            }
            else {
                // otherwise .. the snapshot already exists
                self.errorMessage.text = "Handle already in use!"

            }
  
        }
    }
    
    
    
    @IBAction func didTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
