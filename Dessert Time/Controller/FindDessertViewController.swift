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
    var userAuthorizationStatus : CLAuthorizationStatus!
    var settingsDataModel = SettingsDataModel()
    var yelpDataModel = YelpDataModel(name: "", rating: 0, yelpURL: "", categories: [], address: [], phoneNumber: "", distance: 0.0, photoURL: "", price: "$")
    
    
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
            var categoriesString = ""
            for category in settingsDataModel.categories {
                categoriesString += category + ","
            }
            //print(categoriesString.dropLast())
            let params : [String : Any] = ["latitude" : String(currentLocation.coordinate.latitude), "longitude" : String(currentLocation.coordinate.longitude), "price" : self.settingsDataModel.priceLevel, "radius" : self.settingsDataModel.distanceInMeters, "categories" : categoriesString.dropLast()]

            print(params)
            getRestaurantData(url: yelpURL, parameters: params, headers: headers)
        
            //performSegue(withIdentifier: "goToRestaurantInfo", sender: self)
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
    func getRestaurantData(url: String, parameters: [String:Any], headers: HTTPHeaders) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                print("we made a sucessful request (yelp data could still be an error)")
                let yelpJSON : JSON = JSON(response.result.value!)
                self.updateRestaurantData(json: yelpJSON)
                //print(yelpJSON)
            }
            else {
                print("error, we did not get sucessfully make a request")
            }
        }
    }
    
    //MARK: - JSON Parsing
    func updateRestaurantData(json: JSON) {
        let businessesArray = json["businesses"]
        var dataModelArgumentsDict = businessesArrayToYelpDataModelArgument(businessesArray: businessesArray)
        self.yelpDataModel = YelpDataModel(name: dataModelArgumentsDict["name"] as! String, rating: dataModelArgumentsDict["rating"] as! Double, yelpURL: dataModelArgumentsDict["yelpURL"] as! String, categories: dataModelArgumentsDict["categories"] as! [String], address: dataModelArgumentsDict["address"] as! [String], phoneNumber: dataModelArgumentsDict["phoneNumber"] as! String, distance: dataModelArgumentsDict["distance"] as! Double, photoURL: dataModelArgumentsDict["photoURL"] as! String, price: dataModelArgumentsDict["price"] as! String)
        performSegue(withIdentifier: "goToRestaurantInfo", sender: self)
    }
    
    func businessesArrayToYelpDataModelArgument(businessesArray : JSON) -> [String:Any]{
        if let restaurantsList = businessesArray.array, businessesArray.exists() && businessesArray.count != 0 {
            let restaurantNumber = Int(arc4random_uniform(UInt32(restaurantsList.count)))
            print(restaurantNumber)
            let restaurantDict = restaurantsList[restaurantNumber]
            
            let name = restaurantDict["name"].stringValue
            let rating = restaurantDict["rating"].doubleValue
            let yelpURL = restaurantDict["url"].stringValue
            let unparsedCategories = restaurantDict["categories"].arrayValue
            var parsedCategories : [String] = []
            for item in unparsedCategories {
                parsedCategories.append(item["title"].stringValue)
            }
            let unparsedAddress = restaurantDict["location"]["display_address"].arrayValue
            var parsedAddress : [String] = []
            for addressLine in unparsedAddress {
                parsedAddress.append(addressLine.stringValue)
            }
            let phoneNumber = restaurantDict["display_phone"].stringValue
            let distance = restaurantDict["distance"].doubleValue
            let photoURL = restaurantDict["image_url"].stringValue
            let price = restaurantDict["price"].stringValue
            //print(name,rating,yelpURL,parsedCategories,parsedAddress,phoneNumber,distance)
            return ["name" : name, "rating" : rating, "yelpURL" : yelpURL, "categories" : parsedCategories, "address" : parsedAddress, "phoneNumber" : phoneNumber, "distance" : distance, "photoURL" : photoURL, "price" : price]
        }
        else {
            print("no restaurants found or we messed up :(")
        }
        return ["name" : "", "rating" : "", "yelpURL" : "", "categories" : "", "address" : "", "phoneNumber" : "", "distance" : "", "photoURL" : "", "price" : ""]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "goToRestaurantInfo" {
            let nextVC : RestaurantInfoViewController = segue.destination as! RestaurantInfoViewController
            nextVC.yelpDataModel = self.yelpDataModel
        }
    }
}
