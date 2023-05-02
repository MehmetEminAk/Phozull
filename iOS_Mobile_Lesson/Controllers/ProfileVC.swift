//
//  ProfileVC.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 28.04.2023.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()

    }
    
    func configureVC(){
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "door.left.hand.open"), style: .plain, target: self, action: #selector(areSureToSignOut))
    }
    
    @objc
    func areSureToSignOut(){
        let action = UIAlertAction(title: "Evet", style: .default) { act in
            try! Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "rememberMe")
            self.performSegue(withIdentifier: "profileVCtoLogin", sender: nil)
        }
    }


}
