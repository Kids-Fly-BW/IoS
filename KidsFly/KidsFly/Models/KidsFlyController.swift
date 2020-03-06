//
//  KidsFlyController.swift
//  KidsFly
//
//  Created by Elizabeth Wingate on 3/2/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case noEncode
}

class KidsFlyController {
    var trips: [TripRepresentation] = []
    
    private let baseUrl = URL(string: "https://reqres.in/api/")!
    var bearer: Bearer?
    
         func signUp(with user: User, completion: @escaping (Error?) -> ()) {
            let signUpUrl = baseUrl.appendingPathComponent("users/signup")

             var request = URLRequest(url: signUpUrl)

            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let jsonEncoder = JSONEncoder()
                  do {
                      let jsonData = try jsonEncoder.encode(user)
                      request.httpBody = jsonData
                  } catch {
                      NSLog("Error encoding user object: \(error)")
                      completion(error)
                      return
                  }

            URLSession.shared.dataTask(with: request) { (_, response, error) in

            if let error = error {
            completion(error)
                return
            }
           if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
               return
           }
            completion(nil)
        }.resume()
    }
        func signIn(with user: User, completion: @escaping (Error?) -> ()) {
            let signInUrl = baseUrl.appendingPathComponent("users/login")

            var request = URLRequest(url: signInUrl)

            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let jsonEncoder = JSONEncoder()
               do {
            let jsonData = try jsonEncoder.encode(user)
                request.httpBody = jsonData
            } catch {
                NSLog("Error encoding user object: \(error)")
                completion(error)
                    return
            }
            URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
            completion(error)
                return
            }

            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
            completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
             }

            guard let data = data else {
              completion(NSError())
                return
              }
            let decoder = JSONDecoder()
                do {
            self.bearer = try decoder.decode(Bearer.self, from: data)
                } catch {
               NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
                }
                completion(nil)
             }.resume()
        }
    
     //MARK: Fetch
    func fetchTripsFromServer(completion: @escaping (Result<[TripRepresentation], NetworkError>) -> Void) {
             guard let bearer = bearer else {
             completion(.failure(.noAuth))
                 return
             }
             let allTripsUrl = baseUrl.appendingPathComponent("trips")
             print(allTripsUrl)
             
             var request = URLRequest(url: allTripsUrl)
             request.httpMethod = HTTPMethod.get.rawValue
             request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")

                 URLSession.shared.dataTask(with: request) { (data, response, error) in
                     if let response = response as? HTTPURLResponse,
                         response.statusCode == 401 {
                         completion(.failure(.badAuth))
                         print("no response")
                     return
                 }
                   if let error = error {
                         completion(.failure(.otherError))
                     print(error)
                     return
                 }
                     guard let data = data else {
                         completion(.failure(.badData))
                         print("no data")
                     return
                 }
                     print("No errors")

                 let jsonDecoder = JSONDecoder()
                     jsonDecoder.dateDecodingStrategy = .iso8601
                     do {
                 let trips = try jsonDecoder.decode([TripRepresentation].self, from: data)
                     completion(.success(trips))
                     self.trips = trips
                 } catch {
                     print("Error decoding gigs: \(error.localizedDescription)")
                     completion(.failure(.noDecode))
                         return
             }
          }.resume()
     }
     
    // MARK: Send
    func sendTripsToServer(trip: Trip, completion: @escaping (Error?) -> Void = { _ in }) {
          
          let identifier = trip.identifier ?? UUID()
          trip.identifier = identifier
          
          let requestURL = baseUrl
              .appendingPathComponent(identifier.uuidString)
              .appendingPathExtension("json")
          
          var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
          
          guard let tripRepresentation = trip.tripRepresentation else {
              print("Trip Representation is nil")
              completion(NSError())
              return
          }
          
          do {
              try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
              request.httpBody = try JSONEncoder().encode(tripRepresentation)
          } catch {
              print("Error encoding trip representation: \(error)")
              completion(NSError())
              return
          }
          
          URLSession.shared.dataTask(with: request) { _, _, error in
              
              if let error = error {
                  print("Error PUTting data: \(error)")
                  completion(NSError())
                  return
              }
              
              completion(nil)
          }.resume()
      }
    //MARK: - Delete
       
       func deleteTrip(_ trip: Trip, completion: @escaping () -> Void = { }) {
           
           let identifier = trip.identifier ?? UUID()
           trip.identifier = identifier
           
           let requestURL = baseUrl
               .appendingPathComponent(identifier.uuidString)
               .appendingPathExtension("json")
           
           var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
           
           guard let tripRepresentation = trip.tripRepresentation else {
               print("Trip Representation is nil")
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
    

        // MARK: - Update Core Data
        func updateTrips(with representations: [TripRepresentation]) throws {
            let tripsWithID = representations.filter { $0.identifier != nil }
            let identifiersToFetch = tripsWithID.compactMap { $0.identifier }
            
            let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, tripsWithID))
            
            var tripsToCreate = representationsByID
            
            let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
            let moc = CoreDataStack.shared.container.newBackgroundContext()
            
            moc.perform {
                do {
                    let existingTrips = try moc.fetch(fetchRequest)
                    
                    for trip in existingTrips {
                        guard let id = trip.identifier?.uuidString,
                            let representation = representationsByID[id] else {
                                moc.delete(trip)
                                continue
                        }
                        
                        self.update(trip: trip, representation: representation)
                        
                        tripsToCreate.removeValue(forKey: id)
                    }
                    
                    for representation in tripsToCreate.values {
                        Trip(tripRepresentation: representation, context: moc)
                    }
                } catch {
                    print("Error fetching trips for identifiers: \(error)")
                }
            }
            try CoreDataStack.shared.save(context: moc)
        }
    // MARK: - Helpers
     func update(trip: Trip, representation: TripRepresentation) {
         trip.airline = representation.airline
         trip.airport = representation.airport
         trip.carryOnQty = Int16(representation.carryOnQty!)
         trip.checkedBagQty = Int16(representation.checkedBagQty!)
         trip.childrenQty = Int16(representation.childrenQty!)
         trip.completedStatus = representation.completedStatus!
         trip.departureTime = representation.departureTime
         trip.flightNumber = representation.flightNumber
         trip.identifier = UUID(uuidString: representation.identifier!)
     }
}
