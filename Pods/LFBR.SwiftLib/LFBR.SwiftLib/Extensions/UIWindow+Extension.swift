//
//  UIWindow+Extension.swift
//  ExtensionManager
//
//  Created by Luis Fernando Bustos Ramírez on 3/13/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

class UIWindow_Extension: NSObject {

}

public extension UIWindow {
    
    
    /// Get top visible view controller
    ///
    /// - Returns: Top view controller 
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = UIApplication.shared.keyWindow?.rootViewController {
            return UIWindow.getVisibleViewController(viewController: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewController(viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return getVisibleViewController(viewController: navigationController.visibleViewController)
        }
        if let tabBarController = viewController as? UITabBarController {
            return getVisibleViewController(viewController: tabBarController.selectedViewController)
        }
        if let splitViewController = viewController as? UISplitViewController {
            return getVisibleViewController(viewController: splitViewController.viewControllers.last)
        }
        if let presentedViewController = viewController?.presentedViewController {
            return getVisibleViewController(viewController: presentedViewController)
        }
        
        return viewController
    }
    
    class func getVisibleViewController(viewController: UIViewController?, exceptions: Array<AnyObject.Type>?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return getVisibleViewController(viewController: navigationController.visibleViewController, exceptions:exceptions)
        }
        if let tabBarController = viewController as? UITabBarController {
            return getVisibleViewController(viewController: tabBarController.selectedViewController, exceptions:exceptions)
        }
        if let splitViewController = viewController as? UISplitViewController {
            return getVisibleViewController(viewController: splitViewController.viewControllers.last, exceptions:exceptions)
        }
        if let presentedViewController = viewController?.presentedViewController {
            let numberCount = exceptions?.count ?? 0
            if numberCount > 0 {
                var allowed = true
                for vcType in exceptions! {
                    //                    print("Pvc Exception \(vcType), presentedview \(String(describing: presentedViewController)")
                    if presentedViewController.isKind(of: vcType) {
                        //                        print("Pvc Mismo tipo de pvc. Es un controlador no permitido, no se mostrará")
                        allowed = false
                        break
                    }
                }
                if allowed {
                    return getVisibleViewController(viewController: presentedViewController, exceptions:exceptions)
                } else {
                    return nil
                }
            } else {
                return getVisibleViewController(viewController: presentedViewController, exceptions:exceptions)
            }
        }
        
        if let vc = viewController {
            let numberCount = exceptions?.count ?? 0
            if numberCount > 0 {
                var allowed = true
                for vcType in exceptions! {
                    if vc.isKind(of: vcType) {
                        allowed = false
                        break
                    }
                }
                if allowed {
                    return viewController
                } else {
                    return nil
                }
            } else {
                return viewController
            }
        } else {
            return nil
        }
    }
}

