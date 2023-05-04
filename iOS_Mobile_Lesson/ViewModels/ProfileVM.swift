//
//  ProfileVM.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 28.04.2023.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol ProfileDelegate : AnyObject {
    func updateUI()
    func putPersonalInfos(with datas : MyPersonalData)
}

class ProfileVM {
    weak var delegate : ProfileDelegate?
    
    var currUserId = Auth.auth().currentUser?.uid
    
    var db = Firestore.firestore()
    
    var phozulls : [String] = []
    
    func numberOfRows() -> Int {
        return phozulls.count
    }
    
    func fetchMyPhozulls(completion : @escaping (Error?) -> Void){
        phozulls.removeAll()
        
        guard let _ = currUserId  else { return }

        
        db.collection("Posts").whereField("phozullOwner", isEqualTo: currUserId!).getDocuments { querySnap, err in
            if err != nil {
                completion(err)
            }else {
                querySnap?.documents.forEach({ doc in
                    
                    
                    let phozullUrl = doc.data()["phozullUrl"] as! String
                    self.phozulls.append(phozullUrl)
                    
                })
                self.delegate?.updateUI()
                completion(nil)
            }
        }
    }
    
    
    func fetchMyProfileInfos(completion : @escaping (Error?) -> Void){
        guard let _ = currUserId  else { return }
        db.collection("users").whereField("id", isEqualTo: currUserId!).getDocuments { querySnap, err in
            if err != nil {
                completion(err)
            }else {
                var myPersonalData : MyPersonalData?
                
                querySnap?.documents.forEach({ doc in
                    let name = doc.data()["name"] as! String
                    
                    let surname = doc.data()["surname"] as! String
                    
                    let username = doc.data()["username"] as! String
                    
                    let profilePic = doc.data()["profilePicUrl"] as! String
                    
                    myPersonalData = MyPersonalData(myProfileImage: profilePic,myName: name , mySurname: surname, myUserName: username)
                })
                self.delegate?.putPersonalInfos(with: myPersonalData!)
                completion(nil)
            }
        }
    }
    
    
}
