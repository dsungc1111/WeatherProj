//
//  ViewController.swift
//  WeatherProj
//
//  Created by 최대성 on 6/19/24.
//

import UIKit
import Alamofire
import MapKit
import SnapKit
//1
import CoreLocation


class ViewController: UIViewController {

    let mapView = MKMapView()
    let weather: [Weather] = []
    let myLocalManager = CLLocationManager()
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocalManager.delegate = self
        view.backgroundColor = .white
        checkDeviceLocationAuthorization()
        configureHierarchy()
        configureLayout()
    }
    func configureHierarchy() {
        view.addSubview(mapView)
    }
    func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
    }
    
    func callWeather(lat: Double, lon: Double) {
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
                print(value.weather.description)
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension ViewController {
    // 5
    func checkDeviceLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization()
        } else {
            print("위치 불러오기 불가")
        }
    }
    func checkCurrentLocationAuthorization() {
        var status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = myLocalManager.authorizationStatus
        } else {
            status = myLocalManager.authorizationStatus
        }
        switch status {
        case .notDetermined:
            myLocalManager.desiredAccuracy = kCLLocationAccuracyBest
            myLocalManager.requestWhenInUseAuthorization()
            myLocalManager.startUpdatingLocation()
        case .denied:
            print("사용자가 얼럿 창에서 권한 거부함.")
        case .authorizedWhenInUse:
            myLocalManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkDeviceLocationAuthorization()
        print(#function)
        if let coordinate = locations.last?.coordinate {
            lat = coordinate.latitude
            lon = coordinate.longitude
            setRegionAndAnnotation(center: coordinate)
            callWeather(lat: lat, lon: lon)
        }
        myLocalManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("iOS14+")
    }
    
}
