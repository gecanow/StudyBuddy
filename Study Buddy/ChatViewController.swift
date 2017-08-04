//
//  ChatViewController.swift
//  Study Buddy
//
//  Created by Gaby Ecanow on 8/3/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderDisplayName = Auth.auth().currentUser?.displayName
        self.senderId = Auth.auth().currentUser?.uid
    }
}
