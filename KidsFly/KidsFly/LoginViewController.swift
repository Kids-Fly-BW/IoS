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

      var loginType = LoginType.signUp
    
    @IBOutlet weak var usernameTextField: UITextField!
     @IBOutlet weak var passwordTextField: UITextField!
     @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
     @IBOutlet weak var signInButton: UIButton!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
  @IBAction func signInButtonTapped(_ sender: UIButton) {
    }
    
   @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
    }
}
