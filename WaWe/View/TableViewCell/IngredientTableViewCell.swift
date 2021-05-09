//
//  CreateRecipeTableViewCell.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 08/04/2021.
//

import UIKit
//MARK: - Create Recipe TableViewCell
class IngredientTableViewCell: UITableViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    ///configure cell appearance
    func configure(withTitle ingredient: String, quantity: String, unit: String) {
        ingredientLabel.text = ingredient
        quantityLabel.text = quantity
        unitLabel.text = unit
    }
}
