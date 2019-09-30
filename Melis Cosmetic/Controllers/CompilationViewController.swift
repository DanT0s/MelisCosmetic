//
//  ViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/10/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

class CompilationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoImageView: UIImageView!
    let db = Firestore.firestore()
    private var listener: ListenerRegistration!
    var compilationArray: [Compilation] = []
    var documents: [DocumentSnapshot] = []

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compilationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CompilationTableViewCell
        
        tableView.rowHeight = 475
        cell.compilationImageView.loadImages(urlString: "compilation/\(compilationArray[indexPath.row].id).png")
        cell.firstTextLabel.text = compilationArray[indexPath.row].description
        cell.secondTextLabel.text = compilationArray[indexPath.row].secondDescription
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = compilationArray[indexPath.row]
        productID = db.collection("compilation").document(item.id).documentID
        catalogID = db.collection("compilation").document(item.catalogCompilationID).documentID
        print(productID)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.query = baseQuery()
        tableView.tableFooterView = UIView(frame: .zero)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        compilationArray.removeAll(keepingCapacity: true)
        self.query = baseQuery()
        
    }

    @objc func languageSelection() {
        
    }
    
    func loadData() {
        self.listener = query?.addSnapshotListener { [weak self] (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let result = snapshot.documents.map { (document) -> Compilation in
                if let task = Compilation(dictionary: document.data(), id: document.documentID) { return task } else {
                    fatalError("Unable to initialize type \(Compilation.self) with dictionary \(document.data())")
                }
            }
            self?.documents = snapshot.documents
            self?.compilationArray.append(contentsOf: result)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    fileprivate func baseQuery() -> Query {
        return db.collection("compilation")
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }

}


