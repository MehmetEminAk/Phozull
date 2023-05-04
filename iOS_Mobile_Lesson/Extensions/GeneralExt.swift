//
//  GeneralExt.swift
//  iOS_Mobile_Lesson
//
//  Created by Macbook Air on 27.04.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title : String ,
                      message : String ,
                      style : UIAlertController.Style = .alert ,
                      actions : [UIAlertAction] = [UIAlertAction(title: "TAMAM", style: .cancel)]
    )
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        actions.forEach { alertAction in
            alert.addAction(alertAction)
        }
        self.present(alert, animated: true)
        
    }
}


