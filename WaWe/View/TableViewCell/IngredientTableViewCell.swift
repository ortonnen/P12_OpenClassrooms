//
//  CreateRecipeTableViewCell.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 08/04/2021.
//

import UIKit
//MARK: - Create Recipe TableViewCell
final class IngredientTableViewCell: UITableViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    //MARK: - Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: - Methods
    ///configure cell appearance
    func configure(withTitle ingredient: String, quantity: String, unit: String) {
        ingredientLabel.text = ingredient
        quantityLabel.text = quantity
        unitLabel.text = unit
    }
}
