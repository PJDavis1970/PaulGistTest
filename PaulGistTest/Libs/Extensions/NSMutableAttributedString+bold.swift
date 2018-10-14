//
//  NSMutableAttributedString+bold.swift
//  PaulGistTest
//
//  Created by Paul Davis on 14/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "Helvetica-Bold", size: 14)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
