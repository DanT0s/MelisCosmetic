//
//  ProfileViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/10/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

var uid = Auth.auth().currentUser?.uid

@available(iOS 13.0, *)
class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    
    @IBOutlet weak var tableView: UITableView!
    
    public var userArray: [User] = []

    let db = Firestore.firestore()
    private var listener: ListenerRegistration!
    var documents: [DocumentSnapshot] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard uid != nil else { return }
        
        tableView?.tableFooterView = UIView(frame: .zero)
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .done, target: self, action: #selector(handleSignOutButtonTapped))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                
                print("User is signed in")
                
            } else {
               
                print("User is signed out")
              
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard uid != nil else { return }
        self.query = baseQuery()
        loadData()
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard uid != nil else { return }
        self.query = baseQuery()
        userArray.removeAll(keepingCapacity: true)
        
    }
    
    func loadData() {
        self.listener = query?.addSnapshotListener { [weak self] (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let result = snapshot.documents.map{ (document) -> User in
                if let task = User(dictionary: document.data(), id: document.documentID) {
                    return task
                } else {
                    fatalError("Unable to initialize type \(User.self) with dictionary \(document.data())")
                }
            }
            self?.documents = snapshot.documents
            self?.userArray.append(contentsOf: result)
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }
        
    }
    
    fileprivate func baseQuery() -> Query {

        return db.collection("users").document(uid!).collection("publicData")
        
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        
    }
    
    @objc func handleSignOutButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { [weak self] (action) in
        do {

            try Auth.auth().signOut()

            uid = Auth.auth().currentUser?.uid
            
            let presented = self?.presentedViewController
            presented?.removeFromParent()
            self?.navigationController?.dismiss(animated: true, completion: nil)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            UIApplication.shared.keyWindow?.rootViewController = tabBarController
            UIApplication.shared.keyWindow?.makeKeyAndVisible()

        } catch {
            print(error.localizedDescription)
        }
       
    })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
       self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ProfileTableViewCell
        
       
        cell.nameLabel.text = "\(userArray[indexPath.row].name) \(userArray[indexPath.row].surname)"
        cell.mailLabel.text = userArray[indexPath.row].email
        
        
        return cell
    }
    
    
    
    
    
    
    @IBAction func myOrdersButton(_ sender: UIButton) {
    }
    @IBAction func myProfileButton(_ sender: UIButton) {
    }
    @IBAction func languageButton(_ sender: UIButton) {
    }
    @IBAction func aboutCompButton(_ sender: UIButton) {
    }
    @IBAction func contactsButton(_ sender: UIButton) {
    }
    @IBAction func privacyButton(_ sender: UIButton) {
    }
    @IBAction func purchaseButton(_ sender: UIButton) {
    }
    @IBAction func deliveryButton(_ sender: UIButton) {
    }
    
    

}

