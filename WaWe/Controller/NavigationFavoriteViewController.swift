//
//  NavigationFavoriteViewController.swift
//  WaWe
//
//  Created by Nathalie Simonnet on 11/05/2021.
//

import UIKit
import RealmSwift

class NavigationFavoriteViewController: UINavigationController {
    let realmDataManager = RealmDataManager()
    let realm = try? Realm()
    var recipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadFavoriteRecipe()
        if let recipeVC = self.topViewController as? RecipeViewController {
            recipeVC.recipes = recipes
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadFavoriteRecipe()
        if let recipeVC = self.topViewController as? RecipeViewController {
            recipeVC.recipes = recipes
        }

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

    fileprivate func reloadFavoriteRecipe() {
        recipes.removeAll()
        map()
    }
}

