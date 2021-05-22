//
//  CreateARecipeViewController.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 10/03/2021.
//

import UIKit
import RealmSwift

//MARK: - Create Recipe View Controller
final class CreateARecipeViewController: UIViewController {
    //MARK: Properties
    let realm = try? Realm()
    private let pickerImage = UIImagePickerController()
    var currentIngredients = [IngredientUsed]()
    var ingredientsList: Results<IngredientUsed> {
        return (realm?.objects(IngredientUsed.self))!
    }
    var instruction: String = ""
    let vc = AddInstructionViewController(nibName: "AddInstructionViewController", bundle: nil)
    
    //MARK: Outlet
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var servingsTextField: UITextField!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var ingredientInformationTableView: UITableView!
    @IBOutlet weak var addImageButton: UIButton!
    
   
    //MARK: Methods override
    override func viewDidLoad() {
        super.viewDidLoad()
        vc.delegate = self
        pickerImage.delegate = self
        ingredientInformationTableView.delegate = self
        ingredientInformationTableView.dataSource = self
        initializeHideKeyboard()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addInstructionVC = segue.destination as? AddInstructionViewController {
            addInstructionVC.delegate = self
        }
    }
    
    //MARK: Action
    @IBAction func tappedSaveRecipeButton(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
            return alerte("Recette", "Vous ne pouvez pas sauvegarder une recette sans titre", "OK")
        }
        guard recipeImage.image != nil, let serving = servingsTextField.text, !serving.isEmpty, currentIngredients.count > 0, !instruction.isEmpty else {
            confirmeSavedRecipe("Créer", "tous les champs de la recettes ne sont pas complet, \n Êtes vous sur de vouloir sauvegarder?", "Valider", "Annuler")
            return
        }
        saveRecipe(for: title, servings: Int(serving), instruction: self.instruction, ingredients: self.currentIngredients, image: self.recipeImage.image)
        alerte("Recette Enregistrée", "Votre recette à été correctement enregistrée", "ok")
    }
    @IBAction func tappedAddIngredientButton(_ sender: Any) {
        addIngredient()
        ingredientInformationTableView.reloadData()
    }
    @IBAction func tappedAddImageButton(_ sender: Any) {
        choosePhotoInLibrary()
    }
    @IBAction func tappedToDeleteIngredient(_ sender: Any) {
        confirmeDeleteIngredient("Ingrédients", "êtes-vous sûre de vouloirs supprimer la liste d'ingédient? ", "Valider", "Annuler")
        ingredientInformationTableView.reloadData()
    }
    
    //MARK: File private methods
    ///method to choose photo in personnal library
    fileprivate func choosePhotoInLibrary() {
        pickerImage.allowsEditing = true
        pickerImage.sourceType = .photoLibrary
        pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(pickerImage, animated: true, completion: nil)
    }
    
    ///Realm method to save in DataBase and append in currentIngredient array
    fileprivate func saveIngredient(_ ingredientName: String, _ ingredientQuantity: Float, _ ingredientUnity: String) -> ()? {
        return try! realm?.write({
            let ingredient = IngredientUsed()
            ingredient.name = ingredientName
            ingredient.ingredientQuantity = ingredientQuantity
            ingredient.ingredientUnity = ingredientUnity
            currentIngredients.append(ingredient)
            return realm?.add(ingredient)
        })
    }
    
    ///method to avoid duplicate ingredients
    fileprivate func checkIfIngredientAlreadyExist(for ingredientName: String, quantity: Float) -> Bool {
        for currentIngredient in currentIngredients {
            if currentIngredient.name == ingredientName && currentIngredient.ingredientQuantity == quantity {
                alerte("Ingredient", "vous avez déjà enregistré cet ingredient", "ok")
                return true
            }
        }
        return false
    }
  
    ///method to save ingredient list in dataBase
    fileprivate func updateData(_ ingredientName: String, _ quantity: Float, _ unit: String) -> ()? {
        guard ingredientsList.count > 0 else {
            return saveIngredient(ingredientName, quantity, unit)
        }
        guard checkIfIngredientAlreadyExist(for: ingredientName, quantity: quantity) == false else {
            return nil
        }
        return saveIngredient(ingredientName, quantity, unit)
    }
    
    ///method to add ingredient in ingredient Array
    fileprivate func addIngredient() {
        guard let ingredient = ingredientTextField.text, !ingredient.isEmpty else {
            return alerte("Ingredient", "vous n'avez pas saisie de nom pour l'ingredient", "Ok")
        }
        guard let quantity = Float(quantityTextField.text ?? "0") else {
          return confirmeAddIngredient("Quantité", "êtes-vous sur de ne pas vouloir saisir de quantité pour cet ingredient?", "Valider", "Annuler")
        }
        guard let unit = unitTextField.text, !unit.isEmpty else {
           return confirmeAddIngredient("Unité", "êtes-vous sur de ne pas vouloir saisir d'unité pour cet ingredient?", "Valider", "Annuler")
        }
        updateData(ingredient, quantity, unit)
    }
    
    ///method to save recipe in dataBase
    fileprivate func saveRecipe(for recipeTitle: String, servings: Int?, instruction: String?, ingredients: [IngredientUsed], image: UIImage? ){
        try! realm?.write({
            let recipe = RecipeCreated()
            let data = image?.jpegData(compressionQuality: 0.5)
            recipe.title = recipeTitle
            recipe.instruction = instruction ?? "Pas d'instruction"
            recipe.servings = servings ?? 0
            recipe.image = data
            for ingredient in ingredients {
                recipe.ingredients.append(ingredient)
            }
            realm?.add(recipe)
        })
    }
}

//MARK: - UIImagePickerView Controller
extension CreateARecipeViewController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    //MARK: Methods
    ///func to change Image View
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        recipeImage.image = imagePicked
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Protocol
extension CreateARecipeViewController: PassingDataDelegateProtocol {
    func updateStringData(for String: String) {
        instruction = String
    }
}

//MARK: - TableView
extension CreateARecipeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentIngredients.count
    }
    
    ///methode to configure TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientListCreateRecipeCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        let ingredient = currentIngredients[indexPath.row].name
        let quantity = String(currentIngredients[indexPath.row].ingredientQuantity)
        let unit = currentIngredients[indexPath.row].ingredientUnity
        cell.configure(withTitle: ingredient, quantity: quantity, unit: unit)
        return cell
    }
    
    ///methode to delete cell in TebleView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        currentIngredients.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - Keyboard
extension CreateARecipeViewController {
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

//MARK: -Alerte
extension CreateARecipeViewController {
    /// user Alerte
    private func alerte(_ title: String, _ message: String, _ buttonTitle: String) {
        let alerte = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerteAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
        alerte.addAction(alerteAction)
        self.present(alerte, animated: true, completion: nil)
    }
    
    /// user Alerte with Choice to confirme saved Recipe
    private func confirmeSavedRecipe(_ title: String, _ message: String, _ firstButtonTitle: String, _ secondButtonTitle: String) {
        let alerte = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerteActionValidate = UIAlertAction(title: firstButtonTitle, style: .default){_ in
            let servings = Int(self.servingsTextField.text ?? "0")
            let recipeTitle = self.titleTextField.text ?? ""
            self.saveRecipe(for: recipeTitle, servings: servings, instruction: self.instruction, ingredients: self.currentIngredients, image: self.recipeImage.image)
            self.confirmationAlerte(nil, "La recette a été correctement enregistrée")
        }
        let alerteActionRefuse = UIAlertAction(title: secondButtonTitle, style: .destructive, handler: nil)
        
        alerte.addAction(alerteActionValidate)
        alerte.addAction(alerteActionRefuse)
        self.present(alerte, animated: true, completion: nil)
    }
    
    /// user Alerte with Choice to confirme add ingredient
    private func confirmeAddIngredient(_ title: String, _ message: String, _ firstButtonTitle: String, _ secondButtonTitle: String) {
        let alerte = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerteActionValidate = UIAlertAction(title: firstButtonTitle, style: .default){_ in
            let ingredient = self.ingredientTextField.text
            let quantity = Float(self.quantityTextField.text ?? "0")
           let unit = self.unitTextField.text
            self.updateData(ingredient ?? "Ingredient" , quantity ?? 0, unit ?? "")
            self.ingredientInformationTableView.reloadData()
        }
        let alerteActionRefuse = UIAlertAction(title: secondButtonTitle, style: .destructive, handler: nil)
        
        alerte.addAction(alerteActionValidate)
        alerte.addAction(alerteActionRefuse)
        self.present(alerte, animated: true, completion: nil)
    }
    
    /// user Alerte with Choice to confirme delete ingredient
    private func confirmeDeleteIngredient(_ title: String, _ message: String, _ firstButtonTitle: String, _ secondButtonTitle: String) {
        let alerte = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerteActionValidate = UIAlertAction(title: firstButtonTitle, style: .default){_ in
            self.currentIngredients.removeAll()
            self.ingredientInformationTableView.reloadData()
        }
        let alerteActionRefuse = UIAlertAction(title: secondButtonTitle, style: .destructive, handler: nil)
        
        alerte.addAction(alerteActionValidate)
        alerte.addAction(alerteActionRefuse)
        self.present(alerte, animated: true, completion: nil)
    }
    
    ///user Alerte to confirme action
    private func confirmationAlerte(_ title: String?, _ message: String?) {
        let confirmationAlerte = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(confirmationAlerte, animated: true, completion: nil)
        
        let time = DispatchTime.now() + 1.1
        DispatchQueue.main.asyncAfter(deadline: time){
          confirmationAlerte.dismiss(animated: true, completion: nil)
        }
    }
}

