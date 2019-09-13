//
//  TableViewController.swift
//  BurritoRadar
//
//  Created by Oliver Morland on 07/09/2019.
//  Copyright © 2019 Oliver Morland. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import CoreLocation

class TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    //Constants
    let placesURL = "https://maps.googleapis.com/maps/api/place/nearbysearch"
    let apiKey =  "AIzaSyCCFPJUUE8U7ra4VIm0dNiHV4ncYfXsu2Y"

    
    //Declaring instance variables
    var locationManager = CLLocationManager()
    var allBurritos = [Burrito]()
    var selectedBurrito : Burrito!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setting table view delegate
        tableView.delegate = self
    
        //Set up the location manager here
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    //Getting User Location Data here
    //******************************************************************************
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            
            let latitude = String(location.coordinate.latitude)
            let longtitude = String(location.coordinate.longitude)
            let params: [String : String] = ["location": "\(latitude),\(longtitude)", "radius":"1500", "key": apiKey]
            
            getBurritoPlacesData(url: placesURL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    //Getting Data Functions
    //*******************************************************************************
    func getBurritoPlacesData(url: String, parameters: [String : String]){
        
        print(parameters)
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            if response.result.isSuccess{
                print("Success")
                let placesJson : JSON = JSON(response.result.value!)
                print(placesJson)
            }
            else{
                print("Error: \(String(describing: response.result.error))")
                
                //Append Placeholder Burritos
                self.appendBurritos()
                self.tableView.reloadData()
                
            }
        }
    }
    
    
    //Parsing JSON Data
    func updateTableViewWithData(json: JSON){
        if let name = json["name"].string{
            let address = json["address"].stringValue
            let priceLevel = json["price_level"].stringValue
            let rating = json["rating"].stringValue
            let latitude = json["geometry"]["location"]["lat"].floatValue
            let longtitude = json["geometry"]["location"]["lon"].floatValue
            
            //Configuring Price Symbol
            var burritoPriceSymbol = String()
            switch priceLevel{
            case "2":
                burritoPriceSymbol = "$$"
            case "3":
                burritoPriceSymbol = "$$$"
            default:
                burritoPriceSymbol = "$"
            }
            
            //Configuring Burrito and adding to table
            let burrito = Burrito(name: name, address: address, price: burritoPriceSymbol, rating: rating, location: CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longtitude)))
            allBurritos.append(burrito)
            tableView.reloadData()
            
        }
        else{
            print("No data available")
        }
    }
    
    
    //Append placeholder Burritos in case connection fails
    func appendBurritos(){
        let Burrito1 = Burrito(name: "Chipotle", address: "345 W 55 St", price: "$$", rating: "5", location: CLLocation(latitude: 21.282778, longitude: -157.829444))
        allBurritos.append(Burrito1)
        let Burrito2 = Burrito(name: "Best Burrito", address: "200 W 35 St", price: "$$", rating: "5", location: CLLocation(latitude: 21.282778, longitude: -157.829444))
        allBurritos.append(Burrito1)
        let Burrito3 = Burrito(name: "Mexican Deli", address: "345 W 80 St", price: "$", rating: "3", location: CLLocation(latitude: 21.282778, longitude: -157.829444))
        allBurritos = [Burrito1, Burrito2, Burrito3]
    }


    
    //Table View functions
    //********************************************************************************
    
    //Setting number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    //Setting number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allBurritos.count
    }

    
    //Configuring cell at index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.nameLabel.text = allBurritos[indexPath.row].name
        cell.addressLabel.text = allBurritos[indexPath.row].address
        let price = allBurritos[indexPath.row].price
        let rating = allBurritos[indexPath.row].rating
        cell.infoLabel.text = "\(price)  \(rating)⭐️"
        
        return cell
    }
    
    //When row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let MapVC = ViewController(nibName: "MapViewController", bundle: nil)
        selectedBurrito = allBurritos[indexPath.row]
        performSegue(withIdentifier: "segueToMapVC", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var mapVC = segue.destination as! ViewController
        mapVC.selectedBurrito = selectedBurrito
    }
    
    
    //*********************************************************************************
    
    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
