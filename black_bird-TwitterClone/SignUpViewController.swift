//
//  SignUpViewController.swift
//  black_bird-TwitterClone
//
//  Created by Kevin Douglass on 5/21/20.
//  Copyright © 2020 Kevin Douglass. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController {


    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signup: UIBarButtonItem!
    
    /*
    *        to read and write from your *database.. use FIRDatabase doc: https://firebase.google.com/docs/database/ios/read-and-write
     */
    var databaseRef = Database.database().reference()
    //(deprecate)FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        /**
                        Disable sign up button
         */
        signup.isEnabled = false

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapCancel(_ sender: Any) {
        // to listen to cancel and go ba kc
        dismiss(animated: true, completion: nil)
    }
    
    
    func showErrors(_ message: String?) {
             errorMessage.text = message
             errorMessage.alpha = 1 // make sure error is visible
    }
    
    // momemnt the user taps sign up
    @IBAction func didTapsignup(_ sender: Any) {
        
/*
         validate the fields
 **/
        
        let myerror = validateFields()
        signup.isEnabled  = false // make sure cant press signup again
        
        if myerror != nil {
/*
    there myust be something wrong with the fields -> show the error msg
**/
            showErrors(myerror!)
        } else {
            /**
                Create the user
             */
            Auth.auth().createUser(withEmail: email.text!, password: passwordTextField.text!) { (usr, err) in
                /**
                 Check for errors
                 
                 */
                if (err != nil) {
                    
                    // if it comes in here there was an error
                    self.showErrors("Error creating user")
                    self.errorMessage.text = "Invalid email Address"
                    self.errorMessage.text = err?.localizedDescription
                    
                } else {
                    
                    //self.showErrors("Registered Succesfully")
                    self.errorMessage.text = "Regsitered Succesfully"
                    // User was created successfully,
                    /**
                     Now store the email
                     */
                    Auth.auth().signIn(withEmail: self.email.text!, password: self.passwordTextField.text!) { (usr, err) in
                        if(err == nil){
                            self.databaseRef.child("user_profiles").child(usr!.user.uid).child("email").setValue(self.email.text!)
                            
                            /**
                                Handle the segue
                             */
                            self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                        }
                        
                    }
                }
            }
        }
        
        
      /*
        // create user with email
        Auth.auth().createUser(withEmail: email.text!, password: passwordTextField.text!) { (result, error) in
            // check for errors
            if(error != nil)
            {
                if (error! == 17999)
                {
                    self.errorMessage = "Invalid email adress"
                }
                else {
                    self.errorMessage = error?.localizedDescription
                }
            }
            else {
                self.errorMessage = "Registered Successfully"
                // firebase alone stores result/user in database
                Auth.auth().signIn(withEmail: self.email.text!, password: self.passwordTextField.text!) { (result, error) in
                    self.databaseRef.child("user_profiles").child()
                }
            }
          
        }
        
        */
        
    
    }
    
    /**
        - check to see if text has changed email/pass
     */
    
    
    
   
    @IBAction func textDidChange(_ sender: UITextField) {
        // one wa to make sure there is text in feild if(email.text?.characters.count > 0
              
              // check that fields are filled in...
              if((email.text?.trimmingCharacters(in: .whitespacesAndNewlines)) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                  
                  signup.isEnabled = false // make sure sign up button disabled until text appears
              } else {
                  signup.isEnabled = true // otherwise ENABLE signup button
              }
    }
  
        
    
    

func validateFields() -> String? {
    // check if feilds are filled in
    //if(email
    return nil
    }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
