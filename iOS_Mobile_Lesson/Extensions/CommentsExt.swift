//
//  CommentsExt.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 4.05.2023.
//

import Foundation
import UIKit


extension CommentsVC : UITableViewDelegate , UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentVM.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTVC
        let comment = commentVM.comments[indexPath.row]
        cell.commentOwnerProfilePic.kf.setImage(with: URL(string: comment.ownerProfilePic))
        cell.commentInfos.text = "@\(comment.ownerUserName) \n\n \(comment.comment)"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return deviceHeight * 0.1
    }
}


extension CommentsVC : CommentsDelegate {
    func configVC(){
        shareComment.isEnabled = false
        commentVM.delegate = self
        commentVM.phozullId = phozullId
        
        commentVM.fetchPhozullComments { err in
            if err != nil {
                self.presentAlert(title: "HATA", message: err!.localizedDescription)
            }
        }
        navigationController?.navigationBar.isHidden = false
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dissmisKeyboard))
        view.addGestureRecognizer(gesture)
        
        commentTextView.layer.cornerRadius = 10
        
    }
    
    func updateComments() {
        DispatchQueue.main.async {
            self.commentsTable.reloadData()
        }
    }
    
    @objc
    private func dissmisKeyboard(){
        view.endEditing(true)
    }
    
    
}


extension CommentsVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentTextView.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !(commentTextView.text.count > 0) {
            commentTextView.text = "Yorumunuz"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            shareComment.isEnabled = true
        }else {
            shareComment.isEnabled = false
        }
    }
    
}


extension CommentsVC {
    func observeKeyboard(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        // Calculate the new Y position of the text view
        let newTextViewY = view.frame.height - keyboardSize.height - commentTextView.frame.height
        
        // Update the Y position of the text view
        commentsView.frame.origin.y = newTextViewY - 20
        
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset the Y position of the text view
         commentsView.frame.origin.y = initialTextViewY
    }
}


