//
//  LoginViewController.swift
//  rednitte
//
//  Created by 板垣智也 on 2019/04/09.
//  Copyright © 2019 板垣智也. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInSignUpButton: UIButton!
    @IBOutlet weak var changeLogInSignUpButton: UIButton!
    
    var signUpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
    }
    
    @IBAction func logInSignUpTapped(_ sender: Any) {
        if signUpMode {
            // Signup
            let user = PFUser()
            
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            
            user.signUpInBackground(block: { (success, error) in
                if error != nil {
                    var errorMessage = "Sign Up Failed - Try Again"
                    
                    if let newError = error as NSError? {
                        if let detailError = newError.userInfo["error"] as? String {
                            errorMessage = detailError
                        }
                    }
                    
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                } else {
                    print("Sign Up Successful")
                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                }
            })
        } else {
            // Login
            if let username = usernameTextField.text, let password = passwordTextField.text {
                PFUser.logInWithUsername(inBackground: username, password: password, block: {(user, error) in
                    if error != nil {
                        var errorMessage = "Sign Up Failed - Try Again"
                        
                        if let newError = error as NSError? {
                            if let detailError = newError.userInfo["error"] as? String {
                                errorMessage = detailError
                            }
                        }
                        
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorMessage
                    } else {
                        print("Log In Successful")
                        if user?["isFemale"] != nil {
                            self.performSegue(withIdentifier: "loginToSwipingSegue", sender: nil)
                        } else {
                            self.performSegue(withIdentifier: "updateSegue", sender: nil)
                        }
                        self.performSegue(withIdentifier: "updateSegue", sender: nil)
                    }
                })
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            
            if PFUser.current()?["isFemale"] != nil {
                performSegue(withIdentifier: "loginToSwipingSegue", sender: nil)
            } else {
                self.performSegue(withIdentifier: "updateSegue", sender: nil)
            }
        }
    }
    
    @IBAction func changeLogInSignUpTapped(_ sender: Any) {
        if signUpMode {
            logInSignUpButton.setTitle("Log In", for: .normal)
            changeLogInSignUpButton.setTitle("Sign Up", for: .normal)
            signUpMode = false
        } else {
            logInSignUpButton.setTitle("Sign Up", for: .normal)
            changeLogInSignUpButton.setTitle("Log In", for: .normal)
            signUpMode = true
        }
    }
    
    
}
