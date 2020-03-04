//
//  Trip+Convenience.swift
//  KidsFly
//
//  Created by Keri Levesque on 3/4/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import Foundation
import CoreData

extension Trip {
    @discardableResult convenience init(identifier: UUID = UUID(),
                                           airport: String,
                                           airline: String,
                                           completedStatus: Bool = false,
                                           flight: String,
                                           departureTime: Date,
                                           childrenQty: Int16,
                                           carryOnQty: Int16,
                                           checkedBagQty: Int16,
                                           context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
           
           self.init(context: context)
           self.identifier = identifier
           self.airport = airport
           self.airline = airline
           self.completedStatus = completedStatus
           self.flight = flight
           self.departureTime = departureTime
           self.childrenQty = childrenQty
           self.carryOnQty = carryOnQty
           self.checkedBagQty = checkedBagQty
       }
       
       @discardableResult convenience init?(tripRepresentation: TripRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
           
           guard let identifierString = tripRepresentation.identifier,
               let identifier = UUID(uuidString: identifierString),
               let airport = tripRepresentation.airport,
               let airline = tripRepresentation.airline,
               let completedStatus = tripRepresentation.completedStatus,
               let flight = tripRepresentation.flight,
               let departureTime = tripRepresentation.departureTime,
               let childrenQty = tripRepresentation.childrenQty,
               let carryOnQty = tripRepresentation.carryOnQty,
               let checkedBagQty = tripRepresentation.checkedBagQty else { return nil }
           
           self.init(identifier: identifier, airport: airport, airline: airline, completedStatus: completedStatus, flightNumber: flight, departureTime: departureTime, childrenQty: Int16(childrenQty), carryOnQty: Int16(carryOnQty), checkedBagQty: Int16(checkedBagQty))
       }
       
       var tripRepresentation: TripRepresentation {
           return TripRepresentation(identifier: identifier?.uuidString, airport: airport, airline: airline, completedStatus: completedStatus, flightNumber: flight, departureTime: departureTime, childrenQty: Int(childrenQty), carryOnQty: Int(carryOnQty), checkedBagQty: Int(checkedBagQty))
       }
    
    
    
    
    
    
}
