//
//  SharePhozullExt.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 1.05.2023.
//

import Foundation
import UIKit


extension SharePhozullVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func configureObjects(){
        
        sharePhozullBtn.isEnabled = false
        
        let imageSourceGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImageSource))
        phozullImage.addGestureRecognizer(imageSourceGesture)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(gesture)
        
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
    
    @objc
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        phozullImage.image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        sharePhozullBtn.isEnabled = true
        
        self.dismiss(animated: true)
        
    }
    
    func sharePhozull(){
        view.addSubview(indicatorView)
        let phozullData = phozullImage.image?.jpegData(compressionQuality: 0.5)
        
        if let comment = phozulCommentArea.text , comment.count > 0  {
            
            addPhozullVM.addPhozull(phozullData: phozullData!, phozullDescription: comment) { errString in
                
                self.indicatorView.stopAnimating()
                if errString != nil {
                    self.presentAlert(title: "HATA OLUŞTU", message: errString!)
                }else {
                    self.presentAlert(title: "BAŞARILI", message: "Phozull başarıyla eklendi!")
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }else {
            addPhozullVM.addPhozull(phozullData: phozullData!, phozullDescription: nil) { errString in
                self.indicatorView.stopAnimating()

                if errString != nil {
                    self.presentAlert(title: "HATA OLUŞTU", message: errString!)
                }else {
                    self.presentAlert(title: "BAŞARILI", message: "Phozull başarıyla eklendi!")
                    self.tabBarController?.selectedIndex = 0

                }
                
            }
        }
        
        
    }
    
    
}
