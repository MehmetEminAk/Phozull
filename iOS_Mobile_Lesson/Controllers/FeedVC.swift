//
//  FeedVC.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 28.04.2023.
//

import UIKit

class FeedVC: UIViewController {

    var feedVM = FeedVM()
    
    @IBOutlet weak var phozullsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        feedVM.fetchPhozulls()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
