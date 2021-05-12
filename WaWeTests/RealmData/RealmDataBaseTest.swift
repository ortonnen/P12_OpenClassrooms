//
//  RealmDataBaseTest.swift
//  WaweTests
//
//  Created by Nathalie Simonnet on 28/04/2021.
//

import XCTest
import RealmSwift
@testable import WaWe

class RealmDataBaseTest: XCTestCase {
    
    let realmDataManager = RealmDataManager()
    var ingredients = [IngredientUsed]()
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let firstIngredientArray = IngredientUsed()
        firstIngredientArray.name = "tomate"
        firstIngredientArray.ingredientUnity = "moyenne"
        firstIngredientArray.ingredientQuantity = 3

        let secondIngredientArray = IngredientUsed()
        secondIngredientArray.name = "concombre"
        secondIngredientArray.ingredientUnity = "_"
        secondIngredientArray.ingredientQuantity = 1
        
        ingredients.append(firstIngredientArray)
        ingredients.append(secondIngredientArray)
        
    }
    
    //MARK: - Create Recipe
    func testSavedCreateRecipe_WhenRecipeIsCreate_ThenShouldBeCorrectlySaved(){
        let realm = try? Realm()
        let recipeCreated = RecipeCreated()
        let dataCreateRecipes = realm?.objects(RecipeCreated.self)
        
        try! realm?.write({
            recipeCreated.title = "Salade de Tomatte"
            recipeCreated.instruction = "Pas d'instruction"
            recipeCreated.servings = 2
            
            realm?.add(recipeCreated)
        })
        
        XCTAssertEqual(recipeCreated.title, "Salade de Tomatte")
        XCTAssertEqual(dataCreateRecipes?.count, 1)
    }
    
    func testDeleteCreateRecipe_WhenRecipeIsCreate_ThenShouldBeCorrectlyDelete(){
        let realm = try? Realm()
        let recipeCreated = RecipeCreated()
        let dataCreateRecipes = realm?.objects(RecipeCreated.self)
        
        try! realm?.write({
            recipeCreated.title = "Salade de Tomatte"
            recipeCreated.instruction = "Pas d'instruction"
            recipeCreated.servings = 2
            realm?.add(recipeCreated)
            
            realm?.delete(recipeCreated)
        })
        
        XCTAssertEqual(dataCreateRecipes?.count, 0)
    }
    
    func testCreateRecipe_WhenAddManyRecipeCreate_ThenShouldHaveAllRecipeInCoreData(){
        let realm = try? Realm()
        let firstRecipeCreated = RecipeCreated()
        let secondRecipeCreated = RecipeCreated()
        let dataCreateRecipes = realm?.objects(RecipeCreated.self)
        //add First Recipe
        try! realm?.write({
            //add First Recipe
            firstRecipeCreated.title = "Salade de Tomatte"
            firstRecipeCreated.instruction = "Pas d'instruction"
            firstRecipeCreated.servings = 2
            
            realm?.add(firstRecipeCreated)
            
            //add Two Recipe
            secondRecipeCreated.title = "Salade de Concombre"
            secondRecipeCreated.instruction = "Pas d'instruction"
            secondRecipeCreated.servings = 4
            
            realm?.add(secondRecipeCreated)
        })
        
        XCTAssertEqual(dataCreateRecipes?.count, 2)
    }
    
    func testClearCreatdRecipeDataBase_WhenAllCreatedRecipeEntityIsSaved_ThenShouldBeCorrectlyDeleteAll(){
        let realm = try? Realm()
        let firstRecipeCreated = RecipeCreated()
        let secondRecipeCreated = RecipeCreated()
        let dataCreateRecipes = realm?.objects(RecipeCreated.self)
        //add First Recipe
        try! realm?.write({
            //add First Recipe
            firstRecipeCreated.title = "Salade de Tomatte"
            firstRecipeCreated.instruction = "Pas d'instruction"
            firstRecipeCreated.servings = 2
            
            realm?.add(firstRecipeCreated)
            
            //add Two Recipe
            secondRecipeCreated.title = "Salade de Concombre"
            secondRecipeCreated.instruction = "Pas d'instruction"
            secondRecipeCreated.servings = 4
            
            realm?.add(secondRecipeCreated)
        })
        XCTAssertEqual(dataCreateRecipes?.count, 2)
        //delete All
        try! realm?.write({
            realm?.deleteAll()
        })
        
        XCTAssertEqual(dataCreateRecipes?.count, 0)
    }
    
    //MARK: - Favorite Recipe
    func testSavedFavoriteRecipe_WhenRecipeIsAddInFavorite_ThenShouldBeCorrectlySaved(){
        let realm = try? Realm()
        let favoriteRecipe = FavoriteRecipe()
        let dataFavoriteRecipe = realm?.objects(FavoriteRecipe.self)
        
        try! realm?.write({
            favoriteRecipe.title = "Salade de Tomatte"
            favoriteRecipe.instruction = "Pas d'instruction"
            favoriteRecipe.servings = 2
            
            realm?.add(favoriteRecipe)
        })
        
        XCTAssertEqual(favoriteRecipe.title, "Salade de Tomatte")
        XCTAssertEqual(dataFavoriteRecipe?.count, 1)
    }
    
    func testDeleteFavoriteRecipe_WhenRecipeAddInFavorite_ThenShouldBeCorrectlyDelete(){
        let realm = try? Realm()
        let favoriteRecipe = FavoriteRecipe()
        let dataFavoriteRecipe = realm?.objects(FavoriteRecipe.self)
        
        try! realm?.write({
            favoriteRecipe.title = "Salade de Tomatte"
            favoriteRecipe.instruction = "Pas d'instruction"
            favoriteRecipe.servings = 2
            realm?.add(favoriteRecipe)
            
            realm?.delete(favoriteRecipe)
        })
        
        XCTAssertEqual(dataFavoriteRecipe?.count, 0)
    }
    
    func testSavedManyRecipeInFavorite_WhenAddManyRecipeInFavorite_ThenShouldHaveAllRecipeInCoreData(){
        let realm = try? Realm()
        let firstFavoriteRecipe = FavoriteRecipe()
        let secondFavoriteRecipe = FavoriteRecipe()
        let dataFavoriteRecipe = realm?.objects(FavoriteRecipe.self)
        //add First Recipe
        try! realm?.write({
            //add First Recipe
            firstFavoriteRecipe.title = "Salade de Tomatte"
            firstFavoriteRecipe.instruction = "Pas d'instruction"
            firstFavoriteRecipe.servings = 2
            
            realm?.add(firstFavoriteRecipe)
            
            //add Two Recipe
            secondFavoriteRecipe.title = "Salade de Concombre"
            secondFavoriteRecipe.instruction = "Pas d'instruction"
            secondFavoriteRecipe.servings = 4
            
            realm?.add(secondFavoriteRecipe)
        })
        
        XCTAssertEqual(dataFavoriteRecipe?.count, 2)
    }
    
    func testClearFavoriteRecipeDataBase_WhenAllFavoriteFavoriteRecipeEntityIsSaved_ThenShouldBeCorrectlyDeleteAll(){
        let realm = try? Realm()
        let firstFavoriteRecipe = FavoriteRecipe()
        let secondRecipeCreated = FavoriteRecipe()
        let dataFavoriteRecipe = realm?.objects(FavoriteRecipe.self)
        //add First Recipe
        try! realm?.write({
            //add First Recipe
            firstFavoriteRecipe.title = "Salade de Tomatte"
            firstFavoriteRecipe.instruction = "Pas d'instruction"
            firstFavoriteRecipe.servings = 2
            
            realm?.add(firstFavoriteRecipe)
            
            //add Two Recipe
            secondRecipeCreated.title = "Salade de Concombre"
            secondRecipeCreated.instruction = "Pas d'instruction"
            secondRecipeCreated.servings = 4
            
            realm?.add(secondRecipeCreated)
        })
        XCTAssertEqual(dataFavoriteRecipe?.count, 2)
        //delete All
        try! realm?.write({
            realm?.deleteAll()
        })
        
        XCTAssertEqual(dataFavoriteRecipe?.count, 0)
    }
    
    //MARK: - IngredientUsed
    func testSavedFIngredient_WhenIngredientIsAdd_ThenShouldBeCorrectlySaved(){
        let realm = try? Realm()
        let ingredient = IngredientUsed()
        let dataIngredients = realm?.objects(IngredientUsed.self)
        
        try! realm?.write({
            ingredient.name = "Tomate"
            ingredient.ingredientQuantity = 2
            ingredient.ingredientUnity = "_"
            
            realm?.add(ingredient)
        })
        XCTAssertEqual(ingredient.name, "Tomate")
        XCTAssertEqual(dataIngredients?.count, 1)
    }
    
    func testDeleteIngredient_WhenIngredientIsAdd_ThenShouldBeCorrectlyDelete(){
        let realm = try? Realm()
        let ingredient = IngredientUsed()
        let dataIngredients = realm?.objects(IngredientUsed.self)
        
        try! realm?.write({
            ingredient.name = "Tomate"
            ingredient.ingredientQuantity = 2
            ingredient.ingredientUnity = "_"
            
            realm?.add(ingredient)
            
            realm?.delete(ingredient)
        })
        XCTAssertEqual(dataIngredients?.count, 0)
    }
    
    func testSavedManyIngredient_WhenAddManyIngredient_ThenShouldHaveAllIngredientInCoreData(){
        let realm = try? Realm()
        let firstIngredient = IngredientUsed()
        let secondIngredient = IngredientUsed()
        let dataIngredients = realm?.objects(IngredientUsed.self)
        //add First Recipe
        try! realm?.write({
            //add First Recipe
            firstIngredient.name = "Tomate"
            firstIngredient.ingredientQuantity = 2
            firstIngredient.ingredientUnity = "_"
            
            realm?.add(firstIngredient)
            
            //add Two Recipe
            secondIngredient.name = "Concombre"
            secondIngredient.ingredientQuantity = 1
            secondIngredient.ingredientUnity = "_"
            
            realm?.add(secondIngredient)
        })
        
        XCTAssertEqual(dataIngredients?.count, 2)
    }
    
    func testClearAllIngredientInDataBase_WhenAllIngredientEntityIsSaved_ThenShouldBeCorrectlyDeleteAll(){
        let realm = try? Realm()
        let firstIngredient = IngredientUsed()
        let secondIngredient = IngredientUsed()
        let dataIngredient = realm?.objects(IngredientUsed.self)
        //add First Recipe
        try! realm?.write({
            //add First Recipe
            firstIngredient.name = "Tomate"
            firstIngredient.ingredientQuantity = 2
            firstIngredient.ingredientUnity = "_"
            
            realm?.add(firstIngredient)
            
            //add Two Recipe
            secondIngredient.name = "Concombre"
            secondIngredient.ingredientQuantity = 1
            secondIngredient.ingredientUnity = "_"
            
            realm?.add(secondIngredient)
        })
        XCTAssertEqual(dataIngredient?.count, 2)
        //delete All
        try! realm?.write({
            realm?.deleteAll()
        })

        XCTAssertEqual(dataIngredient?.count, 0)
    }
    
    //MARK: All Data
    func testClearAllDataBase_WhenDeleteAllEntitys_ThenDataBaseIsEmpty(){
        let realm = try? Realm()
        let recipeCreated = RecipeCreated()
        let favoriteRecipe = FavoriteRecipe()
        let ingredient = IngredientUsed()
        let dataCreateRecipes = realm?.objects(RecipeCreated.self)
        let dataFavoriteRecipe = realm?.objects(FavoriteRecipe.self)
        let dataIngredient = realm?.objects(IngredientUsed.self)
        //add First Recipe
        try! realm?.write({
            //add Recipe Created
            recipeCreated.title = "Salade de Tomatte"
            recipeCreated.instruction = "Pas d'instruction"
            recipeCreated.servings = 2
            
            realm?.add(recipeCreated)
            
            //add Favorite Recipe
            favoriteRecipe.title = "Salade de Concombre"
            favoriteRecipe.instruction = "Pas d'instruction"
           favoriteRecipe.servings = 4
            
            realm?.add(favoriteRecipe)
            
            //add Favorite Recipe
            ingredient.name = "Concombre"
            ingredient.ingredientQuantity = 1
            ingredient.ingredientUnity = "_"
            
            realm?.add(ingredient)
        })
        XCTAssertEqual(dataCreateRecipes?.count, 1)
        XCTAssertEqual(dataFavoriteRecipe?.count, 1)
        XCTAssertEqual(dataIngredient?.count, 1)
        //delete All
        try! realm?.write({
            realm?.deleteAll()
        })
        
        XCTAssertEqual(dataCreateRecipes?.count, 0)
        XCTAssertEqual(dataFavoriteRecipe?.count, 0)
        XCTAssertEqual(dataIngredient?.count, 0)
    }
    
    //MARK: Realm Data Manager
    
    func testGivenRecipeCreated_WhenWeMapIntoRecipe_ThenNewRecipeIsEqualToCreatedRecipe(){
       let recipeCreated = RecipeCreated()
        recipeCreated.title = "Salade de Tomatte"
        recipeCreated.instruction = "Pas d'instruction"
        recipeCreated.servings = 2
        for ingredient in ingredients {
            recipeCreated.ingredients.append(ingredient)
        }
         
        let recipe = realmDataManager.mapCreatedRecipeToRecipe(for: recipeCreated)
        
        XCTAssertEqual(recipe.title, "Salade de Tomatte")
        XCTAssertEqual(recipe.instruction, "Pas d'instruction")
        XCTAssertEqual(recipe.serving, 2)
        XCTAssertEqual(recipe.ingredients.count, 2)
    }
    func testGivenSpoonacularIngredient_WhenWeMapIntoIngredient_ThenNewIngredientIsEqualToSpoonacularIngredient(){
        let spoonaculaIngredient =  ExtendedIngredient(id: 1, name: "Tomate", original: "Tomate Coeur de Boeuf", amount: 3, unit: "moyenne")
        
          
        let ingredient = realmDataManager.mapSpoonacularIngredientToIngredient(for: spoonaculaIngredient)
         
        XCTAssertEqual(ingredient.name, "Tomate")
        XCTAssertEqual(ingredient.unit,"moyenne")
        XCTAssertEqual(ingredient.quantity, 3)
    }
    
    func testGivenFavoriteRecipe_WhenWeMapIntoRecipe_ThenNewRecipeIsEqualToFavoriteRecipe(){
        
        let favoriteRecipe = FavoriteRecipe()
         favoriteRecipe.title = "Salade de Tomatte"
         favoriteRecipe.instruction = "Pas d'instruction"
         favoriteRecipe.servings = 2
        for ingredient in ingredients {
           favoriteRecipe.ingredients.append(ingredient)
        }
         
          
         let recipe = realmDataManager.mapFavoriteRecipeToRecipe(for: favoriteRecipe)
         
         XCTAssertEqual(recipe.title, "Salade de Tomatte")
         XCTAssertEqual(recipe.instruction, "Pas d'instruction")
         XCTAssertEqual(recipe.serving, 2)
        XCTAssertEqual(recipe.ingredients.count, 2)
    }
    
}
