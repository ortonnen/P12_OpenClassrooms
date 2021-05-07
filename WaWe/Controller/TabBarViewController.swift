//
//  TabBarViewController.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 19/04/2021.
//

import UIKit
import RealmSwift

class TabBarViewController:  UITabBarController {
    let realmDataManager = RealmDataManager()
    let realm = try? Realm()
    var recipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK: File Private Methods
    fileprivate func map(){
        guard let dataRecipes = realm?.objects(FavoriteRecipe.self) else {return}
        guard dataRecipes.count > 0 else {
            return}
        for favoriteRecipe in dataRecipes{
            recipes.append(realmDataManager.mapFavoriteRecipeToRecipe(for: favoriteRecipe))
        }
    }
}
extension TabBarViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        recipes.removeAll()
        map()
        if let recipeVC = viewController as? RecipeViewController {
                recipeVC.recipes = recipes
                recipeVC.recipeTableView.reloadData()
            }
    }
}

