//
//  SettingsDataModel.swift
//  Dessert Time
//
//  Created by Andrew Vo on 1/9/18.
//  Copyright © 2018 Andrew Vo. All rights reserved.
//

import Foundation

class SettingsDataModel {
    //priceLevel represents the number of dollar signs
    var priceLevel : Int = 1
    //each distance in the array represents a distance option pressed in settings
    var distanceInMetersArray : [Int] = [483, 1609, 8047, 32187]
    var distanceInMeters : Int = 0
    var categoriesDict : [String:[String]] = ["bobaAndSmoothies" : ["bubbletea", "juicebars", "tea"], "cakesAndPastries" : ["cakeshop", "chimneycakes", "churros", "cupcakes", "bakeries"],
                                              "donuts" : ["donuts"], "frozenDesserts" : ["gelato", "icecream", "shavedice", "shavedsnow"], "candy" : ["candy"], "dessert" : ["desserts"]]
    var categories : [String] = []
    
    init() {
        for (_,categoryKeywords) in categoriesDict {
            categories.append(contentsOf: categoryKeywords)
        }
        distanceInMeters = distanceInMetersArray[0]
    }
    
}
