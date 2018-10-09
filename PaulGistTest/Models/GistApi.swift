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
        case success(Value)
        case failure()
    }

    func getGist(id: String, completion: @escaping ((Result<[String:Any]>) -> Void)) {
        
        let todoEndpoint: String = "https://api.github.com/gists/2bb83155b4b463bb7f0978bc7d527c57"
        guard let url = URL(string: todoEndpoint) else {
            
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            // check for any errors
            guard error == nil else {
                
                print("error calling GET")
                print(error!)
                completion(.failure())
                return
            }
            // make sure we got data
            guard let responseData = data else {
                
                print("Error: did not receive data")
                completion(.failure())
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                
                guard let gistData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        
                        print("error trying to convert data to JSON")
                        completion(.failure())
                        return
                }
                                
                // TODO add proper error checking on returned data.  if we have hit api but have incorrect data we will get
                // errors back.  This needs checking.  For now I will just hack in something to decide if we have a gist or not
                
                if gistData.count > 2 {
                    
                    completion(.success(gistData))
                } else {
                    
                    completion(.failure())
                }
                return
                
            } catch  {
                
                print("error trying to convert data to JSON")
                completion(.failure())
            }
        }
        task.resume()
    }
}
