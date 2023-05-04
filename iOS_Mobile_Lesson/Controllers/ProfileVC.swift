//
//  ProfileVC.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 28.04.2023.
//

import UIKit

class ProfileVC: UIViewController {

    
    @IBOutlet weak var myPhozullsCollectionView: UICollectionView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameAndSurnameLabel: UITextView!
    
    @IBOutlet weak var usernameLabel: UITextView!
    
    
    let profileVM = ProfileVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
        configureNavBar()
        configCollView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        profileVM.fetchMyPhozulls { err in
            if err != nil {
                self.presentAlert(title: "HATA", message: err!.localizedDescription)
            }
        }
        
        profileVM.fetchMyProfileInfos { err in
            if err != nil {
                self.presentAlert(title: "HATA", message: err!.localizedDescription)
            }
        }
        
    }

}
