//
//  WeatherInfo.swift
//  WeatherProj
//
//  Created by 최대성 on 6/19/24.
//

import Foundation

struct Sys {
    let type, id, sunrise, sunset: Int
    let country: String
    
}

struct CloudsInfo {
    let all: Int
}

struct WindInfo {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct WeatherInfo {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    
}

struct TodayWeather {
    let id: Int
    let main: String
    let description: String
    let icon: String
}


struct Weather {
    let coord: [Int]
    let weather : [TodayWeather]
    let base: String
    let main: [WeatherInfo]
    let visibility: Int
    let wind: [WindInfo]
    let clouds: [CloudsInfo]
    let dt: Int
    let sys: [Sys]
    let name: String
}
