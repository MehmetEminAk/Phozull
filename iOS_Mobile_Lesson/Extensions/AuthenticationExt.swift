//
//  AuthenticationExtension.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 27.04.2023.
//

import Foundation
import UIKit


extension AuthenticationVC {
    
    func configureRememberMeCheckbox(){
        rememberMeCheckBox.backgroundColor = .lightGray
        rememberMeCheckBox.layer.cornerRadius = 3
        UserDefaults.standard.set(false, forKey: "rememberMe")
        UserDefaults.standard.synchronize()
        
      
    }
    
}


extension AuthenticationVC {
    func configureAuthenticationButtons(){
        signUpBtn.addTarget(self, action: #selector(signUpBtnClicked), for: .touchUpInside)
        
        signInBtn.addTarget(self, action: #selector(signInBtnClicked), for: .touchUpInside)
        
    }

    @objc
    func signUpBtnClicked(){
        
        
        guard let email = emailTF.text , let password = passwordTF.text else {
            presentAlert(title: "HATA!", message: "Lütfen bilgilerinizi eksiksiz ve doğru formatta giriniz!")
            return
        }
        
        if  password.count >= 6 && isValidEmail(email){
            performSegue(withIdentifier: "toCompleteSignUp", sender: nil)
            
        }else {
            presentAlert(title: "HATA!", message: "Lütfen bilgilerinizi eksiksiz ve doğru formatta giriniz!")
        }
        
        
        
    }
    
    @objc
    func signInBtnClicked(){
        
        
        guard let email = emailTF.text , let password = passwordTF.text else {
            presentAlert(title: "HATA!", message: "Lütfen bilgilerinizi eksiksiz ve doğru formatta giriniz!")
            return
        }
        
        if  password.count >= 6 && isValidEmail(email){
            authViewModel.signIn(email: email, password: password) { err in
                if err != nil {
                    self.presentAlert(title: "Hata!", message: err!.localizedDescription)
                }else {
                    self.isRememberMeEnabled()
                    self.performSegue(withIdentifier: "authenticateVCToFeed", sender: nil)
                }
            }
            
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCompleteSignUp" {
            
                let destVC = segue.destination as! CompleteSigningUpVC
                destVC.email = emailTF.text
                destVC.password = passwordTF.text
        
        }
    }
    
   
    func isRememberMeEnabled() {
        
        
        if rememberMeCheckBox.backgroundColor == .blue {
            UserDefaults.standard.set(true, forKey: "rememberMe")
            UserDefaults.standard.synchronize()
        }
        
        print(UserDefaults.standard.bool(forKey: "rememberMe"))
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
