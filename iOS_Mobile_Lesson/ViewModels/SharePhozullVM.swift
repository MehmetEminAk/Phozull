//
//  SharePhozullVM.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 1.05.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

protocol SharePhozulDelegate : AnyObject {
    
}


class SharePhozullVM {
    
    private let db = Firestore.firestore()
    
    private let storage = Storage.storage().reference()
    
    private let currentUserId = Auth.auth().currentUser?.uid
    
    func addPhozull(phozullData : Data , phozullDescription : String? , completion : @escaping (String?) -> Void){
        let dateFormatter = DateFormatter()
        let presentTimeStampString = dateFormatter.string(from: Date())
        let presentTimeStamp = Timestamp(date: Date())
        
        let id = UUID().uuidString
        let imageRef = storage.child("Posts").child(currentUserId!).child(presentTimeStampString)
        let dbRef = db.collection("Posts").document(id)
        
        imageRef.putData(phozullData) { _, err in
            if err != nil {
                completion(err?.localizedDescription)
            }else {
                imageRef.downloadURL { url, err in
                    if err != nil {
                        completion(err?.localizedDescription)
                    }else {
                        dbRef.setData([
                    "createDate" : presentTimeStamp ,
                    "phozullUrl" : url!.absoluteString,
                    "phozullOwner" : self.currentUserId!,
                    "phozulId" : UUID().uuidString]) { err in
                        if err != nil {
                            completion(err?.localizedDescription)
                        }else {
                            guard let _ = phozullDescription  else {
                                return
                            }
                            
                            dbRef.collection("Comments").document().setData([
                                "commentOwnerId" : self.currentUserId! ,
                                "comment" : phozullDescription ,
                                "createdAt" : presentTimeStamp])
                            { err in
                                err != nil ? completion(err!.localizedDescription) : completion(nil)
                            }
                        }
                    }
                    }
                }
            }
        }
        
        
        
    }
}
