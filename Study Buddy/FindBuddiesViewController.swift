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

class FindBuddiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var allBuddies = [Buddy]()
    var displayBuddies = [Buddy]()
    var tappedBud = Buddy(bud: "")
    
    var ref = Database.database().reference()
    @IBOutlet weak var buddyTableView: UITableView!
    @IBOutlet weak var buddySearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatCell()
        
        buddyTableView.delegate = self
        buddyTableView.dataSource = self
        buddySearchBar.delegate = self
        
        findAllBuddies()
    }
    
    func formatCell() {
        let cell = buddyTableView.dequeueReusableCell(withIdentifier: "MyCell")
        cell?.textLabel?.font = UIFont(name: "Avenir Next Condensed", size: 20)
        cell?.textLabel?.textColor = UIColor.cyan
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayBuddies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        let bud = displayBuddies[indexPath.row]
        cell.textLabel?.text = bud.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedBud = displayBuddies[indexPath.row]
        self.performSegue(withIdentifier: "ToBuddyDetail", sender: self)
    }
    
    func findAllBuddies() {
        ref.child("user").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.childSnapshot(forPath: "userid").value as! String
            let name = snapshot.childSnapshot(forPath: "name").value as! String
            let email = snapshot.childSnapshot(forPath: "email").value as! String
            self.allBuddies.append(Buddy(bud: id, called: name, at: email))
            
            self.displayBuddies = self.allBuddies
            self.refreshUI()
        })
    }
    
    func searchForBuddyNames(withText: String) {
        var tempBuddyList = [Buddy]()
        
        for b in self.allBuddies {
            if b.lowercaseName.contains(withText.lowercased()) {
                tempBuddyList.append(b)
            }
        }
        
        displayBuddies = tempBuddyList
        refreshUI()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchForBuddyNames(withText: searchText)
        } else {
            displayBuddies = allBuddies
            refreshUI()
        }
    }
    
    func refreshUI() {
        DispatchQueue.main.async {
            self.buddyTableView.reloadData()
        }
    }
    
    @IBAction func onTappedBack(_ sender: Any) {
        self.performSegue(withIdentifier: "UnwindToStudyRoom", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! BuddyDetailViewController
        dvc.bud = tappedBud
    }
    
    
}
