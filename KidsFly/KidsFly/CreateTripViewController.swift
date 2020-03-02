//
//  CreateTripViewController.swift
//  KidsFly
//
//  Created by Keri Levesque on 3/2/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

class CreateTripViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var airlineTextField: UITextField!
    @IBOutlet weak var airportTextField: UITextField!
    @IBOutlet weak var carryonTextField: UITextField!
    @IBOutlet weak var checkedBagsTextField: UITextField!
    @IBOutlet weak var childrenTextField: UITextField!
    @IBOutlet weak var flightTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
 
    //MARK: Actions
    
    @IBAction func saveTripTapped(_ sender: UIButton) {
    }
}
