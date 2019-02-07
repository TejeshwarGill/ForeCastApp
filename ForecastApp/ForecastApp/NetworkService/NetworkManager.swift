//
//  NetworkManager.swift
//  ForecastApp
//
//  Created by  Developer on 07/02/2019.
//  Copyright © 2019 Developer Inc. All rights reserved.
//

import Foundation

class NetworkManager {
    
    func getWeatherData(lat: String, lon: String, completion: ((Result<WeatherStruct>) -> Void)?) -> () {
        
        var urlComponents = getBaseComponent()
        let queryItemLan = URLQueryItem(name: "lat", value: lat)
        let queryItemLon = URLQueryItem(name: "lon", value:lon)
        
        urlComponents.queryItems?.append(queryItemLan)
        urlComponents.queryItems?.append(queryItemLon)
        loadItems(with: urlComponents, completion: completion)
    }
    //https://samples.openweathermap.org/data/2.5/forecast?q=München,DE&appid=b6907d289e10d714a6e88b30761fae22
    func getWeatherDataByCity(city: String, completion: ((Result<WeatherStruct>) -> Void)?) {
        var urlComponents = getBaseComponent()
        let queryItemCity = URLQueryItem(name: "q", value: city)
        urlComponents.queryItems?.append(queryItemCity)
        loadItems(with: urlComponents, completion: completion)
    }
    
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    
    private let appId = "ca9db572fae974e04fc67268c81830a9"
    private let apiHost = "api.openweathermap.org"
    private let apiPath = "/data/2.5/forecast"
    
    private func getBaseComponent() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = apiHost
        urlComponents.path = apiPath
        let queryItemToken = URLQueryItem(name: "appid", value: appId)
        urlComponents.queryItems = [ queryItemToken]
        return urlComponents
    }
   
    private enum HTTP_Methods {
        static let get = "GET"
        static let post = "POST"
        static let put = "PUT"
        static let delete = "DELETE"
        static let patch = "PATCH"
    }
    
    private func loadItems<T: Decodable>(with components: URLComponents, completion: ((Result<T>) -> Void)?) {
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTP_Methods.get
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("ERROR: - \(String(describing: responseError))"); return}
            guard let jsonData = responseData else { return }
            print(jsonData)
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: jsonData)
                completion?(.success(decodedData))
            } catch {
                completion?(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}





