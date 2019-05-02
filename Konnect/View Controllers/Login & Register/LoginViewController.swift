//
//  LoginViewController.swift
//  Konnect
//
//  Created by Philip Yu on 4/8/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func displayAlertMessage(alertTitle: String = "Alert",
                             alertMessage: String = "Default alert message",
                             actionTitle: String = "Dismiss",
                             actionStyle: UIAlertAction.Style = .default) {
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        
        let username = usernameField.text!
        let password = passwordField.text!
        
        let minUserLength = 1 // CHANGE WHEN DEPLOY
        let minPasswordLength = 1 // CHANGE WHEN DEPLOY
        
        // Validate text fields
        if username.count < minUserLength {
            displayAlertMessage(alertTitle: "Invalid", alertMessage: "Username must be greater than 5 characters")
        } else if password.count < minPasswordLength {
            displayAlertMessage(alertTitle: "Invalid", alertMessage: "Password must be greater than 8 characters")
        } else {
            // Check for empty fields
            if username.isEmpty || password.isEmpty {
                displayAlertMessage(alertTitle: "Ok", alertMessage: "All fields are required")
            }
            
            // Sign in the user asynchronously
            PFUser.logInWithUsername(inBackground: username, password: password) { (success, error) in
                if (success != nil) {
                    
                    let currentUser = PFUser.current()
                    let contacts = PFObject(className: "Contacts")
                    let query = PFQuery(className: "Contacts")
                    let userQuery = PFQuery(className: "_User")
                    
                    // TEST
                    userQuery.whereKey("username", equalTo: currentUser!)

                    userQuery.findObjectsInBackground(block: { (objects, error) in
                        if error == nil {
                            if currentUser!["fullName"] != nil {
                                currentUser!["fullName"] = "\(currentUser!["firstName"]!)" + " " + "\(currentUser!["lastName"]!)"
                                currentUser?.saveInBackground()
                            }
                        }
                    })
                    // TEST
                    
                    query.whereKey("username", equalTo: currentUser!)
                    
                    query.findObjectsInBackground(block: { (objects, error) in
                        if error == nil {
                            if !(objects!.count > 0) {
                                print("Don't Exist!")
                                contacts["username"] = currentUser
                                contacts["firstName"] = currentUser!["firstName"]
                                contacts["lastName"] = currentUser!["lastName"]
                                contacts["fullName"] = "\(currentUser!["firstName"]!)" + " " + "\(currentUser!["lastName"]!)"
                                contacts.saveInBackground()
                            }
                        }
                    })
                    
                    let alert = UIAlertController(title: "Success", message: "Logged In", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.displayAlertMessage(alertTitle: "Error", alertMessage: "Invalid username/password.")
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
