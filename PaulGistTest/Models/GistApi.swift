//
//  GistApi.swift
//  PaulGistTest
//
//  Created by Paul Davis on 09/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import Foundation
import Auth0

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
    
    enum PostResult<Value> {
        
        case success(GistComment)
        case failure()
    }

    func getGist(id: String, completion: @escaping ((Result<[String:Any]>) -> Void)) {
        
        let endpoint: String = "https://api.github.com/gists/"+id
        guard let url = URL(string: endpoint) else {
            
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
    
    
    func postComment(comment: String, endpoint: String, completion: @escaping ((PostResult<[String:Any]>) -> Void)) {
        
        guard let url = URL(string: endpoint) else {
            
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        var json = [String:Any]()
        json["body"] = comment
        
        do {
            
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
        } catch {
            
            completion(.failure())
        }
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("gist", forHTTPHeaderField: "scope")
        
        let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        credentialsManager.credentials { [weak self] error, credentials in
            guard error == nil, let credentials = credentials, let token = credentials.idToken else {
                
                return
            }
            let scope = credentials.scope
            print(scope)
            urlRequest.addValue(token, forHTTPHeaderField: "authorization")
        }
        
        urlRequest.setValue("application/vnd.github.v3.text+json", forHTTPHeaderField: "Content-Type")
        
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
                
                let gistComment = try decoder.decode(GistComment.self, from: responseData)
                completion(.success(gistComment))

            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completion(.failure())
            }
        })
        task.resume()
    }
    
}
