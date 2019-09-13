//
//  ViewController.swift
//  BurritoRadar
//
//  Created by Oliver Morland on 07/09/2019.
//  Copyright © 2019 Oliver Morland. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    //IB Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    //Instance Variables
    var selectedBurrito : Burrito!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Adding marker tp map
        guard let location = selectedBurrito?.location else { return}
        let annotation = Artwork(name: "Place", address: "MyStreet", coordinate: (selectedBurrito?.location.coordinate)!)
        annotation.markerTintColor = .purple
        mapView.addAnnotation(annotation)
        
        //Centering map view
        centerMapOnLocation(location: location)
        
        //Configuring Label
        let address = selectedBurrito.address
        let price = selectedBurrito.price
        let rating = selectedBurrito.rating
        addressLabel.text = "\(address)\n\(price) \(rating)"
    }
    
    
    
    //Centering map funciton
    let regionRadius : CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }


}



extension ViewController : MKMapViewDelegate{
    
    //Configuring Map View
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     
        guard let annotation = annotation as? Artwork else{return nil}
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeuedView.annotation = annotation
            view = dequeuedView as! MKMarkerAnnotationView
         }
        else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.backgroundColor = .purple
         }
     
     return view
     
     }
    

}
