//
//  InstructionsViewController.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 06/04/2021.
//

import UIKit
import AlamofireImage
import RealmSwift

//MARK: - Instruction View Controller
class InstructionsViewController: UIViewController {
    
    //MARK: Properties
    let recipeVC = RecipeViewController()
    var recipe: Recipe!
    var recipeInformation: RecipeInformation?

    let realm = try? Realm()
    let realmDataManager = RealmDataManager()
    var createRecipeList: Results<RecipeCreated> {
        return (realm?.objects(RecipeCreated.self))!
    }
    var favoriteRecipeList: Results<FavoriteRecipe> {
        return (realm?.objects(FavoriteRecipe.self))!
    }
    
    //MARK: Outlet
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var itemBarButton: UIButton!
    @IBOutlet weak var deleteFavoriteButton: UIButton!
    @IBOutlet weak var ingredientInformationTableView: UITableView!
    @IBOutlet weak var instructionTextView: UITextView!
    
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientInformationTableView.delegate = self
        ingredientInformationTableView.dataSource = self
        updateImage()
        updateRecipeDisplay()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let activityIndicator = activityIndicatorAlerte()
        present(activityIndicator, animated: true){
            self.translateIngredientUnit(for: self.recipe.ingredients)
            self.ingredientInformationTableView.reloadData()
            self.updateView(self.recipe)
            activityIndicator.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //MARK: Action
    @IBAction func tappedOnItemBarButton(_ sender: Any) {
        //FIXME: Add if recipe search.title = favoriteRecipe.title button text = retirer des fav
        
        if checkIfRecipeIsCreate() == true {
            deleteRecipeCreated()
            self.navigationController?.popViewController(animated: true)
        } else if checkIfRecipeIsFavorite() == true {
            itemBarButton.setTitle("retirer des favoris", for: .normal)
            recipe.isFavorite = false
            deleteFavoriteRecipe()
        } else {
            addToFavorite()
            recipe.isFavorite = true
            itemBarButton.setTitle("retirer des favoris", for: .normal)
        }
    }
    @IBAction func tappedOnDeleteFavoriteButton(_ sender: Any) {
        deleteFavoriteRecipe()
    }
    
    //MARK: File Private Methods
    ///method to get Instruction if it is Spoonacular Recipe
    fileprivate func getInstruction(for recipeId: Int) {
            RecipeService.shared.getRecipesInformation(for: "\(recipeId)") {
                (result) in
                    DispatchQueue.main.async {
                switch result {
                case .success(let recipeInstruction):
                    var recipeTranslate = recipeInstruction
                    guard let instruction = recipeInstruction.instructions else { return }
                    guard let title = recipeInstruction.title else {return}
                    self.translate(text: title) { (titleTranslate) in
                        recipeTranslate.title = titleTranslate
                        self.translate(text: instruction){(translateInstruction) in
                            recipeTranslate.instructions = translateInstruction
                            self.updateRecipe(recipeTranslate)
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.alerte("Erreur", "impossible de récuperer les instructions de la recette", "ok")
                }
            }
        }
    }
    ///method to translate Recipe
    fileprivate func translate(text: String, completion: @escaping(String) -> Void) {
        TranslationService.shared.getTranslate(from: "en", to: "fr", for: text) { (result) in
                switch result {
                case .success(let response):
                    completion(response.data.translations[0].translatedText)
                case .failure(let error):
                    print(error)
                }
        }
    }
    ///method to translate name and unit for ingredient
    fileprivate func translateIngredientName(for ingredients: [Ingredient]){
        DispatchQueue.main.async {
            self.recipe.ingredients.removeAll()
        var ingredientName: String = ""
        
            let semaphore = DispatchSemaphore(value: 0)
            for ingredient in ingredients {
                
                self.translate(text: ingredient.name) { (name) in
                    ingredientName = name
                    let newIngredient = Ingredient(name: ingredientName, quantity: ingredient.quantity, unit: ingredient.unit)
                    self.recipe.ingredients.append(newIngredient)
                    semaphore.signal()
                }
                semaphore.wait()
            }
            self.ingredientInformationTableView.reloadData()
        }
    }
    fileprivate func translateIngredientUnit(for ingredients: [Ingredient]){
        DispatchQueue.main.async {
            self.recipe.ingredients.removeAll()
        var ingredientUnit: String = ""
            let semaphore = DispatchSemaphore(value: 0)
            for ingredient in ingredients {
                
                    self.translate(text: ingredient.unit) { (unit) in
                        ingredientUnit = unit
                        let newIngredient = Ingredient(name: ingredient.name, quantity: ingredient.quantity, unit: ingredientUnit)
                        self.recipe.ingredients.append(newIngredient)

                    semaphore.signal()
                }
                semaphore.wait()
            }
            self.ingredientInformationTableView.reloadData()
        }
    }
    ///method to update the display according to the type of recipe
    fileprivate func updateRecipeDisplay() {
        if checkIfRecipeIsCreate() == true {
            itemBarButton.setTitle("Effacer la recette", for: .normal)
        } else {
            itemBarButton.setTitle("Ajouter aux Favoris", for: .normal)
            guard let id = recipe.id else { return }
            getInstruction(for: id)
        }
    }
    ///method to update view
    fileprivate func updateView(_ recipe: Recipe) {
        recipeTitleLabel.text = recipe.title
        timeLabel.text = "\(recipe.time ) min"
        servingLabel.text = "\(recipe.serving )"
        instructionTextView.text = recipe.instruction
    }
    /// update recipe information
    fileprivate func updateRecipe(_ recipeInstruction: RecipeInformation) {
        self.recipe.title = recipeInstruction.title ?? self.recipe.title
        self.recipe.serving = recipeInstruction.servings ?? 0
        self.recipe.time = recipeInstruction.readyInMinutes ?? 0
        self.recipe.instruction = recipeInstruction.instructions ?? "Pas d'instruction"
        for ingredient in recipeInstruction.extendedIngredients {
            let newIngredient = self.realmDataManager.mapSpoonacularIngredientToIngredient(for: ingredient)
            self.recipe.ingredients.append(newIngredient)
        }
        translateIngredientName(for: recipe.ingredients)
    }
    ///method to update Image for Recipe
    fileprivate func updateImage() {
        if recipe.imageString != nil {
            guard let url = URL(string:recipe.imageString!) else { return }
            recipeImageView.af.setImage(withURL: url)
        } else  {
            guard let data = recipe.imageData else { return }
            recipeImageView.image = UIImage.init(data: data)
        }
    }
    ///method to check if recipe is create by user
    fileprivate func checkIfRecipeIsCreate()->Bool? {
        if recipe.isCreate == false {
            return false
        }
        return true
    }
    ///method to check if Recipe is favorite
    fileprivate func checkIfRecipeIsFavorite()-> Bool? {
        if recipe.isFavorite == true {
            return true
        }
        return false
    }
    ///method to delete recipe create from Realm
    fileprivate func deleteRecipeCreated() {
        try! realm?.write({
            for recipeCreate in createRecipeList {
                if recipe.title == recipeCreate.title {
                    realm?.delete(recipeCreate)
                    dismissAlerte("Supprimé", "La recette à bien été supprimée", "ok", completion: nil)
                } else {
                    alerte("Erreur", "Erreur inconnue, \n tentez de recharger la page", "ok")
                }
            }
        })
    }
    ///method to delete favorite recipe from Realm
    fileprivate func deleteFavoriteRecipe() {
        try! realm?.write({
            for favoriteRecipe in favoriteRecipeList {
                if recipe.title == favoriteRecipe.title {
                    realm?.delete(favoriteRecipe)
                    dismissAlerte("Favoris", "La recette a été correctement retirée des favoris", "ok"){
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        })
    }
    ///method to add current Recipe in favorite Recipe
    fileprivate func addToFavorite() {
        try! realm?.write({
            let favoriteRecipe = FavoriteRecipe()
            let ingredientsList = saveIngredient(for: recipe)
            
            favoriteRecipe.image = recipe.imageString ?? ""
            favoriteRecipe.title = recipe.title
            favoriteRecipe.instruction = recipe.instruction
            favoriteRecipe.servings = recipe.serving
            for ingredient in ingredientsList {
                favoriteRecipe.ingredients.append(ingredient)
            }
            realm?.add(favoriteRecipe)
        })
        alerte("Favoris", "La recette a été correctement ajoutée aux favoris", "ok")
    }
    ///method to save Ingredient
    fileprivate func saveIngredient(for recipe: Recipe)->[IngredientUsed]{
        var ingredientsUsed = [IngredientUsed]()
        for ingredient in recipe.ingredients {
            let newIngredient = IngredientUsed()
            newIngredient.ingredientQuantity = ingredient.quantity
            newIngredient.ingredientUnity = ingredient.unit
            newIngredient.name = ingredient.name
            ingredientsUsed.append(newIngredient)
        }
        return ingredientsUsed
    }
}
//MARK: - TableView
extension InstructionsViewController: UITableViewDelegate{
}
extension InstructionsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredients.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientListRecipeCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        let ingredient = recipe.ingredients[indexPath.row].name
        let quantity = String(recipe.ingredients[indexPath.row].quantity)
        let unit = recipe.ingredients[indexPath.row].unit
        cell.configure(withTitle: ingredient, quantity: quantity, unit: unit)
        return cell
    }
}

//MARK: - Alerte
extension InstructionsViewController{
    /// user Alerte
    private func alerte(_ title: String, _ message: String, _ buttonTitle: String) {
        let alerte = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerteAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
        alerte.addAction(alerteAction)
        self.present(alerte, animated: true, completion: nil)
    }
    ///user Alerte to dismiss View Controller
    private func dismissAlerte(_ title: String, _ message: String, _ buttonTitle: String, completion:(()->Void)?){
        let alerte = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerteAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
        alerte.addAction(alerteAction)
        self.navigationController?.popViewController(animated: true)
        self.present(alerte, animated: true, completion: nil)
    }
    ///activity Indicator alerte present during the network call
        private func activityIndicatorAlerte() -> UIAlertController {
            let alert = UIAlertController(title: "Recherche en cours", message: "Merci de patienter...\n\n\n", preferredStyle: .alert)
            let activityIndicator = UIActivityIndicatorView()
            alert.setBackgroundColor(color: #colorLiteral(red: 0.9633114934, green: 0.9485848546, blue: 0.8967990279, alpha: 1))
            alert.setTitlet(color: #colorLiteral(red: 0.643104732, green: 0.2448115349, blue: 0.1737442911, alpha: 1))
            alert.setMessage(color: #colorLiteral(red: 0.643104732, green: 0.2448115349, blue: 0.1737442911, alpha: 1))
            activityIndicator.color = #colorLiteral(red: 0.95542413, green: 0.6744924188, blue: 0.4416911602, alpha: 1)
            activityIndicator.startAnimating()
            alert.view.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
            activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20.0).isActive = true
    
            return alert
        }
}
