//
//  ViewController.swift
//  Dessert Time
//
//  Created by Andrew Vo on 1/2/18.
//  Copyright © 2018 Andrew Vo. All rights reserved.
//

import UIKit


class FindDessertViewController: UIViewController {
    
    @IBOutlet weak var findDessertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        makeButtonCircular(button: findDessertButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findDessertButtonPressed(_ sender: UIButton) {
        sender.pulsate()
        performSegue(withIdentifier: "goToRestaurantInfo", sender: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    
    func makeButtonCircular(button : UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = findDessertButton.bounds.size.width / 2.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }
    //MARK: - Networking
    
    //MARK: - JSON Parsing
    
    //MARK: - UI Updates
}

