//
//  Extensions.swift
//  Melis Cosmetic
//
//  Created by macbook on 7/27/19.
//  Copyright © 2019 Malcev. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    
    func loadImages(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) {
            self.image = cacheImage as? UIImage
            return
        }
        let storeRef = Storage.storage().reference().child(urlString)
        storeRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    
                    if let downloadImage = UIImage(data: data) {
                        imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                        
                        
                        self?.image = downloadImage
                    }
                    
                    
                    
                }
            }
        }
    }
}
