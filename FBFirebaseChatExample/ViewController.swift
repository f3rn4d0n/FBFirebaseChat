//
//  ViewController.swift
//  FBFirebaseChatExample
//
//  Created by Luis Fernando Bustos Ramírez on 3/17/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import LFBR_SwiftLib
import FBFirebaseChat
import FirebaseAuth
import NVActivityIndicatorView
import KWDrawerController
import FirebaseDatabase
import CodableFirebase

class ViewController: UIViewController,NVActivityIndicatorViewable {

    let appVersion: UILabel = {
        let versionLbl = UILabel()
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String {
            versionLbl.text = "V. \(text)"
        }
        return versionLbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(appVersion)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkAppVersion { (appVersion) in
            switch (appVersion){
            case .failure(let error):
                MessageObject.sharedInstance.showMessage(error.localizedDescription, title: "Error", okMessage: "Accept")
            case .success(let success):
                print(success)
                var version = 0
                if var text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    text = text.replacingOccurrences(of: ".", with: "")
                    version = Int(text) ?? 0
                }
                if success.iOS > version{
                    self.updateVersion()
                }else{
                    let user = Auth.auth().currentUser;
                    if (user != nil){
                        self.sendToMainController()
                    }else{
                        self.sendToLogin()
                    }
                }
            }
        }
    }
    
    func updateVersion(){
        let okAction = UIAlertAction(title: "Download", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            let urlStr = "itms://itunes.apple.com/us/app/..."
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string: urlStr)!)
            }
        }
        MessageObject.sharedInstance.showMessage("To get a better experience, please download the newest version.", title: "Old version",  okAction: okAction)
    }
    
    func sendToLogin(){
        let loginView = LoginViewController()
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    func sendToMainController(){
        FBChatConfiguration().setCurrentUserKey(Auth.auth().currentUser!.uid)
        let drawerController = DrawerController()
        let drawerVC = DrawerViewController()
        let chatListVC = ChatRoomsListTableViewController()
        let navigationC = UINavigationController()
        navigationC.viewControllers = [chatListVC]
        
        drawerController.setViewController(navigationC, for: .none)
        drawerController.setViewController(drawerVC, for: .left)
        
        if UIApplication.shared.windows.count > 1 {
            UIApplication.shared.windows[0].rootViewController = drawerController
            UIApplication.shared.windows[0].makeKeyAndVisible()
        }else{
            UIApplication.shared.keyWindow?.rootViewController = drawerController
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
    
    fileprivate func checkAppVersion(completion:@escaping(Result<AppVersion,Error>) -> Void){
        Database.database().reference().child("app_configuration").child("app_version").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            do {
                let appVersion = try FirebaseDecoder().decode(AppVersion.self, from: value)
                completion(.success(appVersion))
            }catch let error{
                completion(.failure(error))
            }
        }) { (error) in
            completion(.failure(error))
        }
    }
    
    fileprivate struct AppVersion: Codable{
        var Android = 0
        var iOS = 0
    }
}
