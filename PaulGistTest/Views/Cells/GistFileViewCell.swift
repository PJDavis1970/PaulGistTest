//
//  GistFileViewCell.swift
//  PaulGistTest
//
//  Created by Paul Davis on 09/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit


protocol GistFileViewCellDelegate {
    
    func updated(height: CGFloat)
}

class GistFileViewCell: UITableViewCell {

    @IBOutlet weak var fileImagePT: UIImageView!
    @IBOutlet weak var fileNamePT: UILabel!
    @IBOutlet weak var textPT: UITextView!
    
    var delegate: GistFileViewCellDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        textPT.delegate = self
    }
    
    func setupWith(data: GistFile) {
        
        fileNamePT.text = data.filename
        textPT.text = data.content
        
        // we need to force a textViewDidChange method
        let textRange = textPT.textRange(from: textPT.beginningOfDocument, to: textPT.endOfDocument)
        textPT.replace(textRange!, withText: data.content)
    }
}

extension GistFileViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let height = textPT.newHeight(withBaseHeight: 64) + 40 // add the cell header area height
        delegate?.updated(height: height)
    }
}
