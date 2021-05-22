//
//  FilterTableViewCell.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 26/03/2021.
//

import UIKit
//MARK: Enum Filter
enum Filter {
    case cuisine, intolerance, diet
}

//MARK: Filter Table View Cell
final class FilterTableViewCell: UITableViewCell {

    //MARK: Outlet
    @IBOutlet weak var cuisineTitle: UILabel!
    @IBOutlet weak var intoleranceTitle: UILabel!
    @IBOutlet weak var dietTitle: UILabel!
    
    @IBOutlet weak var cuisineActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var intoleranceActivityIndiactor: UIActivityIndicatorView!
    @IBOutlet weak var dietActivityIndiactor: UIActivityIndicatorView!
   
    //MARK: Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.textLabel?.textColor = #colorLiteral(red: 0.9633114934, green: 0.9485848546, blue: 0.8967990279, alpha: 1)
            self.backgroundColor = #colorLiteral(red: 0.643104732, green: 0.2448115349, blue: 0.1737442911, alpha: 1)
        } else {
            self.textLabel?.textColor = #colorLiteral(red: 0.643104732, green: 0.2448115349, blue: 0.1737442911, alpha: 1)
            self.backgroundColor = #colorLiteral(red: 0.9633114934, green: 0.9485848546, blue: 0.8967990279, alpha: 1)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.textColor = #colorLiteral(red: 0.643104732, green: 0.2448115349, blue: 0.1737442911, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0.9633114934, green: 0.9485848546, blue: 0.8967990279, alpha: 1)
    }
    
    //MARK: Methods
    ///configure cell appearance
    func configure(withTitle title: String, for cell : Filter){
        if cell == .cuisine {
            activityIndiactorIsHidden(for: .cuisine, with: title)
        }
        if cell == .intolerance {
            activityIndiactorIsHidden(for: .intolerance, with: title)
        }
        if cell == .diet {
            activityIndiactorIsHidden(for: .diet, with: title)
        }
    }
    
    ///method to activity indicator appear
   func titleIsHidden(for tableCell: Filter) {
        switch tableCell {
        case .cuisine:
            cuisineActivityIndicator.startAnimating()
            cuisineActivityIndicator.isHidden = false
            cuisineTitle.isHidden = true
        case .intolerance:
            intoleranceActivityIndiactor.startAnimating()
            intoleranceActivityIndiactor.isHidden = false
            intoleranceTitle.isHidden = true
        case .diet:
            dietActivityIndiactor.startAnimating()
            dietActivityIndiactor.isHidden = false
           dietTitle.isHidden = true
        }
    }
    
    //MARK: File Private Methods
    ///methode to show title of cell
    fileprivate func activityIndiactorIsHidden(for tableCell: Filter, with title: String){
        switch tableCell {
        case .cuisine:
            cuisineTitle.text = title
            cuisineActivityIndicator.isHidden = true
            cuisineActivityIndicator.stopAnimating()
            cuisineTitle.isHidden = false
        case .intolerance:
            intoleranceTitle.text = title
            intoleranceActivityIndiactor.isHidden = true
            intoleranceActivityIndiactor.stopAnimating()
            intoleranceTitle.isHidden = false
        case .diet:
            dietTitle.text = title
            dietActivityIndiactor.isHidden = true
            dietActivityIndiactor.stopAnimating()
            dietTitle.isHidden = false
        }
    }
}
