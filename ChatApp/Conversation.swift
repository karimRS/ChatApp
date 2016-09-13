//
//  Conversation.swift
//  ChatApp
//
//  Created by Karim on 12/09/16.
//  Copyright © 2016 KRS. All rights reserved.
//

import UIKit

class Conversation: NSObject {
    
    private(set) var name: String
    
    init(name: String) {
        self.name = name
    }
    
}

class Conversations {
    private static let sharedInstance = Conversations()
    private var conversations = [Conversation]()
    
    class func countConversations() -> Int {
        return sharedInstance.conversations.count
    }
    
    class func getConversationFromIndexPath(indexPath: NSIndexPath) -> Conversation? {
        if 0 > indexPath.row || indexPath.row > sharedInstance.conversations.count {
            return nil
        }
        return sharedInstance.conversations[indexPath.row]
    }
    
    class func addConversation(conversation: Conversation) {
        sharedInstance.conversations.append(conversation)
    }
    
    class func resetConversations() {
        sharedInstance.conversations = [Conversation]()
    }
}

