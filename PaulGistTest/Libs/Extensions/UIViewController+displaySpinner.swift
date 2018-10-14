//
//  UIViewController+displaySpinner.swift
//  PaulGistTest
//
//  Created by Paul Davis on 14/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func displaySpinner(onView : UIView) -> UIView {
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        
        DispatchQueue.main.async {
            
            spinner.removeFromSuperview()
        }
    }
}
