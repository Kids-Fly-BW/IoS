//
//  TripController.swift
//  KidsFly
//
//  Created by Keri Levesque on 3/4/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit
import CoreData

class TripController {
    
    //MARK: Properties
    let baseURL = URL(string: "https://kidsFly-a96f2.firebaseio.com/")!
    var trips: [Trip] = []
    var bearer: Bearer?
    
    struct HTTPMethod {
           static let get = "GET"
           static let put = "PUT"
           static let post = "POST"
           static let delete = "DELETE"
       }
       
       //MARK: Fetch
       func fetchMyMoviesFromServer(completion: @escaping (Error?) -> Void) {
               
               let requestURL = baseURL.appendingPathExtension("json")
               
      
               let request = URLRequest(url: requestURL)

               URLSession.shared.dataTask(with: request) { data, _, error in
                   if let error = error {
                       print("Error fetching tasks: \(error)")
                       completion(nil)
                       return
                   }
                   
                   guard let data = data else {
                       print("No data returned from data task.")
                       completion(nil)
                       return
                   }
                   
                   let jsonDecoder = JSONDecoder()
                   do {
                       let decoded = try jsonDecoder.decode([String: TripRepresentation].self, from: data).map { $0.value }
                       self.updateTasks(with: decoded)
                       completion(nil)
                   } catch {
                       print("Unable to decode data into object of type [MovieRepresentation]: \(error)")
                       completion(nil)
                   }
               }.resume()
           }
       // MARK: Send
       func sendMyTripToServer(trip: Trip, completion: @escaping () -> Void = { }) {
           
           let identifier = trip.identifier ?? UUID()
           trip.identifier = identifier
           
           let requestURL = baseURL
               .appendingPathComponent(identifier.uuidString)
               .appendingPathExtension("json")
           
           var request = URLRequest(url: requestURL)
           request.httpMethod = HTTPMethod.put
           
           guard let tripRepresentation = trip.tripRepresentation else {
               print("Trip Representation is nil")
               completion()
               return
           }
           
           do {
               try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
               request.httpBody = try JSONEncoder().encode(tripRepresentation)
           } catch {
               print("Error encoding trip representation: \(error)")
               completion()
               return
           }
           
           URLSession.shared.dataTask(with: request) { _, _, error in
               
               if let error = error {
                   print("Error PUTting data: \(error)")
                   completion()
                   return
               }
               
               completion()
           }.resume()
       }
       
       //MARK: - Delete
       
       func deleteTrip(_ trip: Trip, completion: @escaping () -> Void = { }) {
           
           let identifier = trip.identifier ?? UUID()
           trip.identifier = identifier
           
           let requestURL = baseURL
               .appendingPathComponent(identifier.uuidString)
               .appendingPathExtension("json")
           
           var request = URLRequest(url: requestURL)
           request.httpMethod = HTTPMethod.delete
           
           guard let tripRepresentation = trip.tripRepresentation else {
               print("Movie Representation is nil")
               completion()
               return
           }
               let context = CoreDataStack.shared.mainContext
               
               do {
                   context.delete(trip)
                   try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
               } catch {
                   context.reset()
                   print("Error deleting object from managed object context: \(error)")
               }
               
               do {
                   request.httpBody = try JSONEncoder().encode(tripRepresentation)
               } catch {
                   print("Error encoding movie representation: \(error)")
                   completion()
                   return
               }
               
               URLSession.shared.dataTask(with: request) { _, _, error in
                   
                   if let error = error {
                       print("Error PUTting data: \(error)")
                       completion()
                       return
                   }
                   
                   completion()
               }.resume()
           }
       
       // MARK: - Private Methods
          
          func updateTasks(with representations: [TripRepresentation]) {
              
              let identifiersToFetch = representations.map { $0.identifier }
              
              let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
              
              
              var moviesToCreate = representationsByID
              
              let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
              fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
              
              let context = CoreDataStack.shared.container.newBackgroundContext()
              
              context.performAndWait {
                  
                  
                  do {
                      let existingMovies = try context.fetch(fetchRequest)
                      
                      
                      for movie in existingMovies {
                       
                          guard let identifier = movie.identifier,
                              let representation = representationsByID[identifier] else { continue }
       
                          movie.title = representation.title
                          movie.hasWatched = representation.hasWatched ?? false
                          
                          
                          moviesToCreate.removeValue(forKey: identifier)
                      }
                      
                      for representation in moviesToCreate.values {
                          Trip(tripRepresentation: representation, context: context)
                      }
                      try CoreDataStack.shared.save(context: context)
                  } catch {
                      print("Error fetching tasks from persistent store: \(error)")
                  }
              }
          }
       
    
    
}
