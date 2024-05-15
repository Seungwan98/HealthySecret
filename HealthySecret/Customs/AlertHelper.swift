//
//  Alert.swift
//  HealthySecret
//
//  Created by 양승완 on 5/15/24.
//

import Foundation
import UIKit

class AlertHelper{
    static let shared = AlertHelper()
    private init() { }
    
    
    typealias Action = () -> ()
        
    func showDeleteConfirmation(title: String, message: String?, onConfirm: @escaping Action, over viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "삭제", style: .destructive , handler: { (_) in
            onConfirm()
        }))

        
        ac.addAction(.cancel)

        viewController.present(ac, animated: true)
    }
    
    func showRevoke(title: String, message: String?, onConfirm: @escaping Action, over viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let gotIn =  UIAlertAction(title: "확인", style: .default , handler: { (_) in
            onConfirm()
        })
        gotIn.setValue( UIColor.black , forKey: "titleTextColor")

        ac.addAction(gotIn)

        
        ac.addAction(.cancel)

        viewController.present(ac, animated: true)
    }
    
    
    
}

extension UIAlertAction {
    static var gotIt: UIAlertAction {
        let gotIn = UIAlertAction(title: "확인", style: .default, handler: nil)
        gotIn.setValue( UIColor.black , forKey: "titleTextColor")

        return gotIn
    }
    
    static var cancel: UIAlertAction {
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue( UIColor.black , forKey: "titleTextColor")
        return cancel
    }
}

