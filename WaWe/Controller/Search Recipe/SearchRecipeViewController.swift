//
//  SearchRecipeViewController.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 10/03/2021.
//

import UIKit

//MARK: - Search Recipe View Controller
class SearchRecipeViewController: UIViewController {
    
    //MARK: Properties
    var ingredients = [String]()
    var recipes = [Recipe]()
    var diet: String?
    var intolerance: String?
    var typeOfCuisine: String?
    var typeOfMeal: String?
    
    var isWorking: Bool = false
    
//    let vc = MoreInformationViewController(nibName: "MoreInformationViewController", bundle: nil)
    let realmDataManager = RealmDataManager()
    
    //MARK: Outlet
    @IBOutlet weak var ingredientSearchBar: UISearchBar!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var filteredButton: UIButton!
    @IBOutlet weak var searchButton: RoundButton!
    
    //MARK: Methods Override
    override func viewDidLoad() {
        super.viewDidLoad()
//        vc.delegate = self
        
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        initializeHideKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard recipes.count > 0 else {
            return false
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? RecipeViewController {
            recipesVC.recipes = recipes
            clear()
        }
//        } else if let moreInformationVC = segue.destination as? MoreInformationViewController {
//            moreInformationVC.delegate = self
//        }
    }
    
    //MARK: Action
    @IBAction func tappedFilteredButton(_ sender: Any) {
        performSegue(withIdentifier: "moreInformationToSearchRecipeSegue", sender: sender)
    }
    @IBAction func tappedSearchButton(_ sender: Any) {
        translateIngredient()
    }
    
    //MARK: File private Methods
    ///method to add ingredient in ingredients array
    fileprivate func addIngredient(for ingredient: String) {
        ingredients.append(ingredient)
        ingredientTableView.reloadData()
    }
    /// method to translate ingredient name
    fileprivate func translateIngredient() {
        translate(from: "fr", to: "en", for: ingredients.joined(separator: ",")) { (translatedText) in
            self.getRecipe(with: translatedText)
        }
    }
    ///method to get recipe
    fileprivate func getRecipe(with ingredients: String) {
        let activityIndicator = activityIndicatorAlerte()
        self.present(activityIndicator, animated: true, completion: nil)
        DispatchQueue.main.async {
            RecipeService.shared.getRecipes(for: ingredients, withParameters: self.intolerance, cuisine: self.typeOfCuisine, diet: self.diet, typeOfMeal: self.typeOfMeal) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let recipesResults):
                        guard recipesResults.results.count > 0 else {
                            return self.NoRecipeFoundAlerte()
                        }
                        self.mapSpoonacularResult(for: recipesResults.results)
                    case .failure(let error):
                        print(error.self)
                    }
                    
                }
            }
            activityIndicator.dismiss(animated: true, completion: nil)
        }
    }
    ///method to translate a text
    fileprivate func translate(from detectedLang: String, to desiredLang: String, for text: String, completion: @escaping(String) -> Void) {
        TranslationService.shared.getTranslate(from: detectedLang, to: desiredLang, for: text) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(response.data.translations[0].translatedText)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    /// methode to map JSon Result to Recipe
    fileprivate func mapSpoonacularResult(for spoonacularRecipes: [ResultOfResearch]) {
        var recipeTitle = String()
        DispatchQueue.global().async {
            let semaphore = DispatchSemaphore(value: 0)
            for recipe in spoonacularRecipes {
                self.translate(from: "en", to: "fr", for: recipe.title) { (translatedText) in
                    recipeTitle = translatedText
              
                    let image = recipe.image
                    let id = recipe.id
                    
                    self.recipes.append(Recipe(title: recipeTitle, imageString: image, id: id, imageData: nil, isCreate: false, isFavorite: false, ingredients: [], time: 0, serving: 0, instruction: "Pas d'instruction"))
                    semaphore.signal()
                }
                semaphore.wait()
            }
            self.isWorking = self.shouldPerformSegue(withIdentifier: "searchRecipeSegueToRecipe", sender: self)
            DispatchQueue.main.sync {
                self.performSegue(withIdentifier: "searchRecipeSegueToRecipe", sender: self)
            }
        }
    }
    ///method to reset array for request
    fileprivate func clear() {
        diet = ""
        intolerance = ""
        typeOfMeal = ""
        typeOfCuisine = ""
        ingredients.removeAll()
        ingredientTableView.reloadData()
    }
}


//MARK:- Protocol
//extension SearchRecipeViewController: PassingDataDelegateProtocol{
//    ///func to update parameters for call network
//    func updateData(for dietArray: [String], intoleranceArray: [String], cuisineArray: [String], mealArray: [String]) {
//        diet = dietArray.joined(separator: ",")
//        intolerance = intoleranceArray.joined(separator: ",")
//        typeOfCuisine = cuisineArray.joined(separator: ",")
//        typeOfMeal = mealArray.joined(separator: ",")
//    }
//}

//MARK: - Alerte
extension SearchRecipeViewController {
    /// alert if ingredient text is empty
    private func textIsEmptyAlerte() {
        let alerte = UIAlertController(title: "Text vide", message: "Veuillez entrer un ingredient dans la liste", preferredStyle: .alert)
        let alerteAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            self.present(alerte, animated: true, completion: nil)
        }
        alerte.addAction(alerteAction)
    }
    /// alert if no recipe found after call network
    private func NoRecipeFoundAlerte() {
        let alerte = UIAlertController(title: "Aucune recette trouvée", message: "\n Merci d'effectuer une nouvelle recherche\n", preferredStyle: .alert)
        let alerteAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alerte.addAction(alerteAction)
        self.present(alerte, animated: true, completion: nil)
    }
    ///activity Indicator alerte present during the network call
        private func activityIndicatorAlerte() -> UIAlertController {
            let alert = UIAlertController(title: "Recherche en cours", message: "Merci de patienter...\n\n\n", preferredStyle: .alert)
            let activityIndicator = UIActivityIndicatorView()
//            alert.setBackgroundColor(color: #colorLiteral(red: 0.9633114934, green: 0.9485848546, blue: 0.8967990279, alpha: 1))
//            alert.setTitlet(color: #colorLiteral(red: 0.643104732, green: 0.2448115349, blue: 0.1737442911, alpha: 1))
//            alert.setMessage(color: #colorLiteral(red: 0.643104732, green: 0.2448115349, blue: 0.1737442911, alpha: 1))
            activityIndicator.color = #colorLiteral(red: 0.95542413, green: 0.6744924188, blue: 0.4416911602, alpha: 1)
            activityIndicator.startAnimating()
            alert.view.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
            activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20.0).isActive = true
    
            return alert
        }
}

//MARK: - TableView
extension SearchRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    /// func to return number of Rows section for table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    /// func to return elements  in table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        let ingredient = ingredients[indexPath.row]
        
        cell.textLabel?.text = " + \(ingredient) "
        
        return cell
    }
    ///func to delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        ingredients.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - SearchBar
extension SearchRecipeViewController: UISearchBarDelegate {
    ///func to dismiss keyaboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let ingredientName = ingredientSearchBar.text, !ingredientName.isEmpty else {
            textIsEmptyAlerte()
            return
        }
        addIngredient(for: ingredientName)
        ingredientSearchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

//MARK: - Keyboard
extension SearchRecipeViewController {
    ///func to func to define gesture for dismissKeyboard
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    ///func to dismiss keyaboard
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}
