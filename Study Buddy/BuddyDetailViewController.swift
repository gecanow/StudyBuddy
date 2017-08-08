//
//  BuddyDetailViewController.swift
//  Study Buddy
//
//  Created by Gaby Ecanow on 8/5/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class BuddyDetailViewController: UIViewController {
    
    var bud : Buddy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTappedBack(_ sender: Any) {
        self.performSegue(withIdentifier: "UnwindToBuddies", sender: self)
    }
    
    @IBAction func onTappedConnect(_ sender: Any) {
        if bud.id != nil && bud.id != "" {
            let messageRef = Database.database().reference().child("mailbox").child(bud.id)
            
            let itemRef = messageRef.childByAutoId()
            let messageItem = [
                "senderId": Auth.auth().currentUser?.uid,
                "senderName": Auth.auth().currentUser?.displayName,
                "text": "would like to connect with you!",
                ]
            
            itemRef.setValue(messageItem)
        } else {
            print("invalid buddy")
        }
    }
    
}
