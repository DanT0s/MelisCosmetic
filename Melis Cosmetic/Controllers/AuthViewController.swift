//
//  AuthViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/21/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase


@available(iOS 13.0, *)
class AuthViewController: UIViewController {

    @IBOutlet var viewController: UIView!
    @IBOutlet weak var descriptionLoginLabel: UILabel!
    @IBOutlet weak var preloginButtonLabel: UIButton!
    @IBAction func preloginButton(_ sender: UIButton) {
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
           if user != nil {
               
               let profileController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
               let profileNavigationController = UINavigationController(rootViewController: profileController)
               profileNavigationController.modalTransitionStyle = .crossDissolve
               profileNavigationController.view.backgroundColor = .clear
               
               profileNavigationController.modalPresentationStyle = .overCurrentContext
               
               self?.present(profileNavigationController, animated: false, completion: nil)
               
               return
           }
       }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)


    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.styleFilledButton(preloginButtonLabel)
        
        
    }
    
    
    
    
}
