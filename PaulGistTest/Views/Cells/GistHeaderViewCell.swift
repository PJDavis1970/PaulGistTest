//
//  GistHeaderViewCell.swift
//  PaulGistTest
//
//  Created by Paul Davis on 09/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit

class GistHeaderViewCell: UITableViewCell {
    
    @IBOutlet weak var imagePT: UIImageView!
    @IBOutlet weak var namePT: UILabel!
    @IBOutlet weak var descripPT: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    func setupWith(data: GistHeader) {
        
        self.imagePT.imageFromURL(urlString: data.imageUrl)
        self.namePT.text = data.login
        self.descripPT.text = data.descrip
    }
}
