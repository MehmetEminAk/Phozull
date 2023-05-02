//
//  ViewController.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 27.04.2023.
//

import UIKit

class AuthenticationVC: UIViewController {
    
    
    @IBOutlet weak var rememberMeCheckBox: UIButton!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    var authViewModel = AuthenticationVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRememberMeCheckbox()
        configureAuthenticationButtons()
    }

    
    @IBAction func rememberMeClicked(_ sender: Any) {
        
        
        
        switch rememberMeCheckBox.backgroundColor! {
        case .lightGray :
            rememberMeCheckBox.backgroundColor = .blue
            
        case .blue :
            rememberMeCheckBox.backgroundColor = .lightGray
            
        default:
            print("Unknown error!")
        }
    }
    
    
    
    
}

