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
import FirebaseAuth
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var ref = Database.database().reference()
    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    private lazy var messageRef: DatabaseReference! = self.ref.child("chatChannel").child((Auth.auth().currentUser?.uid)!)
    private var newMessageRefHandle: DatabaseHandle?
    
    //=======================================
    // VIEW DID LOAD
    //=======================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderDisplayName = Auth.auth().currentUser?.displayName
        self.senderId = Auth.auth().currentUser?.uid
        self.addViewOnTop()
        self.observeMessages()
    }
    
    func addViewOnTop() {
        let top = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70))
        top.backgroundColor = .cyan
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: 100, height: 16))
        titleLabel.text = "Chat Room"
        
        let backButton = UIButton(frame: CGRect(x: 5, y: 5, width: 30, height: 20))
        backButton.setTitle("< Back", for: .normal)
        backButton.addTarget(self, action: #selector(onTappedBack), for: .touchUpInside)
        
        top.addSubview(titleLabel)
        top.addSubview(backButton)
        view.addSubview(top)
        
        self.collectionView?.collectionViewLayout.sectionInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
    }
    
    func onTappedBack() {
        self.performSegue(withIdentifier: "UnwindToStudyRoom", sender: self)
    }
    
    //=======================================
    // Handles the messages of the collection
    // view
    //=======================================
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    //=======================================
    // Handles creating the outgoing and
    // incoming bubbles
    //=======================================
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    //=======================================
    // Handles the avitar creation
    //=======================================
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImage(placeholder: #imageLiteral(resourceName: "defaultProfile"))
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    //=======================================
    // Handles sending messages
    //=======================================
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    //=======================================
    // Handles data syncronization
    //=======================================
    private func observeMessages() {
        // 1.
        let messageQuery = messageRef.queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                // 4
                self.addMessage(withId: id, name: name, text: text)
                
                // 5
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
}
