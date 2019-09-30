//
//  MyOrdersViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 9/17/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

class MyOrdersViewController: UIViewController {

    let db = Firestore.firestore()
    private var listener: ListenerRegistration!
    var myOrdersArray: [MyOrders] = []
    var documents: [DocumentSnapshot] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.query = baseQuery()
        loadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        myOrdersArray.removeAll(keepingCapacity: true)
        self.query = baseQuery()
        
    }
    
    func loadData() {
        self.listener = query?.addSnapshotListener { [weak self] (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let result = snapshot.documents.map { (document) -> MyOrders in
                if let task = MyOrders(dictionary: document.data(), id: document.documentID) { return task } else {
                    fatalError("Unable to initialize type \(MyOrders.self) with dictionary \(document.data())")
                }
            }
            self?.documents = snapshot.documents
            self?.myOrdersArray.append(contentsOf: result)
            if (self?.myOrdersArray.count)! == 0 {
                self?.tableView.alpha = 0
            } else {
                self?.tableView.alpha = 1
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    fileprivate func baseQuery() -> Query {
        return db.collection("users").document(uid!).collection("myOrders")
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }

}

extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myOrdersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyOrdersTableViewCell
        tableView.rowHeight = UITableView.automaticDimension
        cell.selectionStyle = .none
        cell.dateLabel.text = myOrdersArray[indexPath.row].date
        cell.productLabelDescription.text = myOrdersArray[indexPath.row].products.joined(separator: "\n" )
        cell.sumLabel.text = myOrdersArray[indexPath.row].fullPrice
        
        return cell
    }
}

