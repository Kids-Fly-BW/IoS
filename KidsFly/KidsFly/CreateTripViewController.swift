//
//  CreateTripViewController.swift
//  KidsFly
//
//  Created by Keri Levesque on 3/2/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

class CreateTripViewController: UIViewController {

    
    //MARK: Properties
    var kidsFlyController: KidsFlyController?
    var bearer: Bearer?
    var trip: Trip? {
        didSet {
            updateViews()
        }
    }
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

        updateViews()
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
        
        guard let kidsFlyController = kidsFlyController,
                  let bearer = bearer
                  else { return }
              if let airline = airlineTextField.text,
                  !airline.isEmpty,
                  let airport = airportTextField.text,
                  !airport.isEmpty,
                  let carryOnQty = carryonTextField.text,
                  !carryOnQty.isEmpty,
                  let checkedBagQty = checkedBagsTextField.text,
                  !checkedBagQty.isEmpty,
                  let childrenQty = childrenTextField.text,
                  !childrenQty.isEmpty,
                  let flightNumber = flightTextField.text,
                  !flightNumber.isEmpty {
                  
                  if let trip = trip {
                      trip.airport = airport
                      trip.airline = airline
                      trip.flightNumber = flightNumber
                      trip.departureTime = datePicker.date
                      trip.childrenQty = Int16(childrenQty)!
                      trip.carryOnQty = Int16(carryOnQty)!
                      trip .checkedBagQty = Int16(checkedBagQty)!
                      
                      let alertController = UIAlertController(title: "Trip Updated", message: "Your trip was successfully changed.", preferredStyle: .alert)
                      let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
                          self.dismiss(animated: true, completion: nil)
                          self.navigationController?.popViewController(animated: true)
                      }
                      alertController.addAction(alertAction)
                      self.present(alertController, animated: true)
                  
                  } else {
                      let newTrip = Trip(airport: airport, airline: airline, flightNumber: flightNumber, departureTime: datePicker.date, childrenQty: Int16(childrenQty)!, carryOnQty: Int16(carryOnQty)!, checkedBagQty: Int16(checkedBagQty)!)
                      

                      kidsFlyController.sendTripsToServer(trip: newTrip) { error in
                          if error != .success(true) {
                              print("Error occurred while PUTin a new trip to server: \(error)")
                          } else {
                              DispatchQueue.main.async {
                                  let alertController = UIAlertController(title: "New Trip Added", message: "Your new trip was created.", preferredStyle: .alert)
                                  let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
                                      self.dismiss(animated: true, completion: nil)
                                      self.navigationController?.popViewController(animated: true)
                                  }
                                  alertController.addAction(alertAction)
                                  self.present(alertController, animated: true)
                              }
                          }
                      }
                      
                  }
                  
              }
    }

    // MARK: - Update Views
    private func updateViews() {
        guard isViewLoaded else { return }
        
        if let trip = trip {
            title = trip.flightNumber
            airlineTextField.text = trip.airline
            airportTextField.text = trip.airport
            carryonTextField.text = String(trip.carryOnQty)
            checkedBagsTextField.text = String(trip.checkedBagQty)
            childrenTextField.text = String(trip.childrenQty)
            flightTextField.text = trip.flightNumber
            datePicker.date = trip.departureTime!
        } else {
        title = "Create New Trip"
            markAsCompletedButton.isEnabled = false
            markAsCompletedButton.setTitleColor(UIColor.systemGray, for: .disabled)
        }
    }



}
