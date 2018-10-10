//
//  GistFileViewCell.swift
//  PaulGistTest
//
//  Created by Paul Davis on 09/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit

class GistFileViewCell: UITableViewCell {
    
    @IBOutlet weak var textPT: UITextView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    func setupWith(data: [String: Any]) {
        
        print(data)
    }
}
