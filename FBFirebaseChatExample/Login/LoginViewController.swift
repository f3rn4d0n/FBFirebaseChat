//
//  LoginViewController.swift
//  FBFirebaseChatExample
//
//  Created by Luis Fernando Bustos Ramírez on 4/1/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import LFBR_SwiftLib
import KWDrawerController
import FBFirebaseChat
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = thirdColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = thirdColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = buttonsColor
        button.setTitle("Login", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(lettersColor, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        if validateFields(){
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if let error = error {
                    MessageObject.sharedInstance.showMessage(error.localizedDescription, title: "Error", okMessage: "Accept")
                    print(error.localizedDescription)
                    return
                }
                let user = Auth.auth().currentUser;
                if (user != nil){
                    self.sendToMainController()
                }else{
                    MessageObject.sharedInstance.showMessage("Error al iniciar sesión, favor de intentar mas tarde", title: "Error", okMessage: "Accept")
                }
            }
        }
    }
    
    func handleRegister() {
        if validateFields(){
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if let error = error {
                    MessageObject.sharedInstance.showMessage(error.localizedDescription, title: "Error", okMessage: "Accept")
                    print(error.localizedDescription)
                    return
                }
                let user = Auth.auth().currentUser;
                if (user != nil){
                    self.sendToMainController()
                }else{
                    MessageObject.sharedInstance.showMessage("Error al crear tu usuario, favor de intentar mas tarde", title: "Error", okMessage: "Accept")
                }
            }
        }
    }
    
    func sendToMainController(){
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
    
    func validateFields() -> Bool{
        if !(emailTextField.text?.isEmail())!{
            MessageObject.sharedInstance.showMessage("Please enter a valid email", title: "Error", okMessage: "Accept")
            return false
        }
        if passwordTextField.text!.count < 4{
            MessageObject.sharedInstance.showMessage("Please enter a longer password", title: "Error", okMessage: "Aceptar")
            return false
        }
        if nameTextField.text!.count < 4 && loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            MessageObject.sharedInstance.showMessage("Please enter a longer name", title: "Error", okMessage: "Aceptar")
            return false
        }
        return true
    }
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("forgot password?", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(buttonsColor, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.backgroundColor = lettersColor
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = secondColor
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControl.State())
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        nameSeparatorView.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "XocoMoxo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = mainColor
        
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(forgotPasswordButton)
        
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupForgotPassword()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval){
        profileImageView.isHidden = toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight ? true : false
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupInputsContainerView() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        nameTextField.anchor(top: inputsContainerView.topAnchor,
                             leading: inputsContainerView.leadingAnchor,
                             bottom: nil,
                             trailing: inputsContainerView.trailingAnchor,
                             padding: .init(top: 0, left: 12, bottom: 0, right: 0))
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        nameSeparatorView.anchor(top: nameTextField.bottomAnchor,
                                 leading: inputsContainerView.leadingAnchor,
                                 bottom: nil,
                                 trailing: inputsContainerView.trailingAnchor,
                                 padding: .zero,
                                 size: .init(width: 0, height: 1))
        nameSeparatorView.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        emailTextField.anchor(top: nameTextField.bottomAnchor,
                              leading: inputsContainerView.leadingAnchor,
                              bottom: nil,
                              trailing: inputsContainerView.trailingAnchor,
                              padding: .init(top: 0, left: 12, bottom: 0, right: 0))
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.anchor(top: emailTextField.bottomAnchor,
                                  leading: inputsContainerView.leadingAnchor,
                                  bottom: nil,
                                  trailing: inputsContainerView.trailingAnchor,
                                  padding: .zero,
                                  size: .init(width: 0, height: 1))
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor,
                                 leading: inputsContainerView.leadingAnchor,
                                 bottom: nil,
                                 trailing: inputsContainerView.trailingAnchor,
                                 padding: .init(top: 0, left: 12, bottom: 0, right: 0))
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.anchor(top: inputsContainerView.bottomAnchor,
                                   leading: inputsContainerView.leadingAnchor,
                                   bottom: nil,
                                   trailing: inputsContainerView.trailingAnchor,
                                   padding: .init(top: 12, left: 0, bottom: 0, right: 0))
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupForgotPassword(){
        forgotPasswordButton.anchorEqualTo(view: loginRegisterButton, atYLayout: loginRegisterButton.bottomAnchor, space: 10)
    }
    
    @objc func handleForgotPassword() {
        if !(emailTextField.text?.isEmail())!{
            MessageObject.sharedInstance.showMessage("Please enter a valid email", title: "Error", okMessage: "Accept")
        }else{
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
                if let error = error {
                    MessageObject.sharedInstance.showMessage(error.localizedDescription, title: "Error", okMessage: "Accept")
                    print(error.localizedDescription)
                    return
                }else{
                    MessageObject.sharedInstance.showMessage("Mail sended successfull to: \(self.emailTextField.text!)", title: "Done", okMessage: "Accept")
                }
            }
        }
    }
}
