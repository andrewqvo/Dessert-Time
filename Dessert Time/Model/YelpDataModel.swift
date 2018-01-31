//
//  YelpDataModel.swift
//  Dessert Time
//
//  Created by Andrew Vo on 1/9/18.
//  Copyright © 2018 Andrew Vo. All rights reserved.
//

import Foundation

class YelpDataModel {

    //Yelp data model variables here
    var name : String = ""
    var rating : Double = 0
    var yelpURL : String = ""
    var categories : [String] = []
    var address : [String] = []
    var phoneNumber : String = ""
    var distance : Double = 0.0
    var photoURL : String = ""
    var price : String = ""
    
    init(name: String, rating: Double, yelpURL: String, categories: [String], address: [String], phoneNumber: String, distance: Double, photoURL: String, price: String) {
        self.name = name
        self.rating = rating
        self.yelpURL = yelpURL
        self.categories = categories
        self.address = address
        self.phoneNumber = phoneNumber
        self.distance = distance
        self.photoURL = photoURL
        self.price = price

//        print(name, rating, yelpURL, categories, address, phoneNumber, distance, photoURL)
    }
    
}
