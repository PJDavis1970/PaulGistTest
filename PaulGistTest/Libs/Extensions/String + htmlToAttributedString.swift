//
//  String + htmlToAttributedString.swift
//  PaulGistTest
//
//  Created by Paul Davis on 14/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import Foundation

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        
        return htmlToAttributedString?.string ?? ""
    }
}
