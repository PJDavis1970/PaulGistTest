//
//  extensions.swift
//  PaulGistTest
//
//  Created by Paul Davis on 10/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit

extension UITextView {
    
    /**
     Calculates if new textview height (based on content) is larger than a base height
     
     - parameter baseHeight: The base or minimum height
     
     - returns: The new height
     */
    func newHeight(withBaseHeight baseHeight: CGFloat) -> CGFloat {
        
        // Calculate the required size of the textview
        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        var newFrame = frame
        
        // Height is always >= the base height, so calculate the possible new height
        let height: CGFloat = newSize.height > baseHeight ? newSize.height : baseHeight
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: height)
        
        return newFrame.height
    }
}

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
