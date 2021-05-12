//
//  FakeResponseData.swift
//  WaweTests
//
//  Created by Nathalie Simonnet on 13/01/2021.
//

import Foundation

class FakeResponseData {
    // MARK: - Data

    static var translateCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "translation", withExtension: "json")!

        return try! Data(contentsOf: url)
    }

    static var detectLanguageCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "DetectedLanguage", withExtension: "json")!

        return try! Data(contentsOf: url)
    }

    static var recipeCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Recipe", withExtension: "json")!

        return try! Data(contentsOf: url)
    }
    
    static var recipeInformationCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "RecipeInformation", withExtension: "json")!

        return try! Data(contentsOf: url)
    }
    static let incorrectData = "error".data(using: .utf8)!

    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://google.com")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://google.com")!,
        statusCode: 500, httpVersion: nil, headerFields: nil)!

    // MARK: - Error
    class FakeError: Error {}
    static let error = FakeError()
}
