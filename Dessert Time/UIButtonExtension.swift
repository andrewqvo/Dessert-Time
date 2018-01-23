//
//  UIButtonExtension.swift
//  Dessert Time
//
//  Created by Andrew Vo on 1/23/18.
//  Copyright © 2018 Andrew Vo. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = Float(UInt8.max)
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    
    
    
}
