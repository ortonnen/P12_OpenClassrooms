//
//  ViewController.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 04/01/2021.
//


import UIKit
import RealmSwift

//MARK: - Menu View Controller
class MenuViewController: UIViewController {
    //MARK: Properties
    let realmDataManager = RealmDataManager()
    let realm = try? Realm()
    var recipes = [Recipe]()
    var isCreateRecipeSegue = false
    
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print ( Realm.Configuration .defaultConfiguration.fileURL!)
        deleteAllData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        recipes.removeAll()
        map()
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isCreateRecipeSegue == true {
            if recipes.count > 0 {
                return true
            }
            return false
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? RecipeViewController {
            guard recipes.count > 0 else {
                return
            }
            recipesVC.recipes = recipes
        }
    }
    
    //MARK: Action
    @IBAction func tappedSearchRecipeButton(_ sender: Any) {
        isCreateRecipeSegue = false
    }
    @IBAction func tappedCreateRecipeButton(_ sender: Any) {
        isCreateRecipeSegue = false
    }
    @IBAction func tappedConsultRecipeButton(_ sender: Any) {
        isCreateRecipeSegue = true
        guard recipes.count > 0 else {
            noRecipeCreateAlerte()
            return
        }
    }
    
    //MARK: File Private Methods
    ///methods to delete all element in data
    fileprivate func deleteAllData() -> ()? {
        return try! realm?.write({
            realm?.deleteAll()
        })
    }
    ///method to map Created Recipe in Recipe for recipe tableview
    fileprivate func map() {
        guard let dataRecipes = realm?.objects(RecipeCreated.self) else {return}
        guard dataRecipes.count > 0 else {
            return}
        for recipeCreated in dataRecipes{
            recipes.append(realmDataManager.mapCreatedRecipeToRecipe(for: recipeCreated))
        }
    }
}
//MARK: - Alerte
extension MenuViewController {
    private func noRecipeCreateAlerte() {
        let alerte = UIAlertController(title: "Aucune recette trouvée", message: "\n Vous n'avez pas de recette enregistrée\n", preferredStyle: .alert)
        let alerteAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alerte.addAction(alerteAction)
        self.present(alerte, animated: true, completion: nil)
    }
}

