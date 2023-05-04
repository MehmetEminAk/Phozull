//
//  CommentsVM.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 4.05.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol CommentsDelegate : AnyObject{
    func updateComments()
}


class CommentsVM {
    weak var delegate : CommentsDelegate?
    
    var phozullId : String?
    
    let db = Firestore.firestore()
    
    var comments : [Comment] = []
    
    let currentUserId = Auth.auth().currentUser?.uid
    
    func fetchPhozullComments(completion : @escaping (Error?) -> Void){
        guard let _ = phozullId else { return }
        
        comments.removeAll()
        
        let group = DispatchGroup()
        
        db.collection("Posts").whereField("phozulId", isEqualTo: phozullId!).getDocuments { doc, err in
            if err != nil {
                completion(err)
            }else {
               
                let doc = doc?.documents.first
               
                
                
                doc?.reference.collection("Comments").getDocuments(completion: { snap, err in
                    if err != nil {
                        completion(err)
                    }else {
                        
                        
                        snap?.documents.forEach({ doc in
                            
                            
                            let comment = doc.data()["comment"] as! String
                           
                            let commentOwnerID = doc.data()["commentOwnerId"] as! String
                            
                            group.enter()
                            fetchCommentOwnerDatas(with: commentOwnerID) {  profilePicString, username in
                                guard let _ = profilePicString , let _ = username else {  return }
                                let comment = Comment(ownerProfilePic: profilePicString!, ownerUserName: username!, comment: comment)
                                
                                self.comments.append(comment)
                                group.leave()
                                
                            }
                            
                        })
                        group.notify(queue: .main){
                            self.delegate?.updateComments()
                        }
                        
                    }
                })
            }
            
        }
        
        func fetchCommentOwnerDatas(with uid : String, completion : @escaping (String? , String?) -> Void){
            db.collection("users").whereField("id", isEqualTo: uid).getDocuments { snap, err in
                let doc = snap?.documents.first
                
                let userProfilePic = doc?.data()["profilePicUrl"] as! String
                let username = doc?.data()["username"] as! String
                
                completion(userProfilePic,username)
            }
        }
        
        
    }
}

extension CommentsVM {
    func numberOfRows() -> Int {
        return comments.count
    }
}

extension CommentsVM {
    func shareComment(_ comment : String,completion : @escaping (Error?) -> Void) {
        
        guard let _ = currentUserId else { return }
        
        db.collection("Posts").whereField("phozulId", isEqualTo: phozullId!).getDocuments { querySnap, err in
            if err != nil {
                print(err!.localizedDescription)
            }else {
                let doc = querySnap?.documents.first
                doc?.reference.collection("Comments").addDocument(data: [
                    "comment" : comment ,
                    "commentOwnerId" : self.currentUserId!,
                    "createdAt" : Timestamp(date: Date())
                ] , completion: { err in
                    if err != nil { completion(err)}
                    else {
                        self.fetchPhozullComments { _ in
                        
                    }
                        
                    }
                })
            }
        }
    }
}
