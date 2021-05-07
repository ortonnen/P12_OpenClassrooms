//
//  RecipeViewController.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 15/03/2021.
//

import UIKit
import RealmSwift

//MARK: - Recipe View Controller
class RecipeViewController: UIViewController {
    //MARK: Properties
    var recipes = [Recipe]()
    let realmDataManager = RealmDataManager()
    let realm = try? Realm()
    
    //MARK: Outlet
    @IBOutlet weak var recipeTableView: UITableView!
    
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.rowHeight = 140
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateRecipeArray()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        recipeTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let instructionVC = segue.destination as? InstructionsViewController {
//            guard let indexPath = recipeTableView.indexPathForSelectedRow else {return}
//            instructionVC.recipe = recipes[indexPath.row]
//        }
    }
    
    //MARK: File Private Methods
    ///methods to check if all recipe in recipes still already exist
    fileprivate func updateRecipeArray(){
        for recipe in recipes {
            if recipe.isCreate == true {
                recipes.removeAll()
                guard let createRecipes = realm?.objects(RecipeCreated.self) else {return}
                for createRecipe in createRecipes {
                    let newRecipe = realmDataManager.mapCreatedRecipeToRecipe(for: createRecipe)
                    recipes.append(newRecipe)
                }
            }
        }
    }
}

//MARK: - TableView
extension RecipeViewController: UITableViewDelegate{
    
}
extension RecipeViewController: UITableViewDataSource{
    /// func to return number of Rows section for table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    ///func to configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipesTableViewCell else {
            return UITableViewCell()
        }
        guard recipes.count > 0 else {
            cell.configure(withTitle: "Aucune recette", imageUrl: nil, imageData: nil)
            return cell
        }
        
        cell.configure(withTitle: recipes[indexPath.row].title, imageUrl: recipes[indexPath.row].imageString ?? nil, imageData: recipes[indexPath.row].imageData ?? nil )
        return cell
    }
}

