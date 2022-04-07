//
//  modelPlace.swift
//  Places
//
//  Created by Алексей Моторин on 04.04.2022.
//

import Foundation
import UIKit

struct Places {
    
    var restaurantImage: String?
    var namePlace: String
    var locationPlace: String?
    var typePlace: String?
    var image: UIImage?
    
}

struct MyPlaces {
    
   static var array = [
        Places(restaurantImage: "mak", namePlace: "mak", locationPlace: "Москва", typePlace: "Ресторан", image: nil),
        Places(restaurantImage: "bk", namePlace: "bk", locationPlace: "Москва", typePlace: "Ресторан", image: nil),
        Places(restaurantImage: "kfc", namePlace: "kfc", locationPlace: "Москва", typePlace: "Ресторан", image: nil)
      ]
}


