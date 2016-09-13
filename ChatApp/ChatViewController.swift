//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Karim on 11/09/16.
//  Copyright © 2016 KRS. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var destId: String!
    var conversationId: String!
    var messages = [JSQMessage]()
    var ref: FIRDatabaseReference!
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        self.navigationItem.title = destId
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero

        ref = FIRDatabase.database().reference()
        
        setupBubbles()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        observeMessages()
    }

    private func observeMessages() {
       
        let messageRef = ref.child("/conversations/\(conversationId)/\(destId)")

        let messagesQuery = messageRef.queryLimitedToLast(25)
        
        messagesQuery.observeEventType(.Value, withBlock: { snapshot in
            self.messages.removeAll()

            for item in snapshot.children {
                let id = item.value!["senderId"] as? String
                let text = item.value!["text"] as? String
            
                if id != nil && text != nil {
                    self.addMessage(id!, text: text!)
                }
            
                self.finishReceivingMessage()
            }
        })
 
        }
    

    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }


    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
        
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        
        let itemRef = ref.child("/conversations/\(conversationId)/\(destId)").childByAutoId() // 1
        let post = ["text": text,
                    "senderId": senderId]
        itemRef.setValue(post)
 
        let duplicateRef = ref.child("/conversations/\(destId)/\(conversationId)").childByAutoId() // 1
        let dupPost = ["text": text,
                    "senderId": senderId]
        duplicateRef.setValue(dupPost)
        
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        addMessage(senderId, text: text)
        
        finishSendingMessage()
    }

}

