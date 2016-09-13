//
//  UsersViewController.swift
//  ChatApp
//
//  Created by Karim on 12/09/16.
//  Copyright © 2016 KRS. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController {

    var userSelected: User!
    var currentUser: String!
    var ref: FIRDatabaseReference!
    var userView: UsersView {
        return view as! UsersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Usuarios"

        let defaults = NSUserDefaults.standardUserDefaults()
        if let userName = defaults.stringForKey("currentUser") {
            currentUser = userName
        }

        setupTableView()
        ref = FIRDatabase.database().reference()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.child("users").observeEventType(.Value, withBlock: { snapshot in
            Users.resetUsers()

            for item in snapshot.children {
                
                let user = User(name: item.value["username"] as! String)
                
                if user.name != self.currentUser {
                Users.addUser(user)
                }
            }
            
            self.userView.tableView.reloadData()
        })
        
    }
}

extension UsersViewController {
    
    private func setupTableView() {
        userView.tableView.delegate = self
        userView.tableView.dataSource = self
        userView.tableView.tableFooterView = UIView()

    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.countUser()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(UsersViewTableViewCellIdentifier.Normal.rawValue)! as UITableViewCell

        
        let user = Users.getUserFromIndexPath(indexPath)

        
        cell.textLabel?.text = user?.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        userSelected = Users.getUserFromIndexPath(indexPath)
        self.hidesBottomBarWhenPushed = true

        self.performSegueWithIdentifier("user_chat_segue", sender: self)
        self.hidesBottomBarWhenPushed = false

    }
}

extension UsersViewController {
    
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        

        let chatVc = segue.destinationViewController as! ChatViewController

        chatVc.conversationId = currentUser
        chatVc.senderId = currentUser
        chatVc.senderDisplayName = ""
        chatVc.destId = userSelected.name
    }

        
    
    
}
