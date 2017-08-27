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
    var ref: DatabaseReference! = Database.database().reference()
    var mailRef: DatabaseReference! = Database.database().reference().child("mailbox").child((Auth.auth().currentUser?.uid)!)
    var newMailRefHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeMail()
    }
    
    //=======================================
    // Handles data syncronization
    //=======================================
    private func observeMail() {
        let mailQuery = mailRef.queryLimited(toLast:25)
        
        // 2.
        newMailRefHandle = mailQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let mailData = snapshot.value as! Dictionary<String, String>
            
            if let id = mailData["senderId"] as String!, let name = mailData["senderName"] as String!, let text = mailData["text"] as String!, text.characters.count > 0 {
                // 4
                self.mailbox.append(Mail(id: id, name: name, text: text))
                self.setUpMailbox()
            } else {}
        })
    }
    
    func setUpMailbox() {
        print(mailbox.count)
        
        var index = 0
        for m in mailbox.reversed() {
            scrollView.addSubview(createNewMailLabel(num: index, forMail: m))
            index+=1
        }
        scrollView.contentSize = CGSize(width: 187, height: 44*mailbox.count+16)
    }
    
    func createNewMailLabel(num: Int, forMail: Mail) -> UIButton {
        let yCoord = Int((44*num)+8)
        let newButton = UIButton(frame: CGRect(x: 8, y: CGFloat(yCoord), width: 187, height: 37))
        newButton.titleLabel?.text = "Mail From: \((mailbox.reversed()[num].fromName)!)"
        newButton.backgroundColor = UIColor.cyan
        newButton.tag = num
        newButton.addTarget(self, action: #selector(mailAlert), for: .touchUpInside)
        return newButton
    }
    
    func mailAlert(sender: UIButton) {
        let t = "New Message From: \((mailbox.reversed()[sender.tag].fromName)!)"
        let m = mailbox.reversed()[sender.tag].text
        let alertController = UIAlertController(title: t, message: m, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (void) in
            // connect the two lucky buddies!
            self.createChatChannelBetween(self.mailbox.reversed()[sender.tag].fromID, (Auth.auth().currentUser?.uid)!)
            print("connection completed")
        }
        let cancelAction = UIAlertAction(title: "Decline", style: .cancel) { (void) in
            // declined :(
            print("connection declined")
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createChatChannelBetween(_ id1: String, _ id2: String) {
        let chatChannelRef = id1+id2
        
        ref.child("user").child(id1).child("chatChannelRef").setValue(chatChannelRef)
        ref.child("user").child(id2).child("chatChannelRef").setValue(chatChannelRef)
    }
    
}
