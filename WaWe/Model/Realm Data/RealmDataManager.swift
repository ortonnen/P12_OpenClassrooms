//
//  RealmDataManager.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 22/03/2021.
//

import Foundation
import RealmSwift
import Realm

//MARK: - Realm Data Manager
class RealmDataManager {
    ///method to map IngredientExtend to Ingredient
    func mapSpoonacularIngredientToIngredient(for ingredient: ExtendedIngredient) -> Ingredient{
        let name = ingredient.name
        let quantity = ingredient.amount
        let unit = ingredient.unit
        return Ingredient(name: name, quantity: quantity, unit: unit)
    }
    ///method to map create Recipe to current Recipe
    func mapCreatedRecipeToRecipe(for recipeCreated: RecipeCreated)-> Recipe {
        let title = recipeCreated.title
        let image = recipeCreated.image
        let serving = recipeCreated.servings
        let instruction = recipeCreated.instruction
        let ingredients = transformIngredientListToArray(for: recipeCreated, or: nil)
        
        return Recipe(title: title, imageString: nil, id: nil, imageData: image, isCreate: true, isFavorite: false, ingredients: ingredients, time: 0, serving: serving, instruction: instruction )
    }
    ///method to map current Recipe to favorite Recipe
    func mapFavoriteRecipeToRecipe(for recipe: FavoriteRecipe)-> Recipe {
        let title = recipe.title
        let image = recipe.image
        let serving = recipe.servings
        let instruction = recipe.instruction
        let ingredients = transformIngredientListToArray(for: nil, or: recipe)
        
        return Recipe(title: title, imageString: image, id: nil, imageData: nil, isCreate: false, isFavorite: true,ingredients: ingredients, time: 0, serving: serving, instruction: instruction )
    }
    ///method to transform a List to Array
    fileprivate func transformIngredientListToArray(for recipeCreate: RecipeCreated?, or favoriteRecipe: FavoriteRecipe?)->[Ingredient] {
        var ingredients = [Ingredient]()
        if recipeCreate != nil {
            for ingredient in recipeCreate!.ingredients {
                let name = ingredient.name
                let quantity = ingredient.ingredientQuantity
                let unit = ingredient.ingredientUnity
                
                let newIngredient = Ingredient(name: name, quantity: Float(quantity), unit: unit)
                ingredients.append(newIngredient)
            }
        } else if favoriteRecipe != nil {
            for ingredient in favoriteRecipe!.ingredients {
                let name = ingredient.name
                let quantity = ingredient.ingredientQuantity
                let unit = ingredient.ingredientUnity
                
                let newIngredient = Ingredient(name: name, quantity: quantity, unit: unit)
                ingredients.append(newIngredient)
            }
        }
        return ingredients
    }
}
//MARK: - Recipe created
class RecipeCreated: Object {
    @objc dynamic var recipeId: ObjectId = ObjectId.generate()
    @objc dynamic var title: String = ""
    @objc dynamic var servings: Int = 0
    @objc dynamic var instruction: String = ""
    @objc dynamic var image: Data? = nil
    
    let ingredients = List<IngredientUsed>()
    override static func primaryKey() -> String? {
        return "recipeId"
    }
}
//MARK: - Favorite Recipe created
class FavoriteRecipe: Object {
    @objc dynamic var recipeId: ObjectId = ObjectId.generate()
    @objc dynamic var title: String = ""
    @objc dynamic var servings: Int = 0
    @objc dynamic var instruction: String = ""
    @objc dynamic var image: String = ""
    
    let ingredients = List<IngredientUsed>()
    override static func primaryKey() -> String? {
        return "recipeId"
    }
}
//MARK: - Ingredient
class IngredientUsed: Object {
    @objc dynamic var ingredientId : ObjectId = ObjectId.generate()
    @objc dynamic var name: String = ""
    @objc dynamic var ingredientUnity: String = ""
    @objc dynamic var ingredientQuantity: Float = 0
    let recipe = LinkingObjects(fromType: RecipeCreated.self, property: "ingredients")
    
    override static func primaryKey() -> String? {
        return "ingredientId"
    }
}
