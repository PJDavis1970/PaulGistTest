//
//  GistFileViewCell.swift
//  PaulGistTest
//
//  Created by Paul Davis on 09/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit

class GistFileViewCell: UITableViewCell {

    @IBOutlet weak var fileImagePT: UIImageView!
    @IBOutlet weak var fileNamePT: UILabel!
    @IBOutlet weak var textPT: UITextView!
    
    // we will use a viewId which specifies which cell in teh tableview we are.
    // This is used for the update height of the view.
    var viewId: Int = 0
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func setupWith(data: GistFile, viewId: Int) {
        
        fileNamePT.text = data.filename
        textPT.text = data.content
        
        // TODO Add formatting here for the different content type in gist's
        
        // we need to force a textViewDidChange method
        let textRange = textPT.textRange(from: textPT.beginningOfDocument, to: textPT.endOfDocument)
        textPT.replace(textRange!, withText: data.content)
    }
}

