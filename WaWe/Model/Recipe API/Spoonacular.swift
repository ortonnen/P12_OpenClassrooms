//
//  Spoonacular.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 05/01/2021.
//

import Foundation
// MARK: - Spoonacular
struct Spoonacular: Decodable {
    let results: [ResultOfResearch]
    let offset, number, totalResults: Int
}

// MARK: - Result
struct ResultOfResearch: Decodable {
    let id: Int
    let title: String
    let image: String
}

// MARK: - RecipeInformation
struct RecipeInformation: Decodable {
    let id: Int?
    var title: String?
    var readyInMinutes: Int?
    var servings: Int?
    var image: String?
    var instructions: String?
    var extendedIngredients: [ExtendedIngredient]
}

// MARK: - ExtendedIngredient
struct ExtendedIngredient: Decodable {
    let id: Int
    var name: String
    let original: String
    var amount: Float
    var unit: String
}


