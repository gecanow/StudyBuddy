//
//  FindBuddiesViewController.swift
//  Study Buddy
//
//  Created by Gaby Ecanow on 8/3/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FindBuddiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var buddies = [Buddy]()
    var ref = Database.database().reference()
    @IBOutlet weak var buddyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buddyTableView.delegate = self
        findAllBuddies()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buddies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        let bud = buddies[indexPath.row]
        cell.textLabel?.text = bud.name
        
        return cell
    }
    
    func findAllBuddies() {
        ref.child("user").observe(.childAdded, with: { (snapshot) in
            let newBud = Buddy(bud: snapshot.childSnapshot(forPath: "userid").value as! String)
            self.buddies.append(newBud)
        })
    }
}
