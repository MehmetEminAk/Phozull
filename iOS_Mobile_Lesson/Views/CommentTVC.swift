//
//  CommentTVC.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 4.05.2023.
//

import UIKit

class CommentTVC: UITableViewCell {

    
    @IBOutlet weak var commentOwnerProfilePic: UIImageView!
    
    
    @IBOutlet weak var commentInfos: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentOwnerProfilePic.layer.cornerRadius = commentOwnerProfilePic.frame.width / 2
        
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
