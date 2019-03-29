//
//  ViewController+ExtensionViewController.swift
//  ExtensionManager
//
//  Created by Luis Fernando Bustos Ramírez on 3/13/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

class ViewController_Extension: UIViewController {

    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.endEditing(true)
    }

}

// Put this piece of code anywhere you like
public extension UIViewController {
    /// Remove keyboard when tap over any part of windows
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /// Remove keyboard when tap over any part of selected view
    func hideKeyboardWhenTappedIn(currentView: UIView){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        currentView.addGestureRecognizer(tap)
    }
    
    /// Dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    /// Get keyboard height
    ///
    /// - Returns: Keyboard height
    func  heightKeyboard() -> CGFloat{
        if UIDevice().userInterfaceIdiom == .phone {
            switch IPHONE_DEVICE{
            case .IPHONE_4:
                return 245.0
            case .IPHONE_5:
                return 250.0
            case .IPHONE_6:
                return 256.0
            case .IPHONE_6_PLUS:
                return 267.0
            case .IPHONE_X:
                return 298.0
            case .IPHONE_UNKNOWN:
                break
            }
        }
        return 256.0
    }
    
    
}
