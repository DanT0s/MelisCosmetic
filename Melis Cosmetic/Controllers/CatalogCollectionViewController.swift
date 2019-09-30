//
//  CatalogCollectionViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 8/25/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase


class CatalogCollectionViewController: UIViewController {

 
    var documents: [DocumentSnapshot] = []
    public var catalogNames: [Catalog] = []
    private var listener: ListenerRegistration!
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.size.width * 0.9
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 90)
        self.collectionView.backgroundColor = #colorLiteral(red: 0.9451538706, green: 0.9451538706, blue: 0.9451538706, alpha: 1)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.query = baseQuery()
        loadData()
        
    }
    
    
    func loadData() {
        self.listener = query?.addSnapshotListener { [weak self] (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let result = snapshot.documents.map{ (document) -> Catalog in
                if let task = Catalog(dictionary: document.data(), id: document.documentID) {
                    return task
                } else {
                    fatalError("Unable to initialize type \(Catalog.self) with dictionary \(document.data())")
                }
            }
            self?.documents = snapshot.documents
            self?.catalogNames.append(contentsOf: result)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("catalog")
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.query = baseQuery()
        catalogNames.removeAll(keepingCapacity: true)
    }
    
    
    
}

extension CatalogCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalogNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CatalogCollectionViewCell
        
        cell.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let catalogNameTitle = catalogNames[indexPath.item].catalogName
        cell.catalogNameLabel.text = catalogNameTitle
        cell.catalogImage.loadImages(urlString: "nameCatalogImages/\(catalogNameTitle).png")
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = catalogNames[indexPath.item]
        catalogID = Firestore.firestore().collection("catalog").document(item.id).documentID
        
}

}
