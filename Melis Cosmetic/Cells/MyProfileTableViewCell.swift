//
//  MyProfileTableViewCell.swift
//  Melis Cosmetic
//
//  Created by macbook on 9/10/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

@available(iOS 13.0, *)
class MyProfileTableViewCell: UITableViewCell, UITextFieldDelegate {

    
    let navigationController = UINavigationController()
    var delegate: CustomCellDelegate?
    
    @IBOutlet weak var nameTextLabel: UITextField!
    @IBOutlet weak var givenNameTextLabel: UITextField!
    @IBOutlet weak var emailTextLabel: UITextField!
    @IBOutlet weak var phoneNumberTextLabel: UITextField!
    @IBOutlet weak var addressTextLabel: UITextField!
    @IBOutlet weak var cityTextLabel: UITextField!
    @IBOutlet weak var countryTextLabel: UITextField!
    @IBOutlet weak var stateTextLabel: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextLabel.text, let givenname = givenNameTextLabel.text, let email = emailTextLabel.text, let phoneNumber = phoneNumberTextLabel.text, let address = addressTextLabel.text, let city = cityTextLabel.text, let country = countryTextLabel.text, let state = stateTextLabel.text, name != "", givenname != "", email != "", phoneNumber != "", address != "", city != "", country != "", state != "" else {
            notFieldAlert()
            return
        }
        checkoutUserData()
        
    }
    
    func notFieldAlert() {
    
        let acFields = UIAlertController(title: "Не удалось сохранить", message: "Не все поля заполнены!", preferredStyle: .alert)
        acFields.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(acFields, animated: true, completion: nil)
    }
    
    func unwindToBack(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.destination as? ProfileViewController
        // Use data from the view controller which initiated the unwind segue
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpElements()
        nameTextLabel.delegate = self
        givenNameTextLabel.delegate = self
        emailTextLabel.delegate = self
        phoneNumberTextLabel.delegate = self
        addressTextLabel.delegate = self
        cityTextLabel.delegate = self
        countryTextLabel.delegate = self
        stateTextLabel.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           nameTextLabel.resignFirstResponder()
           givenNameTextLabel.resignFirstResponder()
           emailTextLabel.resignFirstResponder()
           phoneNumberTextLabel.resignFirstResponder()
           addressTextLabel.resignFirstResponder()
           cityTextLabel.resignFirstResponder()
           countryTextLabel.resignFirstResponder()
           stateTextLabel.resignFirstResponder()
           return true
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpElements() {
        
        Utilities.styleTextField(nameTextLabel)
        Utilities.styleTextField(givenNameTextLabel)
        Utilities.styleTextField(emailTextLabel)
        Utilities.styleTextField(phoneNumberTextLabel)
        Utilities.styleTextField(addressTextLabel)
        Utilities.styleTextField(cityTextLabel)
        Utilities.styleTextField(countryTextLabel)
        Utilities.styleTextField(stateTextLabel)
        
        Utilities.styleFilledButton(saveButton)
    }
    
    func checkoutUserData() {
        
        let userData = [
            "name": nameTextLabel.text!,
            "surname": givenNameTextLabel.text!,
            "email": emailTextLabel.text!,
            "phoneNumber": phoneNumberTextLabel.text!,
            "state": stateTextLabel.text!,
            "country": countryTextLabel.text!,
            "adress": addressTextLabel.text!,
            "city": cityTextLabel.text!
            ] as [String : Any]
        
        FirestoreReferenceManager.referenceForUserPublicData(uid: uid!).setData(userData, merge: true, completion: { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            print("Successfully set add newest userData")
        })
        
    }
}

