//
//  ProfileViewController.swift
//  Study Buddy
//
//  Created by Gaby Ecanow on 8/2/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var bioScrollView: UIScrollView!
    @IBOutlet weak var bio: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = Auth.auth().currentUser?.displayName
        email.text = Auth.auth().currentUser?.email
    }
}
