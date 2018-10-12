//
//  GistCommentViewCell.swift
//  PaulGistTest
//
//  Created by Paul Davis on 09/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit

class GistCommentViewCell: UITableViewCell {
    
    @IBOutlet weak var imagePT: UIImageView!
    @IBOutlet weak var namePT: UILabel!
    @IBOutlet weak var textPT: UITextView!
    
 //   var delegate: GistCellViewDelegate?
    
    // we will use a viewId which specifies which cell in teh tableview we are.
    
    var viewId: Int = 0
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    func setupWith(data: GistComment, viewId: Int) {
        
        imagePT.kf.setImage(with: URL(string: data.user.avatar_url))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: data.created_at)
        dateFormatter.dateFormat = "dd MMM yyyy"
        var created = ""
        if let d = date {
            
            created = " commented on \(dateFormatter.string(from: d))"
        }
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold(data.user.login)
            .normal(created)
        namePT.attributedText = formattedString
        
        // TODO Add formatting here for the different content type in gist's
        
        textPT.text = data.body
        
        // we need to force a textViewDidChange method
        let textRange = textPT.textRange(from: textPT.beginningOfDocument, to: textPT.endOfDocument)
        textPT.replace(textRange!, withText: data.body)
    }
}
/*
extension GistCommentViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
//        let height = textPT.newHeight(withBaseHeight: 104)
//        delegate?.updated(height: height, viewId: viewId)
    }
}
*/
