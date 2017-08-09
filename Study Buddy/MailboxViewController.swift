//
//  MailboxViewController.swift
//  Study Buddy
//
//  Created by Gaby Ecanow on 8/8/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MailboxViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var mailbox = [Mail]()
    var mailRef: DatabaseReference! = Database.database().reference().child("mailbox").child((Auth.auth().currentUser?.uid)!)
    var newMailRefHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpMailbox()
    }
    
    func setUpMailbox() {
        self.observeMail()
        print(mailbox.count)
        
        var index = 0
        for m in mailbox.reversed() {
            scrollView.addSubview(createNewMailLabel(num: index, forMail: m))
            index+=1
        }
        scrollView.contentSize = CGSize(width: 187, height: 44*mailbox.count+16)
    }
    
    func createNewMailLabel(num: Int, forMail: Mail) -> UILabel {
        let yCoord = Int((44*num)+8)
        let newLab = UILabel(frame: CGRect(x: 8, y: CGFloat(yCoord), width: 187, height: 37))
        
        newLab.font = UIFont(name: "Avenir Next Condensed", size: 14)
        newLab.backgroundColor = UIColor.cyan
        newLab.text = forMail.fromName + " " + forMail.text
        return newLab
    }
    
    
    //=======================================
    // Handles data syncronization
    //=======================================
    private func observeMail() {
        print("HERE< OBSERVING MAIL!")
        let mailQuery = mailRef.queryLimited(toLast:25)
        
        // 2.
        newMailRefHandle = mailQuery.observe(.childAdded, with: { (snapshot) -> Void in
            print("here!")
            // 3
            let mailData = snapshot.value as! Dictionary<String, String>
            print("MAIL DATA: \(mailData)")
            
            if let id = mailData["senderId"] as String!, let name = mailData["senderName"] as String!, let text = mailData["text"] as String!, text.characters.count > 0 {
                // 4
                self.loadMail(withId: id, name: name, text: text)
                
                // 5
                //self.finishReceivingMessage()
            } else {}
        })
    }
    
    func loadMail(withId: String, name: String, text: String) {
        mailbox.append(Mail(id: withId, name: name, text: text))
    }
}
