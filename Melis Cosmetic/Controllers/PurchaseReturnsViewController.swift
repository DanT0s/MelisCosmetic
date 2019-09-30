//
//  PurchaseReturnsViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 9/21/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

class PurchaseReturnsViewController: UIViewController {
    
    let db = Firestore.firestore()
    let pickerReason = UIPickerView()
    var timer = Timer()
    let pickerUnpacked = UIPickerView()
    let reasonForReturnArray = ["Товар поврежден","Неверный заказ","Отправлен неправельный продукт","Дефектный товар"]
    let unpackedProductArray = ["Да","Нет"]
    
    @IBOutlet weak var inquiryImageLabel: UIImageView!
    @IBOutlet weak var inquiryTextLabel: UILabel!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var quantityProductTextField: UITextField!
    @IBOutlet weak var reasonForReturnTextField: UITextField!
    @IBOutlet weak var unpackedProductTextField: UITextField!
    @IBOutlet weak var defectDescriptionTextField: UITextField!
    @IBOutlet weak var inquiryButtonLabel: UIButton!
    
    @IBAction func inquiryButtonTapped(_ sender: UIButton) {
        guard let productName = productNameTextField.text, let quantityProduct = quantityProductTextField.text, let reasonForReturn = reasonForReturnTextField.text, let unpackedProduct = unpackedProductTextField.text, let defectDescription = defectDescriptionTextField.text, productName != "", quantityProduct != "", reasonForReturn != "", unpackedProduct != "", defectDescription != "" else {
            notFieldAlert()
            return
        }
        addReturnProduct()
        animatedOrderImageEnable()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(animatedOrderImageDisable), userInfo: nil, repeats: false)
    }
    
    func notFieldAlert() {
        let acFields = UIAlertController(title: "Не удалось отправить", message: "Не все поля заполнены!", preferredStyle: .alert)
        acFields.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(acFields,animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inquiryTextLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        inquiryImageLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        pickerOption()
        setUpElements()
    }
    
    func animatedOrderImageEnable() {
           UIView.animate(withDuration: 0.5) {
               self.inquiryTextLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
               self.inquiryImageLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
           }
       }
       
    @objc func animatedOrderImageDisable() {
           UIView.animate(withDuration: 0.2) {
               self.inquiryTextLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
               self.inquiryImageLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.navigationController?.popToRootViewController(animated: true)

           }
    }
    
    
    func setUpElements() {
        
        Utilities.styleTextField(productNameTextField)
        Utilities.styleTextField(quantityProductTextField)
        Utilities.styleTextField(reasonForReturnTextField)
        Utilities.styleTextField(unpackedProductTextField)
        Utilities.styleTextField(defectDescriptionTextField)
        
        Utilities.styleFilledButton(inquiryButtonLabel)
    }
    
    func pickerOption() {
        reasonForReturnTextField.inputView = pickerReason
        unpackedProductTextField.inputView = pickerUnpacked
        pickerReason.center = view.center
        pickerUnpacked.center = view.center
        pickerReason.dataSource = self
        pickerReason.delegate = self
        pickerUnpacked.dataSource = self
        pickerUnpacked.delegate = self
    }
    
    func addReturnProduct() {
        let date = Date()
        let dateFormatterGet = DateFormatter()
        
        dateFormatterGet.dateFormat = "d/MM/yyyy HH:mm"
        
        let resultDate = dateFormatterGet.string(from: date)
        
        
        let returnProductData = [
            "productName": productNameTextField.text!,
            "quantityProduct": quantityProductTextField.text!,
            "reasonForReturn": reasonForReturnTextField.text!,
            "unpackedProduct": unpackedProductTextField.text!,
            "defectDescription": defectDescriptionTextField.text!,
            "date": resultDate
            ] as [String : Any]
        
        db.collection("returnProduct").document("return#\(arc4random())").collection("user").document(uid!).setData(returnProductData, merge: true, completion: { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            print("Successfully set add returnProductOrder")
        })
        
    }
    
    
    
}

extension PurchaseReturnsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerReason {
            return reasonForReturnArray.count
        } else if pickerView == pickerUnpacked {
            return unpackedProductArray.count
        } else {
            return 0
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerReason {
            return reasonForReturnArray[row]
        } else if pickerView == pickerUnpacked {
            return unpackedProductArray[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerReason {
            reasonForReturnTextField.text = reasonForReturnArray[row]
        } else if pickerView == pickerUnpacked {
            unpackedProductTextField.text = unpackedProductArray[row]
        }
    }
}
