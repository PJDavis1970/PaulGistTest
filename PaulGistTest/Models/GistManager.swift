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
    
    var gistBookmarks: [GistBookmark]?
    var currentGist: GistObject?
    var selectedGistId: String = ""
    
    private init() {
        
        retrieveBookmarks()
    }
    
    func setSelectedGistId(id: String) {
    
        selectedGistId = id
    }
    
    func getSelectedGistId() -> String {
        
        return selectedGistId
    }
    
    // retrieve our history from user defaults
    func retrieveBookmarks() {
        
        if let data = UserDefaults.standard.data(forKey: "bookmarks") {
            
            self.gistBookmarks = try? JSONDecoder().decode([GistBookmark].self, from: data)
        }
    }
    
    // save our history to user defaults
    func saveBookmarks() {
        
        if let encoded = try? JSONEncoder().encode(gistBookmarks) {
            
            UserDefaults.standard.set(encoded, forKey: "bookmarks")
            UserDefaults.standard.synchronize();
        }
    }
    
    // return our gist history
    func getBookmarks() -> [GistBookmark]? {
        
        return gistBookmarks
    }
    
    // query gist from api and add gist to our bookmarks
    func getGist( id: String , completion: @escaping (_ result: Bool) -> Void) {
        
        GistApi.sharedInstance.getGist(id: id) { [weak self] (result) in
            switch result {
                case .success(let data):

                    // save the gist for later use
                    self?.currentGist = data
                    
                    // create our history record
                    let newGist = GistBookmark(gist: data)
                    
                    // if we have no history database create one
                    if self?.gistBookmarks == nil {

                        self?.gistBookmarks = [GistBookmark]()
                    }
                    
                    // hate forcing unwraps but we know we have data in here
                    
                    // find and remove any duplicates
                    if let index = self?.gistBookmarks!.index(where: { $0.id == newGist.id }) {
                        self?.gistBookmarks!.remove(at: index)
                    }
                        
                    self?.gistBookmarks?.insert(newGist, at: 0)
                    self?.saveBookmarks()

                    completion(true)
                    break

                case .failure():
                    completion(false)
                    break
            }
        }
    }
    
    // returns a list of each display section
    func getCurrentGistDisplay() -> [GistDisplayEntry]? {
        
        var list: [GistDisplayEntry] = [GistDisplayEntry]()
        
        if let gist = self.currentGist {
        
            // create the gist geader section
            let header = GistDisplayEntry(type: GistDisplayType.header, data: GistDisplayHeader(gist: gist))
            list.append(header)
        
            // create all the file sections
            for file in gist.files.file_list {
                
                let file = GistDisplayEntry(type: GistDisplayType.file, data: file)
                list.append(file)
            }
            

        }
        return list
    }
    


}
