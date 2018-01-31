//
//  RestaurantInfoViewController.swift
//  Dessert Time
//
//  Created by Andrew Vo on 1/9/18.
//  Copyright © 2018 Andrew Vo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RestaurantInfoViewController: UIViewController {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var starRatingImageView: UIImageView!
    @IBOutlet weak var yelpLogoButton: UIButton!
    @IBOutlet weak var dollarSign1Label: UILabel!
    @IBOutlet weak var dollarSign2Label: UILabel!
    @IBOutlet weak var dollarSign3Label: UILabel!
    @IBOutlet weak var dollarSign4Label: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    var yelpDataModel = YelpDataModel(name: "", rating: 0, yelpURL: "", categories: [], address: [], phoneNumber: "", distance: 0.0, photoURL: "", price: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("name:", yelpDataModel.name, "rating:", yelpDataModel.rating, "categories:", yelpDataModel.categories, "address:", yelpDataModel.address, "phoneNumber:", yelpDataModel.phoneNumber, "distance:", yelpDataModel.distance, "photoURL:", yelpDataModel.photoURL, "price:", yelpDataModel.price)
        
        getAndSetRestaurantImage(url: yelpDataModel.photoURL)
        restaurantNameLabel.text = yelpDataModel.name
        let yelpStarImageName = getYelpStarsImageName(rating: yelpDataModel.rating)
        starRatingImageView.image = UIImage(named: yelpStarImageName)
        setPrice(price: yelpDataModel.price)
        setCategories(categories: yelpDataModel.categories)
        setAddress(addressArray: yelpDataModel.address)
        setPhoneNumber(phoneNumber: yelpDataModel.phoneNumber)
    }
    
    func getAndSetRestaurantImage (url: String) {
        let session = URLSession(configuration: .default)
        let restaurantImageURL = URL(string: yelpDataModel.photoURL)!
        let getRestaurantImage = session.dataTask(with: restaurantImageURL) { (data, response, error) in
            if let err = error {
                print("Error occured: \(err)")
            }
            else {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        //we sucessfully got the image
                        print("yay we got the image")
                        let image = UIImage(data: imageData)!
                        DispatchQueue.main.async {
                            self.restaurantImageView.image = image
                        }
                    }
                    else {
                        print("Image is nil.")
                    }
                }
                else {
                    print("No response server.")
                }
            }
        }
        getRestaurantImage.resume()
    }

    func getYelpStarsImageName(rating: Double) -> String{
        switch rating {
        case 0:
            return "regular_0"
        case 1:
            return "regular_1"
        case 1.5:
            return "regular_1_half"
        case 2:
            return "regular_2"
        case 2.5:
            return "regular_2_half"
        case 3:
            return "regular_3"
        case 3.5:
            return "regular_3_half"
        case 4:
            return "regular_4"
        case 4.5:
            return "regular_4_half"
        case 5:
            return "regular_5"
        default:
            return "regular_0"
        }
    }
    
    func setPrice(price: String) {
        switch price {
        case "$":
            dollarSign1Label.textColor = UIColor.darkGray
        case "$$":
            dollarSign1Label.textColor = UIColor.darkGray
            dollarSign2Label.textColor = UIColor.darkGray
        case "$$$":
            dollarSign1Label.textColor = UIColor.darkGray
            dollarSign2Label.textColor = UIColor.darkGray
            dollarSign3Label.textColor = UIColor.darkGray
        case "$$$$":
            dollarSign1Label.textColor = UIColor.darkGray
            dollarSign2Label.textColor = UIColor.darkGray
            dollarSign3Label.textColor = UIColor.darkGray
            dollarSign4Label.textColor = UIColor.darkGray
        default:
            dollarSign1Label.textColor = UIColor.darkGray
        }
    }
    
    func setCategories(categories: [String]) {
        var categoriesString = "Categories: "
        if categories.count == 1 {
            categoriesString += categories[0]
            categoriesLabel.text = categoriesString
        }
        else {
            for i in 0...categories.count-1{
                if i == categories.count-1 {
                    categoriesString += categories[i]
                }
                else {
                    categoriesString += categories[i] + ", "
                }
            }
            categoriesLabel.text = categoriesString
        }
    }

    func setAddress(addressArray: [String]) {
        var addressString = ""
        for addressPart in addressArray {
            addressString += addressPart + " "
        }
        addressButton.setTitle(addressString, for: .normal)
        addressButton.titleLabel?.minimumScaleFactor = 0.5
        addressButton.titleLabel?.numberOfLines = 1
        addressButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func setPhoneNumber(phoneNumber: String) {
        phoneNumberButton.setTitle(phoneNumber, for: .normal)
        phoneNumberButton.titleLabel?.minimumScaleFactor = 0.5
        phoneNumberButton.titleLabel?.numberOfLines = 1
        phoneNumberButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func yelpLogoButtonPressed(_ sender: Any) {
        if let url = URL(string: yelpDataModel.yelpURL) {
            UIApplication.shared.open(url)
        }
        else {
            print("Yelp link cannot be opened")
        }
    }
    
    @IBAction func addressButtonPressed(_ sender: Any) {
        let geoCoder = CLGeocoder()
        var coordinates = CLLocationCoordinate2D()
        //latitude and longitude give coordinates 0.0,0.0
        print((addressButton.titleLabel?.text)!)
//        geoCoder.geocodeAddressString((addressButton.titleLabel?.text)!) { (placemarks, error) in
//            let placemark = placemarks?.first?.location
//            latitude = (placemark?.coordinate.latitude)!
//            longitude = (placemark?.coordinate.longitude)!
//        }
        geoCoder.geocodeAddressString((addressButton.titleLabel?.text)!) { (placemarks, error) in
            let placemark = placemarks?.first?.location
            coordinates = (placemark?.coordinate)!
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
            mapItem.name = self.yelpDataModel.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])

            print(coordinates.latitude, coordinates.longitude)
        }
        //let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
//        mapItem.name = yelpDataModel.name
//        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func phoneNumberButtonPressed(_ sender: Any) {
        var phoneNumber = yelpDataModel.phoneNumber
        phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        let phoneURL = URL(string: "tel://\(phoneNumber)")
        UIApplication.shared.open(phoneURL!)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
