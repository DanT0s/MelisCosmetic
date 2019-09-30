//
//  ProductViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/17/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    public var productInit: [Product] = []
    @IBOutlet weak var addedImageLabel: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var favoritesLike: UIImage = UIImage()
    var timer = Timer()
    var isFavorites: Bool = false
    var productPrice: NSNumber?
    var productDescription: String?
    var productQuantity: NSNumber?
    var catalogCompilationID: String?
    
    
    @IBOutlet weak var addedLabelText: UILabel!
    
    @IBAction func favoritesProduct(sender: UIButton) {
        guard uid != nil else {
            let alert = UIAlertController(title: nil, message: "Добавлять товары в избранное могут только зарегистрированные пользователи", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return }
        if isFavorites == false {
            isFavorites = true
            addToFavorites()
            favoritesLike = UIImage(named: "redLike")!
        } else {
            isFavorites = false
            removeItemFavorites()
            favoritesLike = UIImage(named: "likeLabel")!
        }
            self.tableView.reloadData()
    }
    
    func likeImageCheck() {
        if isFavorites == false {
            favoritesLike = UIImage(named: "likeLabel")!
        } else {
            favoritesLike = UIImage(named: "redLike")!
        }
    }
    
    @IBAction func addToCartButton(_ sender: UIButton) {
        if uid != nil {
            self.addToCart()
            animatedAddedImageEnable()
            reloadBasketView()
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(animatedAddedImageDisable), userInfo: nil, repeats: false)
        } else {
            self.logPlease()
        }
    }
    
    func reloadBasketView() {
        let basketController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "basketController") as! BasketViewController
        let basketNavigationController = UINavigationController(rootViewController: basketController)
        basketNavigationController.viewWillAppear(true)
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        shareButtonPressed()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addedLabelText.transform = CGAffineTransform(scaleX: 0, y: 0)
        addedImageLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        loadData()
        tableView.tableFooterView = UIView(frame: .zero)
        likeImageCheck()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard uid != nil else { return }
        checkLike()
    }
    
    func animatedAddedImageEnable() {
        UIView.animate(withDuration: 0.5) {
            self.addedLabelText.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.addedImageLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @objc func animatedAddedImageDisable() {
        UIView.animate(withDuration: 0.2) {
            self.addedLabelText.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.addedImageLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInit.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellImage") as! ImageProductTableViewCell
            tableView.rowHeight = 340
            cell.selectionStyle = .none
            let detailTitle = productInit[indexPath.row]
            productPrice = detailTitle.price as NSNumber
            productDescription = detailTitle.description
            cell.productPrice.text = "\(detailTitle.price) грн."
            cell.productDescription.text = detailTitle.description
            cell.productBrandLabel.text = detailTitle.brand
            
           
            cell.productImage.loadImages(urlString: "catalog/\(productID).png")
            
            catalogCompilationID = detailTitle.catalogCompilationID
            
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellQuantity") as! QuantityProductTableViewCell
            tableView.rowHeight = 75
            cell.selectionStyle = .none
            
            productQuantity = NSNumber(value: Int(cell.productNumberQuantityLabel.text!)!)
            
            cell.stepper.addTarget(self, action: #selector(reloadData(_:)), for: .touchUpInside)
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellAdd") as! AddProductTableViewCell
            tableView.rowHeight = 80
            cell.addToCartLabel.layer.cornerRadius = 15
            cell.selectionStyle = .none
            
           cell.imageLikeFavorite.image = favoritesLike
            
            return cell
            
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellDescription") as! DescriptionProductTableViewCell
            tableView.estimatedRowHeight = 40
            tableView.rowHeight = UITableView.automaticDimension
            let detailTitle = productInit[indexPath.row]
            cell.productDescriptionLabel.text = detailTitle.productDescription
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func checkLike() {
        db.collection("users").document(uid!).collection("favorites").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let checkLike = self.db.collection("users").document(uid!).collection("favorites").document(document.documentID).documentID
                    if checkLike == productID {
                        self.isFavorites = true
                        self.favoritesLike = UIImage(named: "redLike")!
                        
                    }
                }
            }
        }
    }
    @objc func reloadData(_ sender: Any?) {
        self.tableView.reloadData()
    }
    
    func shareButtonPressed() {

        let activityVC = UIActivityViewController(activityItems: [ productDescription!,], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsSelection = false
        
    }
    
    
    func loadData() {
        db.collection("catalog").document(catalogID).collection("model").document(productID).getDocument { [weak self] (document, error) in if error != nil {
            print("Document does not exist")
        } else {
            let task = document.flatMap({$0.data().flatMap({ (data) in
                return Product(dictionary: data, id: document!.documentID)})})
            self?.productInit.append(task!)
            
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func addToCart() {
        
        
        let productData = [
            "description": productDescription!,
            "price": productPrice!,
            "quantity": productQuantity!,
            "imageName": productID
            ] as [String : Any]
        
        db.collection("users").document(uid!).collection("productAddToCart").document(productID).setData(productData, merge: true, completion: { [weak self] (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            print("Successfully set add newest product")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    func addToFavorites() {
        
        let productData = [
            "description": productDescription!,
            "price": productPrice!,
            "catalogCompilationID": catalogCompilationID!,
            "imageName": productID
            ] as [String : Any]
        
        
        db.collection("users").document(uid!).collection("favorites").document(productID).setData(productData, merge: true, completion: { [weak self] (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            print("Successfully set add newest product")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    func removeItemFavorites() {
        db.collection("users").document(uid!).collection("favorites").document(productID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
    
            }
        }
    }
    

    func logPlease() {
        let acLog = UIAlertController(title: "You are not logged in", message: "Login or register please", preferredStyle: .alert)
        acLog.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(acLog, animated: true, completion: nil)
    }
    

}
