//
//  PassingDataProtocol.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 30/03/2021.
//
import UIKit
import Foundation

//MARK: Protocol
protocol PassingDataDelegateProtocol: UIViewController {
    func updateData(for dietArray: [String], intoleranceArray: [String], cuisineArray: [String], mealArray: [String])
    func updateStringData(for String: String)
    func updateRecipeData(for: Recipe)
}

//MARK: Extension Protocol
extension PassingDataDelegateProtocol {
    func updateStringData(for String: String) {}
    func updateData(for dietArray: [String], intoleranceArray: [String], cuisineArray: [String], mealArray: [String]) {}
    func updateRecipeData(for: Recipe) {}
}
