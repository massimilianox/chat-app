//
//  GradientView.swift
//  Smack
//
//  Created by Massimiliano Abeli on 22/07/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    // Able to change the storyboard dynamically
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.1137254902, green: 0.3568627451, blue: 0.7254901961, alpha: 1) {
        didSet {
            self.setNeedsLayout() // this actually call layoutSubviews()
        }
    }
    
    // Able to change the storyboard dynamically
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.4196078431, green: 0.6470588235, blue: 0.7647058824, alpha: 1) {
        didSet {
            self.setNeedsLayout() // this actually call layoutSubviews()
        }
    }
    
    // Update the view
    override func layoutSubviews() {
        
        // Create a gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        
        // Insert gradientlayer into the view
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }

}
