//
//  NewTweetViewController.swift
//  black_bird-TwitterClone
//
//  Created by Kevin Douglass on 5/23/20.
//  Copyright © 2020 Kevin Douglass. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewTweetViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var newTweetTextView: UITextView!
    var databaseRef = Database.database().reference()
    var loggedInUser: AnyObject? = .none
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loggedInUser = Auth.auth().currentUser
        newTweetTextView.textContainerInset = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        newTweetTextView.text = "What's happening?"
        newTweetTextView.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapStop(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    // resign keyboard..
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    
    
    // if user begins editing textview to tweet
    // check if text is grey ..
    // if it is, take away prompt
    // set new text to black
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(newTweetTextView.textColor == UIColor.lightGray){
            newTweetTextView.text = ""
            newTweetTextView.textColor = UIColor.black
        }
    }
    
    
    @IBAction func didTapTweet(_ sender: Any) {
       // if(newTweetTextView.hasText) {
           // if((email.text?.trimmingCharacters(in: .whitespacesAndNewlines)) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        if((newTweetTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)) != "")
        {
            let n_uid = Auth.auth().currentUser?.uid
            
            guard let key = databaseRef.child("tweets").childByAutoId().key else { return }
            
            //let post = ["uid": n_uid]
            //let childUpdates: [AnyHashable : Any]  = ["/tweets/\(key)" : [String?], "/tweets/\(n_uid!)/\(key)"]
            
            let childUpdates = ["/tweets/\(n_uid!)/\(key)/text": newTweetTextView.text,
                                "/tweets/\(n_uid!)/\(key)/timestamp":"\(NSDate().timeIntervalSince1970)"] as [String : Any]
            
            self.databaseRef.updateChildValues(childUpdates)
            
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}
