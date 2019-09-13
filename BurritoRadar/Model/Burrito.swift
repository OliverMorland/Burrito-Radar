//
//  Burito.swift
//  BurritoRadar
//
//  Created by Oliver Morland on 07/09/2019.
//  Copyright © 2019 Oliver Morland. All rights reserved.
//

import Foundation
import MapKit


class Burrito{
    
    let name : String
    let address : String
    let price : String
    let rating : String
    let location : CLLocation
    
    init(name: String, address: String, price: String, rating: String, location: CLLocation){
        self.name = name
        self.address = address
        self.price = price
        self.rating = rating
        self.location = location
        
    }
    
}
