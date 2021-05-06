//
//  RecipeServices.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 05/01/2021.
//

import Foundation

//MARK: - Enum Error
enum RecipeError: Error {
    case dataError
    case responseError
    case statusCodeError
}

//MARK: - Recipe Service
class RecipeService {
    
    // Properties
    static var shared = RecipeService()
    private init() {}
    
    private var apiKey = ApiKey.spoonacularApiKey
    private var informationSession = URLSession(configuration: .default)
    private var recipeSession = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    
    init(recipeSession: URLSession, informationSession: URLSession){
        self.recipeSession = recipeSession
        self.informationSession = informationSession
    }
    
    //Methodes
    private func createRecipeRequest(with parameters: [String: String] ) -> URLComponents? {
        guard let searchRecipeURL = URL(string: "https://api.spoonacular.com/recipes/complexSearch") else {
            return nil
        }
        var component = URLComponents(url: searchRecipeURL, resolvingAgainstBaseURL: true)
        
        component?.queryItems = [URLQueryItem(name: "apiKey", value: apiKey),
                                 URLQueryItem(name: "number", value: "10"),
                                 URLQueryItem(name: "instructionsRequires-d", value: "true"),
                                 URLQueryItem(name: "ignorePantry", value: "true"),
                                 URLQueryItem(name: "limiteLicense", value: "true")]
        
        for (key, value) in parameters {
            component?.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return component!
    }
}

//MARK: - Get Recipe API
extension RecipeService {
    ///func to get recipes
    func getRecipes(for ingredients: String, withParameters intolerance: String?, cuisine: String?, diet: String?, typeOfMeal: String?, callback: @escaping (Result<Spoonacular, RecipeError>) -> Void) {
       
        var parameters = [String: String]()
        parameters["query"] = ingredients
        parameters["includeIngredients"] = ingredients
        parameters["diet"] = diet
        parameters["intolerance"] = intolerance
        parameters["cuisine"] = cuisine
        parameters["type"] = typeOfMeal
        
        let request = createRecipeRequest(with: parameters)
        guard let urlRequest = request?.url else {
            return
        }
        task?.cancel()
        task = recipeSession.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data, error == nil else {
                callback(.failure(.dataError))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300  else {
                callback(.failure(.statusCodeError))
                return
            }
            guard let recipe = try? JSONDecoder().decode(Spoonacular.self, from: data) else {
                callback(.failure(.responseError))
                return
            }
            callback(.success(recipe))
        }
        task?.resume()
    }
    ///func to get recipe Information
    func getRecipesInformation(for recipeId: String, callback: @escaping(Result<RecipeInformation,RecipeError>) -> Void) {
        guard let recipeInformationURL = URL(string:"https://api.spoonacular.com/recipes/\(recipeId)/information?apiKey=\(apiKey)") else {
            return
        }
        task?.cancel()
        task = informationSession.dataTask(with: recipeInformationURL) { (data, response, error) in
            
            guard let data = data, error == nil else {
                callback(.failure(.dataError))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                callback(.failure(.statusCodeError))
                return
            }
            guard let recipeDetail = try? JSONDecoder().decode(RecipeInformation.self, from: data) else {
                callback(.failure(.responseError))
                return
            }
            return callback(.success(recipeDetail))
        }
        task?.resume()
    }
}
