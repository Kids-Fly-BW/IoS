//
//  KidsFlyController.swift
//  KidsFly
//
//  Created by Elizabeth Wingate on 3/2/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
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
    
    private let baseUrl = URL(//api they are coming up with)!

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
}
