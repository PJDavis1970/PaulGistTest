//
//  HIstoryListViewCell.swift
//  PaulGistTest
//
//  Created by Paul Davis on 09/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit

class HistoryListViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imagePT: UIImageView!
    @IBOutlet weak var namePT: UILabel!
    @IBOutlet weak var textPT: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    func setupWith(data: GistHeader) {

        imagePT.load(url: URL(fileURLWithPath: data.imageUrl))
        
        self.imagePT.imageFromURL(urlString: data.imageUrl)
        
        namePT.text = "\(data.login)"
        textPT.text = "\(data.descrip)"
    }
}

