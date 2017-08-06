//
//  BuddyDetailViewController.swift
//  Study Buddy
//
//  Created by Gaby Ecanow on 8/5/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

class BuddyDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTappedBack(_ sender: Any) {
        self.performSegue(withIdentifier: "UnwindToBuddies", sender: self)
    }
}
