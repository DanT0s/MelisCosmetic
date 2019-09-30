//
//  MyProfileViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 9/9/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

@available(iOS 13.0, *)
class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    public var user: [User] = []
    let db = Firestore.firestore()
    private var listener: ListenerRegistration!
    var documents: [DocumentSnapshot] = []
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.query = baseQuery()
        loadData()
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.query = baseQuery()
        user.removeAll(keepingCapacity: true)
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
            self?.user.append(contentsOf: result)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func popToRoot () {
        self.navigationController?.popToRootViewController(animated: true)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyProfileTableViewCell
        
        let userIndexPath = user[indexPath.row]
        cell.addressTextLabel.text = userIndexPath.adress
        cell.nameTextLabel.text = userIndexPath.name
        cell.givenNameTextLabel.text = userIndexPath.surname
        cell.phoneNumberTextLabel.text = userIndexPath.phoneNumber
        cell.cityTextLabel.text = userIndexPath.city
        cell.emailTextLabel.text = userIndexPath.email
        cell.stateTextLabel.text = userIndexPath.state
        cell.countryTextLabel.text = userIndexPath.country
        
        cell.saveButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
    
        
        tableView.rowHeight = 570
        cell.selectionStyle = .none
        
        return cell
    }

  
    
}

