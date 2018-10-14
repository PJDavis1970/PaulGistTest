//
//  AppData.swift
//  PaulGistTest
//
//  Created by Paul Davis on 13/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import Foundation
import Auth0

final class AppData {
    
    static let sharedInstance = AppData()

    var loggedIn = false
    
    private init() {
    }
    
    func setLoggedIn(loggedIn: Bool) {
        
        self.loggedIn = loggedIn
    }

    func isLoggedIn() -> Bool {
        
        return self.loggedIn
    }
}
