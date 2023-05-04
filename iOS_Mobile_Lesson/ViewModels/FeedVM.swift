//
//  FeedVM.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 28.04.2023.
//

import Foundation
import FirebaseFirestore

protocol FeedDelegate : AnyObject {
    func updateUI()
}


class FeedVM  {
    
    private let db = Firestore.firestore()
    weak var delegate : FeedDelegate?
    
    var phozulls : [Phozull] = []
    
    func numberOfRows() -> Int {
        return phozulls.count
    }
    
    func fetchPhozulls(){
        phozulls.removeAll()
        
        db.collection("Posts").order(by: "createDate", descending: true).getDocuments { snapshot, err in
            snapshot?.documents.forEach({ postDocument in
                let phozullOwner = postDocument.data()["phozullOwner"] as! String
                let phozullUrl = postDocument.data()["phozullUrl"] as! String
        
        
                let id = postDocument.data()["phozulId"] as! String
                
                postDocument.reference.collection("Comments").getDocuments { snap, err in
                    let commentCount = snap?.documents.count
                    
                    self.db.collection("users").whereField("id", isEqualTo: phozullOwner).getDocuments { snapshot, err in
                        
                        let userDocRef = snapshot?.documents.first
                        let userName = userDocRef?.data()["username"] as! String
                        let profilePic = userDocRef?.data()["profilePicUrl"] as! String
                    
                        
                        postDocument.reference.collection("Likes").getDocuments { querySnap, err in
                            let likesCount = querySnap?.documents.count
                            
                            self.phozulls.append(Phozull(image: phozullUrl , ownerUserName : userName, ownerProfilePic: profilePic , likeCount: likesCount , commentCount: commentCount , commentCountText: 10, phozullId: id))
                            self.delegate?.updateUI()
                        }
                        
                        

                    }
                }
                
                
                
                
                
                
            })
        }
    }
    
    
}
