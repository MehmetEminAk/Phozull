//
//  SharePhozullVC.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 1.05.2023.
//

import UIKit

class SharePhozullVC: UIViewController {

    let addPhozullVM = SharePhozullVM()
    
    @IBOutlet weak var phozullImage: UIImageView!
    
    @IBOutlet weak var phozulCommentArea: UITextView!
    
    @IBOutlet weak var sharePhozullBtn: UIButton!

    let indicatorView : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame : CGRect(x: deviceWidth - 100, y: deviceHeight - 100, width: 200, height: 200))
        
        indicator.hidesWhenStopped = true
        return indicator
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureObjects()
        
    }
    
    @IBAction func sharePhozullClicked(_ sender: Any) {
        sharePhozull()
    }
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
