//
//  Auth0Helper.swift
//  PaulGistTest
//
//  Created by Paul Davis on 14/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import Foundation
import Auth0

enum Auth0Result<Value> {
    
    case success()
    case failure(String)
}

class Auth0Helper {
    
    static func login(completion: @escaping ((Auth0Result<[String:Any]>) -> Void)) {
        
        let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        
        Auth0
            .webAuth()
            .connection("github")
            //.scope("gist")
            .audience("https://pjdavis1970.eu.auth0.com/userinfo")
            .start {
                
                switch $0 {
                case .failure(let error):
                    
                    completion(.failure("Error: \(error)"))

                case .success(let credentials):

                    _ = credentialsManager.store(credentials: credentials)
                    completion(.success())
                }
        }
    }
    
    static func logout() {
        
        let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        _ = credentialsManager.clear()
    }
}
