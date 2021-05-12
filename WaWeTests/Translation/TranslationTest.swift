//
//  TranslateTest.swift
//  WaweTests
//
//  Created by Nathalie Simonnet on 13/01/2021.
//

import XCTest
@testable import WaWe

class TranslationTest: XCTestCase {
    
    //MARK: TranslationServiceTest
    
    func testGetTranslationShouldPostFailedCallback() {
        
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslate(from: "fr", to: "en", for: "bonjour") { (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("test GetTranslation Should Post Failed Callback failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostFailedCallbackIfNoData() {
        
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslate(from: "fr", to: "en", for: "bonjour") { (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("test GetTranslation Should Post Failed Callback If NoData failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostFailedCallbackIfIncorrectResponse() {
        
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: FakeResponseData.translateCorrectData, response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslate(from: "fr", to: "en", for: "bonjour") { (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("test GetTranslation Should Post Failed Callback If Incorrect Response failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostFailedCallbackIfIncorrectData() {
        
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslate(from: "fr", to: "en", for: "bonjour") { (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("test GetRecipe Should Post Failed Callback If IncorrectData failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostSuccessCallBackIfNoErrorAndCorrectData() {
        
        let translationService = TranslationService(
            translationSession: URLSessionFake(data: FakeResponseData.translateCorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslate(from: "en", to: "fr", for: "hello") { (result) in
            
            guard case .success(let success) = result else {
                XCTFail("test GetTranslation Should Post Success CallBack If No Error And CorrectData failed")
                return
            }
            XCTAssertNotNil(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
