//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Karim on 11/09/16.
//  Copyright © 2016 KRS. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var ref: FIRDatabaseReference!

    var loginView: LoginView {
        return view as! LoginView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func loginAction(sender: AnyObject) {
        

        FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user, error) in

        }
        
        let deleteRef = ref.child("users/ffr")

        print(deleteRef)
        
        
        let username = loginView.getUserName()
        
        if username == "" {
            
            print("Username empty")
            showOKAlert("Tienes que escoger un nombre")
        } else {
        
        ref.child("users").observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            if snapshot.hasChild(username){
                
                print("user \(username) its alredy taken")
                self.showOKAlert("\(username) ya existe, prueba con otro")

                
            }else{
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(username, forKey: "currentUser")

                
                let post = ["username": username]
                let childUpdates = ["/users/\(username)": post]
                self.ref.updateChildValues(childUpdates)
                
                self.performSegueWithIdentifier("login_segue", sender: self)

            }
        })
            
        }
        
        
    }
    
}

extension LoginViewController {
    
    func showOKAlert(message: String){
        let alertController = UIAlertController(title: "App", message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    

}