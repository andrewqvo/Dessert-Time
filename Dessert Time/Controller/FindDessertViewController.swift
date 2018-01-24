//
//  ViewController.swift
//  Dessert Time
//
//  Created by Andrew Vo on 1/2/18.
//  Copyright © 2018 Andrew Vo. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class FindDessertViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var findDessertButton: UIButton!
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    let headers: HTTPHeaders = ["Authorization": "Bearer XEvRfinkWqs-awcPcDvYm6dq585nq3AkPzrxTZE3SNZsuRnm5eIRf8s7DZXw7IMdg1XzgvoO644IuAo0HVzXt8zDf99gNwLT5HQVBjwmCM4PPX2xpuzxJc1zZElLWnYx"]
    let yelpURL = "https://api.yelp.com/v3/businesses/search?"
    var currentRestaurantNumber = 0
    var userAuthorizationStatus : CLAuthorizationStatus!
        
    @IBOutlet weak var dessertTimeLogo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        makeButtonCircular(button: findDessertButton)
        //print("hello, view did load called")
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        userAuthorizationStatus = status
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findDessertButtonPressed(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            
            case .notDetermined, .restricted, .denied:
                print("No access") //put message saying you need to allow access to location
            
            case .authorizedAlways, .authorizedWhenInUse:
                currentLocation = nil
                locationManager.startUpdatingLocation()
                sender.pulsate()
            }
        }
        else {
            print("Location services are not enabled") //put message telling them you need to enable location services
        }


    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location = locations[locations.count - 1]
        let location = locations[0]
        if currentLocation == nil {
            currentLocation = location
            locationManager.stopUpdatingLocation()
            //print("We found a location!")
            //print("latitude is " + String(currentLocation.coordinate.latitude), "longitude is " + String(currentLocation.coordinate.longitude))
            //dessertTimeLogo.text = "lati " + String(currentLocation.coordinate.latitude) + "long " + String(currentLocation.coordinate.longitude)
            //dessertTimeLogo.font = UIFont(name: dessertTimeLogo.font.fontName, size: 10)
//            if currentLocation == nil {
//                print("current location it is nil right now")
//            }
            let params : [String : String] = ["latitude" : String(currentLocation.coordinate.latitude), "longitude" : String(currentLocation.coordinate.longitude), "categories" : "cakeshop"]
            //let params : [String : String] = ["categories" : "candy"]
            getRestaurantData(url: yelpURL, parameters: params, headers: headers)
            performSegue(withIdentifier: "goToRestaurantInfo", sender: self)
            //print(locations)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func makeButtonCircular(button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = findDessertButton.bounds.size.width / 2.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: - Networking
    func getRestaurantData(url: String, parameters: [String:String], headers: HTTPHeaders) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                print("we made a sucessful request (yelp data could still be an error)")
                let yelpJSON : JSON = JSON(response.result.value!)
                self.updateRestaurantData(json: yelpJSON)
                print(yelpJSON)
            }
            else {
                print("error, we did not get sucessfully make a request")
            }
        }
    }
    
    //MARK: - JSON Parsing
    func updateRestaurantData(json: JSON) {
//        if let restaurantsList = json["businesses"].array {
//            if json["businesses"].exists() {
//                print(restaurantsList)
//            }
//        }
        //it is possible to get a yelp JSON response that has the businesses field with no businesses in it, possibly change it later to different error messages
        if let restaurantsList = json["businesses"].array, json["businesses"].exists() && json["businesses"].count != 0 {
            print(restaurantsList)
        }
        else {
            print("no restaurants found or we messed up :(")
        }
    }
}

