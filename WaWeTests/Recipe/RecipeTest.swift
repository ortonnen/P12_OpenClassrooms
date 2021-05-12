//
//  RecipeTest.swift
//  WaweTests
//
//  Created by Nathalie Simonnet on 13/01/2021.
//

import XCTest
@testable import WaWe

class RecipeTest: XCTestCase {
    
    //MARK: - RecipeServices
    
    func testGetRecipeShouldPostFailedCallback() {
        
        let recipeService = RecipeService(
            recipeSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error),
            informationSession: URLSessionFake(data:nil,response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipeService.getRecipes(for: "pasta", withParameters: "pasta", cuisine: "gluten", diet: "greek", typeOfMeal: "main course") { (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("test GetRecipe Should Post Failed Callback failed")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(error)
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfNoData() {
        
        let recipeService = RecipeService(
            recipeSession: URLSessionFake(data: nil, response: nil, error: nil),
            informationSession: URLSessionFake(data:nil,response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipeService.getRecipes(for: "pasta", withParameters: "pasta", cuisine: "gluten", diet: "greek", typeOfMeal: "main course") { (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("test GetRecipe Should Post Failed Callback If NoData failed")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(error)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfIncorrectResponse() {
        
        let recipeService = RecipeService(
            recipeSession: URLSessionFake(data: FakeResponseData.recipeCorrectData, response: FakeResponseData.responseKO, error: nil),
            informationSession: URLSessionFake(data:nil,response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipeService.getRecipes(for: "pasta", withParameters: "pasta", cuisine: "gluten", diet: "greek", typeOfMeal: "main course") { (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("test GetRecipe Should Post Failed Callback If Incorrect Response failed")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(error)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfIncorrectData() {
        
        let recipeService = RecipeService(
            recipeSession: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil),
            informationSession: URLSessionFake(data:nil,response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipeService.getRecipes(for: "pasta", withParameters: "pasta", cuisine: "gluten", diet: "greek", typeOfMeal: "main course") { (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("test GetRecipe Should Post Failed Callback If IncorrectData failed")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(error)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeInformationShouldPostFailedCallback() {
        
        let recipeService = RecipeService(
            recipeSession: URLSessionFake(data: nil, response: nil, error: nil),
            informationSession: URLSessionFake(data:nil,response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipesInformation(for: "663659"){ (result) in
            guard case .failure(let error) = result else {
                XCTFail("test GetRecipe Should Post Failed Callback failed")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(error)
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testGetInformationShouldPostFailedIfNoData() {
        
        let recipeService = RecipeService(
            recipeSession: URLSessionFake(data: nil, response: nil, error: nil),
            informationSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipesInformation(for: "663659"){ (result) in
            guard case .failure(let error) = result else {
                XCTFail("test GetRecipe Should Post Failed Callback If NoData failed")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(error)
        
        }
                wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetInformationShouldPostFailedIfIncorrectResponse() {
        
        let recipeService = RecipeService(
            recipeSession: URLSessionFake(data: nil, response: nil, error: nil),
            informationSession: URLSessionFake(data: FakeResponseData.recipeInformationCorrectData ,response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipesInformation(for: "663659"){ (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("test GetRecipe Should Post Failed Callback If IncorrectData failed")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(error)
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeInformationShouldPostFailedCallbackIfIncorrectData() {
        
        let recipeService = RecipeService(
            recipeSession: URLSessionFake(data: nil, response: nil, error: nil),
            informationSession: URLSessionFake(data:FakeResponseData.incorrectData,response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipesInformation(for: "663659"){ (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("test GetRecipe Should Post Failed Callback If IncorrectData failed")
                return
            }
            
            expectation.fulfill()
            XCTAssertNotNil(error)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostSuccessCallBackIfNoErrorAndCorrectData() {
        let recipeService = RecipeService(
            recipeSession: URLSessionFake(data: FakeResponseData.recipeCorrectData, response: FakeResponseData.responseOK, error: nil),
            informationSession: URLSessionFake(data:nil ,response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipes(for:"pasta", withParameters: "pasta", cuisine: "gluten", diet: "greek", typeOfMeal: "main course") { (result) in
            
            guard case .success(let success) = result else {
                XCTFail("test GetRecipe Should Post Success CallBack If No Error And CorrectData failed")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(success)
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeInformationShouldPostSuccessCallBackIfNoErrorAndCorrectData() {
        let recipeService = RecipeService(
            recipeSession: URLSessionFake(data: nil, response: nil, error: nil),
            informationSession: URLSessionFake(data:FakeResponseData.recipeInformationCorrectData,response: FakeResponseData.responseOK, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipesInformation(for: "663659"){ (result) in
            
            guard case .success(let success) = result else {
                XCTFail("test GetRecipe Should Post Success CallBack If No Error And CorrectData failed")
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(success)
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
