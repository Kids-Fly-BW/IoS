//
//  LoginViewController.swift
//  KidsFly
//
//  Created by Elizabeth Wingate on 3/2/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

      var kidsFlyController: KidsFlyController!
      var tripController = TripController()
      var loginType = LoginType.signUp
    
     @IBOutlet weak var usernameTextField: UITextField!
     @IBOutlet weak var passwordTextField: UITextField!
     @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
     @IBOutlet weak var signInButton: UIButton!
     
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  @IBAction func signInButtonTapped(_ sender: UIButton) {
    guard let kidsFlyController = kidsFlyController else { return }
   
            if let username = usernameTextField.text,
                !username.isEmpty,
                 let password = passwordTextField.text,
                !password.isEmpty {
                let user = User(username: username, password: password)
             
                if loginType == .signUp {
                kidsFlyController.signUp(with: user) { (error) in
                 if let error = error {
                        NSLog("Error occurred during sign up: \(error)")
                } else {
                   DispatchQueue.main.async {
                 let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                  let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                alertController.addAction(alertAction)
                self.present(alertController, animated: true) {
                    self.loginType = .signIn
                    self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                    self.signInButton.setTitle("Sign In", for: .normal)
                 }
              }
           }
        }
             } else {
                    kidsFlyController.signIn(with: user) { (error) in
                        if let error = error {
                     NSLog("Error logging in: \(error)")
             } else {
                    DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                 }
              }
           }
         }
      }
    }
    
   @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
                signInButton.setTitle("Sign Up", for: .normal)
                } else {
                loginType = .signIn
                signInButton.setTitle("Sign In", for: .normal)
        }
    }
}

