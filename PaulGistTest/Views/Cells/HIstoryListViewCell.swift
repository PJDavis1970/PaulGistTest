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
    
    func setupWith(data: GistHistory) {

        imagePT.load(url: URL(fileURLWithPath: data.imageUrl))
        
        let imageUrlString = data.imageUrl
        let imageUrl:URL = URL(string: imageUrlString)!
        
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                self.imagePT.image = image
                self.imagePT.contentMode = UIViewContentMode.scaleAspectFit
            }
        }
        
        
        namePT.text = "\(data.login)"
        textPT.text = "\(data.descrip)"
    }
}

