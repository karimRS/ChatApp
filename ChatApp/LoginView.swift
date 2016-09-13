//
//  LoginView.swift
//  ChatApp
//
//  Created by Karim on 11/09/16.
//  Copyright © 2016 KRS. All rights reserved.
//

import UIKit



class LoginView: UIView {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nickTextField: UITextField!
    
    func getUserName() -> String {
        
        return nickTextField.text!
    }


}
