//
//  GistManager.swift
//  PaulGistTest
//
//  Created by Paul Davis on 08/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import Foundation

final class GistManager {
    
    static let sharedInstance = GistManager()
    
    var gistHistory: [GistHeader]?
    var currentGist: [String: Any]?
    
    
    private init() {
        
        retrieveHistory()
    }
    
    // retrieve our history from user defaults
    func retrieveHistory() {
        
        if let data = UserDefaults.standard.data(forKey: "history") {
            
            self.gistHistory = try? JSONDecoder().decode([GistHeader].self, from: data)
        }
    }
    
    
    // save our history to user defaults
    func saveHistory() {
        
        if let encoded = try? JSONEncoder().encode(gistHistory) {
            
            UserDefaults.standard.set(encoded, forKey: "history")
            UserDefaults.standard.synchronize();
        }
    }
    
    // return our gist history
    func getHistory() -> [GistHeader]? {
        
        return gistHistory
    }
    
    // we have been asked to add a gist to history.  if invalid return false to let view know its wrong.
    // if we have a valid gist then add it to top of our history then our gist view will use this to display our gist
    func addToHistory( id: String , completion: @escaping (_ result: Bool) -> Void) {
        
        GistApi.sharedInstance.getGist(id: id) { [weak self] (result) in
            switch result {
                case .success(let data):

                    // save the gist for later use
                    self?.currentGist = data
                    let newGist = GistHeader(gist: data)
                    
                    if self?.gistHistory == nil {

                        self?.gistHistory = [GistHeader]()
                    }
                    self?.gistHistory?.insert(newGist, at: 0)
                    self?.saveHistory()
                    completion(true)
                    break

                case .failure():
                    completion(false)
                    break
            }
        }
    }
    
    
    // returns the header information for the Gist
    func getCurrentGistHeader() -> GistHeader? {
        
        if let data = currentGist {
            
            return GistHeader(gist: data)
        }
        return nil
    }
    
    // returns a full data structure to display in Gist View
    func getCurrentGistDisplayData() -> [[String: Any]] {
        
        var data: [[String: Any]] = [[String: Any]]()
        
        if let gist = currentGist {

            let header = GistHeader(gist: gist)
            data.append(["type":"header","data":header])
        }
        
        return data
    }
    
    
    // retrieve a Gist from id
    func getGist( id: String , completion: @escaping (_ result: Bool) -> Void) {
        
        GistApi.sharedInstance.getGist(id: id) { [weak self] (result) in
            switch result {
            case .success(let data):
                
                // save the gist for later use
                self?.currentGist = data
                print(data)
                completion(true)
                break
                
            case .failure():
                completion(false)
                break
            }
        }
    }

    
}
