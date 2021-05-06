//
//  FavoritesRecipes.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 15/03/2021.
//

import Foundation

//MARK: - Recipes
struct Recipe {
    
    //MARK: Properties
    var title: String
    var imageString: String?
    var id: Int?
    var imageData: Data?
    var isCreate: Bool
    var isFavorite: Bool
    var ingredients: [Ingredient]
    var time: Int
    var serving: Int
    var instruction: String
}

//MARK: - Ingredient
struct Ingredient {
    var name: String
    var quantity: Float
    var unit: String
}



