//
//  ApplicationViewController.swift
//  KidsFly
//
//  Created by Elizabeth Wingate on 3/4/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

class ApplicationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var FNTextfield: UITextField!
    @IBOutlet weak var LNTextfield: UITextField!
    @IBOutlet weak var EmailTextfield: UITextField!
    @IBOutlet weak var PNTextfield: UITextField!
    @IBOutlet weak var SSNTextfield: UITextField!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    
    //submit application button tapped
    @IBAction func SATapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Application Submitted!", message:
            "Please allow 3-4 days for response.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
}
