//
//  RegisterViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 7/31/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let picker = UIPickerView()
    var countries: [String] = {
        var arrayOfCountries: [String] = []
        
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue : code])
            let currentLocaleID = NSLocale.current.collatorIdentifier
            let name = NSLocale(localeIdentifier: currentLocaleID!).displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            arrayOfCountries.append(name)
        }
        return arrayOfCountries
    }()
    
    
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var surnameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var adressLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var countryLabel: UITextField!
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBAction func registerButton(_ sender: UIButton) {
        guard let name = nameLabel.text, let surname = surnameLabel.text, let email = emailLabel.text, let phoneNumber = phoneNumberLabel.text, let adress = adressLabel.text, let city = cityLabel.text, let country = countryLabel.text, let state = stateLabel.text, let password = passwordLabel.text, name != "", surname != "", email != "", phoneNumber != "", adress != "", city != "", country != "", state != "", password != "" else {
                        notFieldAlert()
                        return
                    }
     
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            
                        guard error == nil, user != nil else {
                            
                            print(error?.localizedDescription as Any)

                            return
                            }
          
            let createUid = user?.user.uid
            
            let userData = [
                "uid": createUid!,
                "name": self!.nameLabel.text!,
                "surname": self!.surnameLabel.text!,
                "email": self!.emailLabel.text!,
                "phoneNumber": self!.phoneNumberLabel.text!,
                "adress": self!.adressLabel.text!,
                "city": self!.cityLabel.text!,
                "country": self!.countryLabel.text!,
                "state": self!.stateLabel.text!
                ] as [String : Any]
            
            FirestoreReferenceManager.referenceForUserPublicData(uid: createUid!).setData(userData, merge: true, completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                print("Successfully set newest users")
                

            })
            uid = Auth.auth().currentUser?.uid
                    }
    }
    
    func notFieldAlert() {
        let acFields = UIAlertController(title: "Не удалось сохранить", message: "Не все поля заполнены!", preferredStyle: .alert)
        acFields.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(acFields,animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        countryLabel.inputView = picker
        picker.center = view.center
        picker.dataSource = self
        picker.delegate = self
        hideKeyboard()
        nameLabel.delegate = self
        surnameLabel.delegate = self
        emailLabel.delegate = self
        phoneNumberLabel.delegate = self
        adressLabel.delegate = self
        cityLabel.delegate = self
        countryLabel.delegate = self
        stateLabel.delegate = self
        passwordLabel.delegate = self
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameLabel.resignFirstResponder()
        surnameLabel.resignFirstResponder()
        emailLabel.resignFirstResponder()
        phoneNumberLabel.resignFirstResponder()
        adressLabel.resignFirstResponder()
        cityLabel.resignFirstResponder()
        countryLabel.resignFirstResponder()
        stateLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
        return true
    }

    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpElements() {
        
        Utilities.styleTextField(nameLabel)
        Utilities.styleTextField(emailLabel)
        Utilities.styleTextField(surnameLabel)
        Utilities.styleTextField(phoneNumberLabel)
        Utilities.styleTextField(adressLabel)
        Utilities.styleTextField(cityLabel)
        Utilities.styleTextField(countryLabel)
        Utilities.styleTextField(stateLabel)
        Utilities.styleTextField(passwordLabel)
        
        
        Utilities.styleFilledButton(registerButton)
    }
    
    
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryLabel.text = countries[row]
    }
}

