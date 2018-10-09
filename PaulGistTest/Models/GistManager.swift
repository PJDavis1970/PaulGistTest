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
    
    var gistHistory: [GistHistory]?
    
    private init() {
        
        retrieveHistory()
    }
    
    // retrieve our history from user defaults
    func retrieveHistory() {
        
        if let data = UserDefaults.standard.data(forKey: "history") {
            
            self.gistHistory = try? JSONDecoder().decode([GistHistory].self, from: data)
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
    func getHistory() -> [GistHistory]? {
        
        return gistHistory
    }
    
    // we have been asked to add a gist to history.  if invalid return false to let view know its wrong.
    // if we have a valid gist then add it to top of our history then our gist view will use this to display our gist
    func addToHistory( id: String , completion: @escaping (_ result: Bool) -> Void) {

        let id = parseStringForGist( id: id )
        
        // we think we have a gist id.  lets check with gist api
        
        GistApi.sharedInstance.getGist(id: id) { [weak self] (result) in
            switch result {
                case .success(let data):

                    let newGist = GistHistory(gist: data)
                    
                    if self?.gistHistory == nil {

                        self?.gistHistory = [GistHistory]()
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
    
    // parse the given data.  This is what comes in from QR reader.  we need to check for either a url or a gist id code.
    func parseStringForGist( id: String ) -> String {
        
        let array = id.components(separatedBy: "/")
        
        if array.count == 0 {
            
            return id
        }
        
        if array[array.count-1] == "/" && array.count > 1 {
            
            return array[array.count-2]
        }
        
        return array[array.count-1]
    }
    
}
