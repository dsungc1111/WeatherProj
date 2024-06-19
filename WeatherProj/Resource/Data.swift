//
//  Data.swift
//  WeatherProj
//
//  Created by 최대성 on 6/19/24.
//

import Foundation


struct Data {
    static var dateFormatter = DateFormatter()
//    static var today: Weather?
    static var lat: Double = 0.0
    static var lon: Double = 0.0
    static var aa: String = ""
    static var location: String = ""
    
    static func getDate() -> String {
        let toString = Data.dateFormatter
        toString.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        let convertNowStr = toString.string(from: Date())
        return convertNowStr
    }
}
