//
//  RestaurantInfoViewController.swift
//  Dessert Time
//
//  Created by Andrew Vo on 1/9/18.
//  Copyright © 2018 Andrew Vo. All rights reserved.
//

import UIKit

class RestaurantInfoViewController: UIViewController {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var starRatingImageView: UIImageView!
    @IBOutlet weak var yelpLogoButton: UIButton!
    @IBOutlet weak var dollarSign1Label: UILabel!
    @IBOutlet weak var dollarSign2Label: UILabel!
    @IBOutlet weak var dollarSign3Label: UILabel!
    @IBOutlet weak var dollarSign4Label: UILabel!
    @IBOutlet weak var openUntilLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    var yelpDataModel = YelpDataModel(name: "", rating: 0, yelpURL: "", categories: [], address: [], phoneNumber: "", distance: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yelpLogoButtonPressed(_ sender: Any) {
        print(yelpDataModel.name)
    }
    
    @IBAction func addressButtonPressed(_ sender: Any) {
    }
    @IBAction func phoneNumberButtonPressed(_ sender: Any) {
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
