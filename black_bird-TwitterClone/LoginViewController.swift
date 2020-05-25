//
//  LoginViewController.swift
//  black_bird-TwitterClone
//
//  Created by Kevin Douglass on 5/21/20.
//  Copyright © 2020 Kevin Douglass. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var errorMessage: UILabel!
    
    
    var rootRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapCancel(_ sender: Any) {
        // dismiss cancel button when pressed
        dismiss(animated: true, completion: nil)
        
    }
  
    @IBAction func didTapLogin(_ sender: Any) {
        // on login -> user sign in with email
        // user can login and NOT save/ make Handle
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) {
            (user, error) in
            
            // if there is no errors
            if(error == nil) {
                // make the user get a handle
                self.rootRef.child("user_profiles").child(user!.user.uid).child("handle").observeSingleEvent(of: .value) {
                    (snapshot: DataSnapshot) in
                    
                    if(snapshot.exists() == false) {
                        // user does not have a handle, so...
                        // send the user to the handleView to create one
                        self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                    }
                    else{
                         // send user to homeScreen
                        self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                    }
                }
            } else {
                // send error to USER
                self.errorMessage.text = error?.localizedDescription
            }
        }
    }
    
}
