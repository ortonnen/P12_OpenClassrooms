//
//  RecipeTableView.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 16/03/2021.
//

import UIKit
import AlamofireImage

class RecipesTableViewCell: UITableViewCell {
    
    
    //MARK: - Outlet
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImageView.image = nil
    }
    ///configure cell appearance
    func configure(withTitle title: String, imageUrl: String?, imageData: Data?) {
        if  imageUrl != nil {
            guard let url = URL(string:imageUrl!) else { return }
            recipeImageView.af.setImage(withURL: url)
        } else if imageData != nil {
            recipeImageView.image = UIImage.init(data: imageData!)
        }
        self.titleLabel.text = title
    }
}
