//
//  ConversationsViewController.swift
//  ChatApp
//
//  Created by Karim on 11/09/16.
//  Copyright © 2016 KRS. All rights reserved.
//

import UIKit
import Firebase

class ConversationsViewController: UIViewController {
    
    var conversationSelected: Conversation!
    var ref: FIRDatabaseReference!
    var currentUser: String!
    var conversationsView: ConversationsView {
        return view as! ConversationsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Chats"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let userName = defaults.stringForKey("currentUser") {
            currentUser = userName
        }

        
        setupTableView()
        ref = FIRDatabase.database().reference()
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.child("conversations/\(currentUser)").observeEventType(.Value, withBlock: { snapshot in
            Conversations.resetConversations()
            
            for item in snapshot.children {

                let conversation = Conversation(name: item.key!! )
                
                Conversations.addConversation(conversation)
                
            }
            
            self.conversationsView.tableView.reloadData()
        })
        
    }

}


extension ConversationsViewController {
    
    private func setupTableView() {
        conversationsView.tableView.delegate = self
        conversationsView.tableView.dataSource = self
        conversationsView.tableView.tableFooterView = UIView()
        
    }
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Conversations.countConversations()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ConversationsViewTableViewCellIdentifier.Normal.rawValue)! as UITableViewCell
        
        
        let conversation = Conversations.getConversationFromIndexPath(indexPath)
        
        
        cell.textLabel?.text = conversation?.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        conversationSelected = Conversations.getConversationFromIndexPath(indexPath)
        self.hidesBottomBarWhenPushed = true
        
        self.performSegueWithIdentifier("conver_chat_segue", sender: self)
        self.hidesBottomBarWhenPushed = false
        
    }
}

extension ConversationsViewController {
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        
        let chatVc = segue.destinationViewController as! ChatViewController
        
        chatVc.conversationId = currentUser
        chatVc.senderId = currentUser
        chatVc.senderDisplayName = ""
        chatVc.destId = conversationSelected.name
    }
    
    
    
    
}

