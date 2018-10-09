//
//  GistModel.swift
//  PaulGistTest
//
//  Created by Paul Davis on 08/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import Foundation
import UIKit

class GistHistory : NSObject, Codable {
    
    init(gist: [String:Any]) {
        
        // check if we have owner details and login name of owner
        if let owner: [String: Any] = gist["owner"] as? [String : Any] {
            
            if let login: String = owner["login"] as? String {
                
                self.login = login
            }
        
            // check if we have an avitar
            if let avitar: String = owner["avatar_url"] as? String {
                
                self.imageUrl = avitar
            }
        
        }
        
        // check if we have a project description
        if let descrip: String = gist["description"] as? String {
            
            self.descrip = descrip
        }
        
        // check if we have a gist id
        if let id: String = gist["id"] as? String {
            
            self.id = id
        }
        
    }
    
    var login: String = ""
    var descrip: String = ""
    var id: String = ""
    var imageUrl: String = ""
}
