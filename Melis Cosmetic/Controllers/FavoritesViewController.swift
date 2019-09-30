//
//  FavoritesViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 7/27/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var documents: [DocumentSnapshot] = []
    public var favoritesArray: [Favorites] = []
    let db = Firestore.firestore()
    var likeImageName: UIImage = UIImage(named: "redLike")!
    private var listener: ListenerRegistration!
    var isFavorites: Bool = true

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = #colorLiteral(red: 0.9451538706, green: 0.9451538706, blue: 0.9451538706, alpha: 1)
        let width = view.frame.size.width / 2.1
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 320)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        guard uid != nil else {
            self.collectionView.alpha = 0
            
            return
        }
        self.query = baseQuery()
        loadData()
        self.collectionView.alpha = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard uid != nil else {
            self.collectionView.alpha = 0
            
            return
        }
        self.query = baseQuery()
        favoritesArray.removeAll(keepingCapacity: true)
        self.collectionView.alpha = 1
    }
    
    func loadData() {
        self.listener = query?.addSnapshotListener { [weak self] (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let result = snapshot.documents.map{ (document) -> Favorites in
                if let task = Favorites(dictionary: document.data(), id: document.documentID) { return task } else {
                    fatalError("Unable to initialize type \(Favorites.self) with dictionary \(document.data())")
                }
            }
            self?.documents = snapshot.documents
            self?.favoritesArray.append(contentsOf: result)
            if (self?.favoritesArray.count)! > 0 {
                self?.collectionView.alpha = 1
            } else {
                self?.collectionView.alpha = 0
            }
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    fileprivate func baseQuery() -> Query {

        return Firestore.firestore().collection("users").document(uid!).collection("favorites")
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
    
    
    
    
}
    extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return favoritesArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCollectionViewCell
            let detailTitle = favoritesArray[indexPath.item]
            favoritesIDArray = favoritesArray.map { (dictionary) -> String in
                return dictionary.id
                }
            cell.favoritesCatalogImage.loadImages(urlString: "catalog/\(detailTitle.id).png")
            cell.favoritesPriceLabel.text = "\(detailTitle.price) грн."
            cell.favoritesDescriptionLabel.text = detailTitle.description
            cell.likeImageLabel.image = likeImageName
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            let item = favoritesArray[indexPath.item]
            productID = db.collection("user").document(uid!).collection("favorites").document(item.id).documentID
            catalogID = db.collection("user").document(uid!).collection("favorites").document(item.catalogCompilationID).documentID
            }

        
}
