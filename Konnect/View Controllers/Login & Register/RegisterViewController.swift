//
//  RegisterViewController.swift
//  Konnect
//
//  Created by Philip Yu on 4/8/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
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
    
    @IBAction func onExistingAccount(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onRegister(_ sender: Any) {
        
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let email = emailField.text!
        let username = usernameField.text!
        let password = passwordField.text!
        let repeatPassword = repeatPasswordField.text!
        
        let minUserLength = 1 // CHANGE WHEN DEPLOY
        let minPasswordLength = 1 // CHANGE WHEN DEPLOY
        let minEmailLength = 1 // CHANGE WHEN DEPLOY
        
        // Validate text fields
        if username.count < minUserLength {
            displayAlertMessage(alertTitle: "Invalid", alertMessage: "Username must be greater than 5 characters")
        } else if password.count < minPasswordLength {
            displayAlertMessage(alertTitle: "Invalid", alertMessage: "Password must be greater than 8 characters")
        } else if email.count < minEmailLength {
            displayAlertMessage(alertTitle: "Invalid", alertMessage: "Please enter a valid email address")
        } else {
            // Check for empty fields
            if firstName.isEmpty || lastName.isEmpty
                || username.isEmpty || password.isEmpty || repeatPassword.isEmpty {
                displayAlertMessage(alertTitle: "Ok", alertMessage: "All fields are required")
            }
            
            // Check if passwords match
            if password != repeatPassword {
                displayAlertMessage(alertTitle: "Alert", alertMessage: "Passwords do not match")
            }
            
            // Store registration data
            let user = PFUser()
            
            user["firstName"] = firstName
            user["lastName"] = lastName
            user["fullName"] = firstName + " " + lastName
            user.email = email
            user.username = username
            user.password = password
            
            // Sign up the user asynchronously
            user.signUpInBackground { (success, error) in
                if success {
                    let contacts = PFObject(className: "Contacts")
                    
                    contacts["username"] = user
                    contacts.saveInBackground()
                    
                    let alert = UIAlertController(title: "Success", message: "Signed Up", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.displayAlertMessage(alertTitle: "Error", alertMessage: "\(String(describing: error?.localizedDescription))")
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
