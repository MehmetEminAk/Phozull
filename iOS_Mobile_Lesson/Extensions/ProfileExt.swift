//
//  ProfileExt.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 28.04.2023.
//

import Foundation
import UIKit
import FirebaseAuth

extension ProfileVC : UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return profileVM.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let collViewCell = myPhozullsCollectionView.dequeueReusableCell(withReuseIdentifier: "myPhozull", for: indexPath) as! MyPhozullCVC
        collViewCell.myPhozullImage.kf.setImage(with: URL(string: profileVM.phozulls[indexPath.row]))
        collViewCell.layer.cornerRadius = 10
        
        return collViewCell
    }
    
    func configCollView(){
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: deviceWidth * 0.4, height: deviceHeight * 0.2)
        collectionViewFlowLayout.minimumInteritemSpacing = deviceWidth * 0.08
        myPhozullsCollectionView.collectionViewLayout = collectionViewFlowLayout
    }
    
    
}

extension ProfileVC : ProfileDelegate {
    
    func updateUI() {
        DispatchQueue.main.async {
            self.myPhozullsCollectionView.reloadData()
        }
    }
    
    func initViewController(){
        profileVM.delegate = self
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
    }
    
    func putPersonalInfos(with datas: MyPersonalData) {
        
        DispatchQueue.main.async {
            self.profileImage.kf.setImage(with: URL(string: datas.myProfileImage!))
            self.nameAndSurnameLabel.text = datas.myName! + datas.mySurname!
            self.usernameLabel.text = "@" + datas.myUserName!
        }
    }
    
}


extension ProfileVC {
    func configureNavBar(){
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "door.left.hand.open"), style: .plain, target: self, action: #selector(areSureToSignOut))
    }
    
    @objc
    func areSureToSignOut(){
        let action = UIAlertAction(title: "Evet", style: .default) { act in
            try! Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "rememberMe")
            self.performSegue(withIdentifier: "profileVCtoLogin", sender: nil)
        }
        let okAction = UIAlertAction(title: "Hayır", style: .cancel)
        
        self.presentAlert(title: "Emin misin?", message: "Eğer çıkış yaparsanız bir daha giriş yapmak zorunda kalacaksınız" , actions: [action,okAction])
    }
}
