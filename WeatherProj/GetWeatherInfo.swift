//
//  WeatherInfo.swift
//  WeatherProj
//
//  Created by 최대성 on 6/21/24.
//

import Foundation
import Alamofire

class GetWeatherInfo {
    
    static var shared = GetWeatherInfo()
    private init() {}
    
    func callWeather(lat: Double, lon: Double, completionHandler: @escaping (Weather) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather?"
        let param: Parameters = [
            "APIKey" : APIKey().weatherKey,
            "lat" : "\(lat)",
            "lon" : "\(lon)",
            "units" : "metric",
            "lang" : "kr"
        ]
        AF.request(url, parameters: param).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case .success(let value):
//                self.showWeather(data: value)
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
}
