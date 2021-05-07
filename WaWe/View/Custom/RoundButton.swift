//
//  RoundButton.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 15/03/2021.
//

import UIKit


class RoundButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    ///func to round buttons
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
