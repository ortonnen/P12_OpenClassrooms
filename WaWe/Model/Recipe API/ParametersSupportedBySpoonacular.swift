//
//  ParametersSupportedBySpoonacular.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 25/03/2021.
//

import Foundation
struct SpoonacularParameters {
    ///A list of cuisines supported by Spoonacular
    var cuisines = ["African",
    "American",
    "British",
    "Chinese",
    "French",
    "German",
    "Greek",
    "Indian",
    "Italian",
    "Japanese",
    "Korean",
    "Mexican",
    "Nordic",
    "Spanish",
    "Thai",
    "Vietnamese"]
    
    ///A list of diets supported by Spoonacular
    var diets = ["Gluten Free",
    "Vegetarian",
    "Vegan"]
    
    ///A list of intolerances supported by Spoonacular
    var intolerances = [
    "Egg",
    "Gluten",
    "Peanut",
    "Seafood",
    "Sesame",
    "Soy",
    "Dairy"]

    ///A list of meal types supported by Spoonacular
    var mealTypesEntree = [
    "appetizer",
    "salad",
    "bread",
    "soup",
    "beverage",
    "drink"]
    
    var mealTypesMainDish = [
    "main course",
    "side dish",
    "marinade",
    "fingerfood",
    "snack"]
    
    var mealTypesDessert = [
    "dessert",
    "breakfast"]
}
