//
//  DetailAuthViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/21/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase


class DetailAuthViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var myView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            notFieldAlert()
            
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.noSuchUserAlert()
              
            }
            if user != nil {
              
                if let presented = self?.presentedViewController {
                    presented.removeFromParent()
                }

                uid = Auth.auth().currentUser?.uid
                return
            }
            
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
    }
    
    func notFieldAlert() {
        let acLogin = UIAlertController(title: "Не удалось войти", message: "Не все поля заполнены!", preferredStyle: .alert)
        acLogin.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(acLogin,animated: true, completion: nil)
    }
  
    func noSuchUserAlert() {
        let acNoUser = UIAlertController(title: "Не удалось войти", message: "Неверный пароль или такой пользователь не существует", preferredStyle: .alert)
        acNoUser.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(acNoUser, animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        hideKeyboard()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    func setUpElements() {
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleHollowButton(registerButton)
        Utilities.styleFilledButton(loginButton)
    }
    
    
    
    
}
