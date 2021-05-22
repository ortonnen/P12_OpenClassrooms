//
//  RoundButton.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 15/03/2021.
//

import UIKit

//MARK: - Round Button
final class RoundButton: UIButton {
    
    //MARK: Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    //MARK: Methods
    ///func to make round buttons
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
