//
//  TripTableViewController.swift
//  KidsFly
//
//  Created by Keri Levesque on 3/4/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit
import CoreData

class TripTableViewController: UITableViewController {

    
    //MARK: Properties
    var tripController = TripController()
    
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
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "NewTripSegue" {
             guard let newTripVC = segue.destination as? CreateTripViewController else { return }
             newTripVC.tripController = tripController
         } else if segue.identifier == "TravelerSignInSegue" {
            guard let travelerSignInVC = segue.destination as? LoginViewController else { return }
             travelerSignInVC.tripController = tripController
         } else if segue.identifier == "TripDetailSegue" {
             guard let tripDetailVC = segue.destination as? CreateTripViewController else { return }
             tripDetailVC.tripController = tripController
             if let indexPath = tableView.indexPathForSelectedRow {
                 tripDetailVC.trip = fetchedResultsController.object(at: indexPath)
             }
         }
         
     }


}
extension TripTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}
