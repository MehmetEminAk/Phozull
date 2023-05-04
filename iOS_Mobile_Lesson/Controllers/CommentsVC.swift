//
//  CommentsVC.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 4.05.2023.
//

import UIKit

class CommentsVC: UIViewController {

    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var shareComment: UIButton!
    
    @IBOutlet weak var commentsView: UIView!
    var initialTextViewY: CGFloat = 0
    
    @IBAction func shareComment(_ sender: Any) {
        guard let _ = commentTextView.text else { return }
        commentVM.shareComment(commentTextView.text) { err in
            if err != nil {
                print(err!.localizedDescription)
            }
        }
    }
    
    
    
    let commentVM = CommentsVM()
    var phozullId : String!
    
    @IBOutlet weak var commentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVC()
        observeKeyboard()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialTextViewY = commentsView.frame.origin.y
    }
    

}
