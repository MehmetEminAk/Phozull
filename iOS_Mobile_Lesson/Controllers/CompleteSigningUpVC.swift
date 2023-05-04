//
//  CompleteSigningUpVC.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 27.04.2023.
//

import UIKit
import FirebaseFirestore

class CompleteSigningUpVC: UIViewController {
    
    var email : String!
    var password : String!
    
    
    @IBOutlet weak var profilePicImage: UIImageView!
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var surnameTF: UITextField!
    
    @IBOutlet weak var completeSigningUpBtn: UIButton!
    
    
    @IBOutlet weak var agreementsLabel: UILabel!
    
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    var timer : Timer?
    var countDown : Double = 3
    var errAlert : UIAlertController?
    
    var authViewModel = AuthenticationVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureObjects()
    }
    
    
    @IBAction func completeSigningUpBtn(_ sender: Any) {
       
        var newUserInfos : Dictionary<String , Any> = [
            "name" : nameTF.text!,
            "username" : userNameTF.text!,
            "profileImageData" : profilePicImage.image!.jpegData(compressionQuality: 0.5)! as Data ,
            "surname" : surnameTF.text! ,
            "email" : email! ,
            "password" : password! ,
            "birthdate" : Timestamp(date: birthDatePicker.date)
        ]
        authViewModel.signUp(personData: &newUserInfos) { err in
            if err != nil {
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownDecrease(_:)), userInfo: err!.localizedDescription, repeats: true)
                
                let action = UIAlertAction(title: "GİT", style: .default) { _ in
                    self.performSegue(withIdentifier: "completeVCToLogin", sender: nil)
                }
                
                
                self.errAlert = UIAlertController(title: "HATA", message: "\(err!.localizedDescription) \n \(self.countDown) sn içerisinde giriş sayfasına yönlendirileceksiniz", preferredStyle: .alert)
                self.errAlert?.addAction(action)
                
                self.present(self.errAlert!, animated: true)
                
            }else {
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
            }
        }
        
    }
    
    @objc
    func countDownDecrease(_ sender : Timer){
        if countDown > 0 {
            
            let message = sender.userInfo as! String
            
            self.countDown -= 1
            DispatchQueue.main.async {
                self.errAlert?.message = "\(message) \n \(self.countDown) sn içerisinde giriş sayfasına yönlendirileceksiniz"
            }
            
            
        }else {
            
            timer?.invalidate()
            self.performSegue(withIdentifier: "completeVCToLogin", sender: nil)
        }
       
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        let eightennYearsAgo = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        if birthDatePicker.date > eightennYearsAgo! {
            completeSigningUpBtn.isEnabled = false
        }else {
            completeSigningUpBtn.isEnabled = true
        }
    }
    
    
    
}
