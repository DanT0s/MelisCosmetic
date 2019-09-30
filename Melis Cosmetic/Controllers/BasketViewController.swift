//
//  BasketViewController.swift
//  Melis Cosmetic
//
//  Created by macbook on 6/10/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

class BasketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var orderTextLabel: UILabel!
    @IBOutlet weak var orderImageLabel: UIImageView!
    @IBOutlet weak var basketImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var myView: UIView!
    var refresher: UIRefreshControl! = UIRefreshControl()
    var toolBarOk = UIToolbar()
    var toolBarCancel = UIToolbar()
    var timer = Timer()
    var picker = UIPickerView()
    var newQuantity = [String:Any]()
    let db = Firestore.firestore()
    var quantityPicker: Array<Int> = []
    private var listener: ListenerRegistration!
    var productCartArray: [ProductCart] = []
    var documents: [DocumentSnapshot] = []
    var sumQuantity = [Float]()
    var sumPrice = [Float]()
    var multiplicationSum = [Float]()
    var multiplicationSumTotal = Float()
    var productsID = [String]()
    var productsAndQuantity = [String]()
    var descriptionAndQuantity = [String]()
    var item = String()
    var myIndexPath = IndexPath()
    var productDescription = [String]()
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return productCartArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "СheckoutCell") as! CheckoutBasketTableViewCell
            cell.selectionStyle = .none
            
            cell.checkoutButtonLabel.addTarget(self, action: #selector(addInMyOrder(_:)), for: .touchUpInside)
            cell.checkoutButtonLabel.addTarget(self, action: #selector(checkout(_:)), for: .touchUpInside)
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductBasketTableViewCell
            cell.selectionStyle = .none
            let productAddItem = productCartArray[indexPath.row]
            cell.totalAmountLabel.text = "\(productAddItem.quantity) шт."
            cell.priceLabel.text = ("\(Float(truncating: productAddItem.price) * Float(truncating: productAddItem.quantity)) грн.")
            cell.descriptionLabel.text = productAddItem.description
            cell.productImageView.loadImages(urlString: "catalog/\(productAddItem.imageName).png")
            
            productDescription = productCartArray.map { (dictionary) -> String in
                return dictionary.description
            }
            
            sumQuantity = productCartArray.map { (dictionary) -> NSNumber in
                return dictionary.quantity
                } as! [Float]
            
            sumPrice = productCartArray.map { (dictionary) -> NSNumber in
                return dictionary.price
                } as! [Float]
            
            productsID = productCartArray.map { (dictionary) -> String in
                return dictionary.imageName
            }
            
            productsAndQuantity = zip(productsID, sumQuantity).map { "\($0): " + " \(Int($1)) шт." }
            descriptionAndQuantity = zip(productDescription, sumQuantity).map { "\($0) - \(Int($1)) шт." }
            cell.productManagerLabel.tag = indexPath.row
            
            cell.productManagerLabel.addTarget(self, action: #selector(alertManager), for: .touchUpInside)
            
            cell.productManagerLabel.addTarget(self, action: #selector(tupButton), for: .touchUpInside)
            
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SumCell") as! SumBasketTableViewCell
            cell.selectionStyle = .none
            
            let sumProductQuantity = sumQuantity.sum()
            cell.totalAmountLabel.text = "\(Int(sumProductQuantity)) шт."
            
            multiplicationSum = zip(sumQuantity, sumPrice).map { $0 * $1 }
            multiplicationSumTotal = multiplicationSum.sum()
            cell.totalLabel.text = "\(multiplicationSumTotal) грн."
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.allowsSelection = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderTextLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        orderImageLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        
         
        for i in 1...999 {
            quantityPicker.append(i)
        }
        checkAlphaCount()
        tableView.tableFooterView = UIView(frame: .zero)
        refresher.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.addSubview(refresher)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(uid as Any)
            guard uid != nil else {
            self.tableView.alpha = 0
            navigationController?.tabBarItem.badgeValue = nil
            return
        }
            self.query = baseQuery()
            loadData()
            updateNotificationCount()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard uid != nil else {
            self.tableView.alpha = 0
            navigationController?.tabBarItem.badgeValue = nil
            return }
        productCartArray.removeAll(keepingCapacity: true)
        self.query = baseQuery()
        
    }
    
    
    func animatedOrderImageEnable() {
        UIView.animate(withDuration: 0.5) {
            self.orderImageLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.orderTextLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @objc func animatedOrderImageDisable() {
        UIView.animate(withDuration: 0.2) {
            self.orderImageLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.orderTextLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        productCartArray.removeAll(keepingCapacity: true)
        self.tableView.alpha = 0
        
        Firestore.firestore().collection("users").document(uid!).collection("productAddToCart").getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                print("Document successfully removed!")
                self.reloadData()
            }
        })
    }
    
    @objc func reloadData() {
        
        viewWillDisappear(true)
        viewWillAppear(true)
        
        refresher.endRefreshing()
    }
    
    func checkAlphaCount() {
        if productCartArray.count == 0 {
            self.tableView.alpha = 0
        } else {
            self.tableView.alpha = 1
        }
    }
    
    func updateNotificationCount() {
        if self.productCartArray.count == 0 {
            navigationController?.tabBarItem.badgeValue = nil
        } else {
            navigationController?.tabBarItem.badgeValue = "\(self.productCartArray.count)"
        }
    }
    
    func getCellForView(view: UIView) -> UITableViewCell? {
        var superView = view.superview
        while superView != nil {
            if superView is UITableViewCell {
                return superView as? UITableViewCell
            } else {
                superView = superView?.superview
            }
        }
        return nil
    }
    
    @objc func tupButton(_ sender: UIButton) {
        guard let cell = getCellForView(view: sender) else { return }
        myIndexPath = tableView.indexPath(for: cell)!
        item = productCartArray[(myIndexPath.row)].id
    }
    
    @objc func alertManager() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Изменить количество", style: .default) { [weak self] (action) in
            
            
            self?.picker.backgroundColor = UIColor.white
            self?.picker.autoresizingMask = .flexibleWidth
            self?.picker.contentMode = .center
            self?.picker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self?.picker.delegate = self
            self?.picker.dataSource = self
            
            self?.view.addSubview(self!.picker)
            
            
            self?.toolBarOk = UIToolbar(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 45))
            self?.toolBarOk.barStyle = .blackOpaque
            self?.toolBarOk.items = [UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(self!.onOKButtonTapped))]
            self?.view.addSubview(self!.toolBarOk)
            
            self?.toolBarCancel = UIToolbar(frame: CGRect(x: UIScreen.main.bounds.size.width - 95, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 45))
            self?.toolBarCancel.barStyle = .blackOpaque
            self?.toolBarCancel.items = [UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(self!.pickerCancelButtonTapped))]
            self?.view.addSubview(self!.toolBarCancel)
            
            
        })
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] (action) in
                    
            self?.productCartArray.remove(at: (self?.myIndexPath.row)!)
                    
            self?.tableView.deleteRows(at: [self!.myIndexPath], with: .left)


            Firestore.firestore().collection("users").document(uid!).collection("productAddToCart").document(self!.item).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                            self?.reloadData()
                        }
                    }
                }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
   
   @objc func onOKButtonTapped() {
    
    
    db.collection("users").document(uid!).collection("productAddToCart").document(item).setData(newQuantity, merge: true, completion: { (error) in
        if let error = error {
            print(error.localizedDescription)
        }
        print("Successfully set add new quantity")
        
    })
    
        toolBarOk.removeFromSuperview()
        toolBarCancel.removeFromSuperview()
        picker.removeFromSuperview()
        self.reloadData()
    }
    
    @objc func pickerCancelButtonTapped() {
        toolBarOk.removeFromSuperview()
        toolBarCancel.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func loadData() {
        self.listener = query?.addSnapshotListener { [weak self] (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let result = snapshot.documents.map { (document) -> ProductCart in
                if let task = ProductCart(dictionary: document.data(), id: document.documentID) { return task } else {
                    fatalError("Unable to initialize type \(ProductCart.self) with dictionary \(document.data())")
                }
            }
            self?.documents = snapshot.documents
            self?.productCartArray.append(contentsOf: result)
            if (self?.productCartArray.count)! > 0 {
                self?.tableView.alpha = 1
                self?.navigationController?.tabBarItem.badgeValue = "\(self!.productCartArray.count)"
            } else {
                self?.tableView.alpha = 0
                self?.navigationController?.tabBarItem.badgeValue = nil
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    fileprivate func baseQuery() -> Query {

        return Firestore.firestore().collection("users").document(uid!).collection("productAddToCart")
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        let item = productCartArray.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        

        Firestore.firestore().collection("users").document(uid!).collection("productAddToCart").document(item.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.reloadData()
                
            }
        }
    }
    
    @objc func checkout(_ sender: Any?) {
        let date = Date()
        let dateFormatterGet = DateFormatter()
        
        dateFormatterGet.dateFormat = "d/MM/yyyy HH:mm"
        
        let resultDate = dateFormatterGet.string(from: date)
        
        
        let orderData = [
            "user": uid!,
            "products": productsAndQuantity,
            "fullPrice": "\(multiplicationSumTotal) грн.",
            "date": resultDate
            ] as [String : Any]
        
        db.collection("orders").document("order#\(arc4random())").setData(orderData, merge: true, completion: { [weak self] (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            print("Successfully set add newest order")
            self?.animatedOrderImageEnable()
            self?.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self!, selector: #selector(self?.animatedOrderImageDisable), userInfo: nil, repeats: false)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
        
    }
    
    @objc func addInMyOrder(_ sender: Any?) {
        let date = Date()
        let dateFormatterGet = DateFormatter()
        
        dateFormatterGet.dateFormat = "d/MM/yyyy HH:mm"
        
        let resultDate = dateFormatterGet.string(from: date)
        
        
        let orderData = [
            "products": descriptionAndQuantity,
            "fullPrice": "\(multiplicationSumTotal) грн.",
            "date": resultDate
            ] as [String : Any]
        
        db.collection("users").document(uid!).collection("myOrders").document("order#\(arc4random())").setData(orderData, merge: true, completion: { [weak self] (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            print("Successfully set add myOrder")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
        
    }
    
}

extension BasketViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quantityPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(quantityPicker[row])"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newQuantity = [
            "quantity": quantityPicker[row]
            ] as [String : NSNumber]
       
    }
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}

