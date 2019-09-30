//
//  DetailCatalogViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/20/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase



class DetailCatalogViewController: UIViewController {
    
    var documents: [DocumentSnapshot] = []
    public var productInit: [Product] = []
    let db = Firestore.firestore()
    var likeImageName: UIImage = UIImage(named: "likeLabel")!
    private var listener: ListenerRegistration!
    @IBOutlet weak var collectionView: UICollectionView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.size.width / 2.1
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 320)
        self.collectionView.backgroundColor = #colorLiteral(red: 0.9451538706, green: 0.9451538706, blue: 0.9451538706, alpha: 1)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
       self.query = baseQuery()
        loadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.query = baseQuery()
        productInit.removeAll(keepingCapacity: true)
    }
    
    func loadData() {
        self.listener = query?.addSnapshotListener { [weak self] (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let result = snapshot.documents.map{ (document) -> Product in
                if let task = Product(dictionary: document.data(), id: document.documentID) { return task } else {
                    fatalError("Unable to initialize type \(Product.self) with dictionary \(document.data())")
                }
            }
            self?.documents = snapshot.documents
            self?.productInit.append(contentsOf: result)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    fileprivate func baseQuery() -> Query {
        return db.collection("catalog").document(catalogID).collection("model")
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
   
    
}

extension DetailCatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productInit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! DetailCatalogCollectionViewCell
        let detailTitle = productInit[indexPath.item]
        productIDArray = productInit.map { (dictionary) -> String in
            return dictionary.id
        }
        cell.detailPriceLabel.text = "\(detailTitle.price) грн."
        cell.detailDescriptionLabel.text = detailTitle.description
        cell.detailCatalogImage.loadImages(urlString: "catalog/\(detailTitle.id).png")
        cell.likeLabel.image = likeImageName
        
        

        if uid != nil {
        db.collection("users").document(uid!).collection("favorites").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let checkLike = self.db.collection("users").document(uid!).collection("favorites").document(document.documentID).documentID
                    if checkLike == productIDArray[indexPath.item] {
                        cell.likeLabel.image = UIImage(named: "redLike")
                        
                    }
                }
            }
        }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = productInit[indexPath.item]
        productID = db.collection("catalog").document(catalogID).collection("model").document(item.id).documentID
    }
    
    
    
}
