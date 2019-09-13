//
//  Artwork.swift
//  BurritoRadar
//
//  Created by Oliver Morland on 07/09/2019.
//  Copyright © 2019 Oliver Morland. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation{
    
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D){
        self.name = name
        self.address = address
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String?{
        return name
    }
    
    var markerTintColor : UIColor = .purple
    
    func mapItem() -> MKMapItem{
        let addressDict = [CNPostalAddressCityKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        return mapItem
    }
    
}


