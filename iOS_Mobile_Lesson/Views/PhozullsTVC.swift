//
//  PhozullsVC.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 28.04.2023.
//

import UIKit
import FirebaseFirestore


class PhozullTVC: UITableViewCell {
    

    var phozull : Phozull?
    
    var db = Firestore.firestore()
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var phozullPicture: UIImageView!
    @IBOutlet weak var ownerUsername: UILabel!
    
    @IBOutlet weak var commentsString: UILabel!
    
    @IBOutlet weak var likeButton: UIImageView!
    
    @IBOutlet weak var commentButton: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    
    lazy var likedImage : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: deviceWidth / 2 - 50, y: self.phozullPicture.frame.height / 2 - 50, width: 100, height: 100))
                                    
        imageView.image = UIImage(systemName: "heart.fill")?.withTintColor(.white)
        imageView.alpha = 0.3
        imageView.isHidden = true
        return imageView
    }()
    
    
    
    @IBOutlet weak var likesLabel: UILabel!
    
    var likeCount : Int!
    
    func configure(with phozull: Phozull) {
        phozullPicture.addSubview(likedImage)
        self.phozull = phozull
        likeCount = phozull.likeCount!
        addGestures()
        self.ownerUsername.text = phozull.ownerUserName
        self.commentsString.text = "\(phozull.commentCount!) tane yorumun hepsini gör"
        self.commentsLabel.text = "\(phozull.commentCount!)"
        self.likesLabel.text = "\(phozull.likeCount!)"
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.borderColor = UIColor.black.cgColor
        
        commentsString.isUserInteractionEnabled = true
        commentButton.isUserInteractionEnabled = true
        
        db.collection("Posts").whereField("phozulId", isEqualTo: phozull.phozullId).getDocuments { querySnap, err in
            let doc = querySnap?.documents.first
            doc?.reference.collection("Likes").whereField("likeOwner", isEqualTo: currentUserId).getDocuments(completion: { snap, err in
                print(snap?.documents.count)
                if snap?.documents.count == 0 {
                    DispatchQueue.main.async {
                        self.likeButton.image = UIImage(systemName: "heart")
                    }
                }else if snap?.documents.count == 1 {
                    DispatchQueue.main.async {
                        self.likeButton.image = UIImage(systemName: "heart.fill")
                    }
                }
            })
        }
        
    }
    
   
    
     func addGestures(){
         
         let likeGesture = UITapGestureRecognizer(target: self, action: #selector(likeClicked(_:)))
         likeButton.addGestureRecognizer(likeGesture)
         
         let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
         doubleTapGesture.numberOfTapsRequired = 2
         phozullPicture.addGestureRecognizer(doubleTapGesture)
         
    }
    
   
    
    @objc
    func doubleTapped(_ sender : UITapGestureRecognizer){
        if likeButton.image == UIImage(systemName: "heart") {
            self.likeCount += 1
            DispatchQueue.main.async {
                self.likeButton.image = UIImage(systemName: "heart.fill")
                
                self.likesLabel.text = "\((self.likeCount)!)"
                self.likePost()
                
            }
        }
        showHeart()
        
    }
    
    
    @objc
    func likeClicked(_ sender : UITapGestureRecognizer){
        guard let _ = phozull  else { return }
        
    
        let selectedPhozullId = phozull?.phozullId
       
        let likeImage = sender.view as! UIImageView
        
        if likeImage.image == UIImage(systemName: "heart") {
            self.likeCount += 1
            DispatchQueue.main.async {
                likeImage.image = UIImage(systemName: "heart.fill")
                
                self.likesLabel.text = "\((self.likeCount)!)"
                self.likePost()
            }
        }
        else {
            
            self.likeCount -= 1
            DispatchQueue.main.async {
                likeImage.image = UIImage(systemName: "heart")
                self.likesLabel.text = "\((self.likeCount)!)"
                self.disLikePost()
            }
        }
    }
    

    func likePost(){
        db.collection("Posts").whereField("phozulId", isEqualTo: phozull?.phozullId).getDocuments { query, err in
            
            guard let _ = currentUserId else { return }
            let doc = query?.documents.first
            
            doc!.reference.collection("Likes").whereField("likeOwner", isEqualTo: currentUserId).getDocuments(completion: { querySnap, err in
                if err != nil {
                    print(err!.localizedDescription)
                    
                }
                
                if querySnap?.documents.count == 0 {
                    //If you are not in the  users who are liked this post , like it
                    doc?.reference.collection("Likes").addDocument(data: ["likeOwner" : currentUserId])
                    
                }
                
            })
          
        }
    }
    
    func disLikePost(){
        guard let _ = currentUserId else { return }
        db.collection("Posts").whereField("phozulId", isEqualTo: phozull?.phozullId).getDocuments { query, err in
            let doc = query?.documents.first
            
            doc?.reference.collection("Likes").whereField("likeOwner", isEqualTo: currentUserId!).getDocuments(completion: { querySnap, err in
                
                if err != nil {
                    print(err?.localizedDescription)
                }else {
                    //If you liked before ,unlike it
                    if querySnap?.documents.count == 1 {
                        let doc = querySnap?.documents.first
                        
                        doc?.reference.delete()
                    }
                }
            })
            
        }
    }
    
    
    func showHeart(){
        DispatchQueue.main.async {
            self.likedImage.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                self.likedImage.isHidden = true
            })
        }
    }
    
    
}
