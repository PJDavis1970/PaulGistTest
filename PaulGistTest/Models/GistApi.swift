//
//  GistApi.swift
//  PaulGistTest
//
//  Created by Paul Davis on 09/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import Foundation

// ok if I had enough time on this I would make the API return use codable structures to pass data into.  However
// copying all those data structures over is very time consuming and I do not think I have time for that in this test.

class GistApi {
    
    static let sharedInstance = GistApi()
    
    private init() {
    }
    
    enum Result<Value> {
        case success(GistObject)
        case failure()
    }

    func getGist(id: String, completion: @escaping ((Result<[String:Any]>) -> Void)) {
        
        let todoEndpoint: String = "https://api.github.com/gists/"+id
        guard let url = URL(string: todoEndpoint) else {
            
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            guard let responseData = data else {
                completion(.failure())
                return
            }
            guard error == nil else {
                completion(.failure())
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let gistObject = try decoder.decode(GistObject.self, from: responseData)
                
                if gistObject.comments > 0 {
                    
                    // now get the comments
                    let todoEndpoint: String = "https://api.github.com/gists/\(id)/comments"
                    guard let url = URL(string: todoEndpoint) else {
                        
                        print("Error: cannot create URL")
                        return
                    }
                    let urlRequest = URLRequest(url: url)
                    let task = session.dataTask(with: urlRequest, completionHandler: {
                    (   data, response, error) in
                        guard let responseComments = data else {
                            completion(.failure())
                            return
                        }
                        guard error == nil else {
                            completion(.failure())
                            return
                        }
                    
                        let decoder = JSONDecoder()
                        do {
                            let gistComments = try decoder.decode([GistComment].self, from: responseComments)
                        
                            gistObject.comment_list = gistComments
                            completion(.success(gistObject))
                        } catch {
                            print("error trying to convert data to JSON")
                            print(error)
                            completion(.failure())
                        }
                    })
                    task.resume()
                } else {
                    
                    completion(.success(gistObject))
                }
                
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completion(.failure())
            }
        })
        task.resume()
    }
}
