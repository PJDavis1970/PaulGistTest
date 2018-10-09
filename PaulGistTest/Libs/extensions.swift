//
//  extensions.swift
//  PaulGistTest
//
//  Created by Paul Davis on 09/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func load(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            
            if let data = try? Data(contentsOf: url) {
                
                if let image = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        
                        self?.image = image
                    }
                }
            }
        }
    }

}

extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })
            
        }).resume()
    }
}
