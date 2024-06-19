//
//  ViewController.swift
//  WeatherProj
//
//  Created by 최대성 on 6/19/24.
//

import UIKit
import Alamofire


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        callWeather()
    }
    
    
    func callWeather() {
        
        let url = "https://api.openweathermap.org/data/2.5/weather?"
        
        let param: Parameters = [
            "APIKey" : APIKey().weatherKey,
            "lat" : "37.5166",
            "lon" : "126.8915",
            "units" : "metric",
            "lang" : "kr"
        ]
        
        AF.request(url, parameters: param).responseString { response in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
        
    }


}

