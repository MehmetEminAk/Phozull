//
//  FeedVC.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 28.04.2023.
//

import Foundation
import UIKit
import Kingfisher

extension FeedVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedVM.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = phozullsTable.dequeueReusableCell(withIdentifier: "phozullCell") as! PhozullTVC
        cell.configure(with: feedVM.phozulls[indexPath.row])
        cell.profileImage.kf.setImage(with: URL(string: feedVM.phozulls[indexPath.row].ownerProfilePic!))
    
        cell.phozullPicture.kf.setImage(with: URL(string: feedVM.phozulls[indexPath.row].image!))
        
        cell.commentsString.tag = indexPath.row
        
        let commentsStringGesture = UITapGestureRecognizer(target: self, action: #selector(commentClicked(_:)))
        let commentBtnGesture = UITapGestureRecognizer(target: self, action: #selector(commentClicked(_:)))
        
        cell.commentsString.addGestureRecognizer(commentsStringGesture)
        cell.commentButton.addGestureRecognizer(commentBtnGesture)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return deviceHeight * 0.6
    }
    
    
    
    @objc
    func commentClicked(_ sender : UITapGestureRecognizer){
        
        let label = sender.view as! UILabel
        print(label)
        print(label.tag)
        dump(feedVM.phozulls)
        let phozullId = feedVM.phozulls[label.tag].phozullId
        performSegue(withIdentifier: "toPhozullComments", sender: phozullId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhozullComments" {
            let destinationVC = segue.destination as! CommentsVC
            destinationVC.phozullId = sender as? String
        }
        
    }
    
}

extension FeedVC : FeedDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            self.phozullsTable.reloadData()
        }
    }
    
    
    func configureVC(){
        feedVM.delegate = self
        navigationController?.navigationBar.isHidden = true
       
    }
    
}

