//
//  CompleteSignUpExt.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 28.04.2023.
//

import Foundation
import UIKit

extension CompleteSigningUpVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func configureObjects(){
        
        
        let imageSourceGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImageSource))
        profilePicImage.addGestureRecognizer(imageSourceGesture)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(gesture)
        completeSigningUpBtn.isEnabled = false
        
        let openAgreementsGesture = UITapGestureRecognizer(target: self, action: #selector(openAgrrements))
        agreementsLabel.addGestureRecognizer(openAgreementsGesture)
        
    }
    
    @objc
    func openAgrrements(){
        performSegue(withIdentifier: "toAgreements", sender: nil)
    }
    
    @objc
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc
    func chooseImageSource(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        let galleryAction = UIAlertAction(title: "Galeri", style: .default) { _ in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "Kamera", style: .default) { _ in
            picker.sourceType = .camera
            picker.modalPresentationStyle = .fullScreen
            self.present(picker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        self.presentAlert(title: "Kaynak Seçin", message: "Lütfen resim kaynağını seçiniz" , style: .actionSheet , actions: [galleryAction, cameraAction, cancelAction])
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.main.async {
            self.profilePicImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            
        }
        picker.dismiss(animated: true)
        
    }
    
    
}


extension CompleteSigningUpVC : UITextFieldDelegate {
    
    @IBAction func textFieldEditingChanged(_ sender : UITextField) {
        let message = validateForm()
        
        if message != nil {
            self.presentAlert(title: "HATA!", message: message!)
        }
        
    }
    
    func validateForm() -> String? {
        guard let username = userNameTF.text , !username.isEmpty else {
            completeSigningUpBtn.isEnabled = false
            return nil
        }
        
        guard let name = nameTF.text , !name.isEmpty else {
            completeSigningUpBtn.isEnabled = false
            return nil
        }
        
        guard let surname = surnameTF.text , !surname.isEmpty else {
            completeSigningUpBtn.isEnabled = false
            return nil
        }
        
        let eighteeenYearsAgo = Calendar.current.date(byAdding: .year, value: -18, to: birthDatePicker.date)
        
        if birthDatePicker.date > eighteeenYearsAgo! {
            completeSigningUpBtn.isEnabled = false
            return "Uygulamayı kullanabilmek için en az 18 yaşında olmanız gerekmektedir"
        }
        
        completeSigningUpBtn.isEnabled = true
        return nil
    }
    
}


