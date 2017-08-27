//
//  ViewController.swift
//  Study Buddy
//
//  Created by Gaby Ecanow on 7/30/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func onTappedSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func unwindToStart(segue: UIStoryboardSegue) {
        //unwind
    }
}

