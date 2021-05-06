//
//  TranslateServices.swift
//  Wawe
//
//  Created by Nathalie Simonnet on 05/01/2021.
//

import Foundation
//MARK: - Enum mode to Error
enum TranslationError: Error {
    case dataError
    case responseError
    case translationError
    case codableError
}

//MARK: - Enum mode to use API Translation
enum TranslationMode {
    case detectLanguage
    case translate
    
    //Methodes
    func getURL() -> URL {
        var urlString = URL(string: "")
        
        switch self {
        case .detectLanguage:
            urlString = URL(string:"https://translation.googleapis.com/language/translate/v2/detect")!
            
        case .translate:
            urlString = URL(string:"https://translation.googleapis.com/language/translate/v2")!
        }
        return urlString!
    }
}

//MARK: Translation Services
class TranslationService {
    
    static var shared = TranslationService()
    private init() {}
    
    // Properties
    
    private let apiKey = ApiKey.translateApiKey
    
    private var translationSession = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    
    init(translationSession: URLSession){
        self.translationSession = translationSession
    }
    
    // Methode
    private func createTranslationRequest(for translationMode: TranslationMode, use parameters:[String: String]) -> URLComponents {
        var component = URLComponents(url: translationMode.getURL(), resolvingAgainstBaseURL: true)
        
        component?.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            component?.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return component!
    }
}
//MARK: - Translate
extension TranslationService {
    
    /// methode to translate
    func getTranslate(from originalLangue: String, to desiredLanguage: String, for text: String, callback: @escaping(Result<Translate, TranslationError>) -> Void) {
        
        var parameters = [String: String]()
        parameters["key"] = apiKey
        parameters["q"] = text
        parameters["target"] = desiredLanguage
        parameters["source"] = originalLangue
        let request = createTranslationRequest(for: .translate, use: parameters)
        guard let urlRequest = request.url else {
            return
        }
        
        task?.cancel()
        task = translationSession.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data, error == nil else {
                callback(.failure(.dataError))
                return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                let responseStatusCodeError = try? JSONDecoder().decode(TranslationStatusCodeError.self, from: data)
                callback(.failure(.responseError))
                print(responseStatusCodeError ?? "error translate status code")
                return
            }
            guard let translation = try? JSONDecoder().decode(Translate.self, from: data) else {
                callback(.failure(.translationError))
                return
            }
            callback(.success(translation))
            
        }
        task?.resume()
    }
}
