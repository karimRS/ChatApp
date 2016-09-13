//
//  User.swift
//  ChatApp
//
//  Created by Karim on 11/09/16.
//  Copyright © 2016 KRS. All rights reserved.
//

import UIKit

class User: NSObject {
    
    private(set) var name: String
    
    init(name: String) {
        self.name = name
    }

}

class Users {
    private static let sharedInstance = Users()
    private var users = [User]()
    
    class func countUser() -> Int {
        return sharedInstance.users.count
    }
    
    class func getUserFromIndexPath(indexPath: NSIndexPath) -> User? {
        if 0 > indexPath.row || indexPath.row > sharedInstance.users.count {
            return nil
        }
        return sharedInstance.users[indexPath.row]
    }
    
    class func addUser(user: User) {
        sharedInstance.users.append(user)
    }
    
    class func resetUsers() {
        sharedInstance.users = [User]()
    }
}




