//
//  TripTableViewController.swift
//  KidsFly
//
//  Created by Keri Levesque on 3/5/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit
import CoreData

class TripTableViewController: UITableViewController {
 
    //MARK: Properties
    
    let kidsFlyController = KidsFlyController()
    private lazy var fetchedResultsController: NSFetchedResultsController<Trip> = {
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "completedStatus", ascending: true),
            NSSortDescriptor(key: "departureTime", ascending: false)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "completedStatus", cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if kidsFlyController.bearer == nil {
        performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0 
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
          guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
          let sectionName = String(sectionInfo.name)
          switch sectionName {
          case "1":
              return "Completed"
          default:
              return "Not Completed"
          }
      }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as? TripTableViewCell else { return UITableViewCell()}

        let trip = fetchedResultsController.object(at: indexPath)
        cell.trip = trip

        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
         let trip = fetchedResultsController.object(at: indexPath)
                    KidsFlyController.deleteTrip(for: trip)
                    tableView.reloadData()
        }    
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "LoginViewModalSegue" {
            if let destinationVC = segue.destination as? LoginViewController {
                destinationVC.kidsFlyController = kidsFlyController
        }
     }
   }
}
