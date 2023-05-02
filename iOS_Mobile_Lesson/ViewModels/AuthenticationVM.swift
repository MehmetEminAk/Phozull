//
//  AuthenticationVM.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 27.04.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


protocol AnyAuthenticationDelegate : AnyObject {
    
}


class AuthenticationVM {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    
    func signIn(email : String , password : String , completion : @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, err in
            
            guard let _ = err  else {
                completion(nil)
                return
            }
            
            completion(err)
            
        }
    }
    
    func signUp(personData : inout Dictionary<String,Any> , completion : @escaping (Error?) -> Void){
        
        var personInfo = personData
        let id = UUID().uuidString
        let imageRef =  storage.child("ProfilePictures").child(id)
        
        
        imageRef.putData(personInfo["profileImageData"] as! Data) { _, err in
            if err != nil {
                
                completion(err)
                return
            }else {
                
                let password = personInfo["password"] as! String
                personInfo.removeValue(forKey: "profileImageData")
                personInfo.removeValue(forKey: "password")
                
                imageRef.downloadURL(completion: { url, err in
                
                    personInfo["profilePicUrl"] = url?.absoluteString
                    
                    self.db.collection("users")
                        .document(id)
                        .setData(personInfo) { err in
                            
                            if err != nil {
                                completion(err)
                                return
                            }
                            else {
                                Auth.auth()
                                    .createUser(withEmail: personInfo["email"] as! String, password: password) { meta, err in
                                        
                                        
                                        if err != nil {
                                            completion(err)
                                            return
                                        }else {
                                            self.db.collection("users").document(id).updateData([
                                                "id" : meta?.user.uid
                                            ]) { err in
                                                if err != nil {
                                                    completion(err)
                                                    return
                                                }else {
                                                    completion(nil)
                                                }
                                            }
                                            completion(nil)
                                        }
                                    }
                            }
                        }
                    
                })
            }
        }
    
        
       
        
        
        
        
        
        
        
        
        
    }
    
    
   
}
