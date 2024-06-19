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

    let weather: [Weather] = []
    let myLocalManager = CLLocationManager()
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    let backgroundImage = {
        let image = UIImageView()
        return image
    }()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout())
    
       static func CollectionViewLayout() -> UICollectionViewLayout{
           let layout = UICollectionViewFlowLayout()
           let sectionSpacing: CGFloat = 10
           let cellSpacing: CGFloat = 10
           let width = UIScreen.main.bounds.width - sectionSpacing
           layout.itemSize = CGSize(width: width - 20, height: width + 120 )
           layout.scrollDirection = .horizontal
           layout.minimumInteritemSpacing = cellSpacing
           layout.minimumLineSpacing = cellSpacing
           layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
           return layout
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dataHandling()
        configureHierarchy()
        configureLayout()
        checkDeviceLocationAuthorization()
    }
    func dataHandling() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        myLocalManager.delegate = self
    }
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "날씨요정? IT'S ME."
    }
    func configureHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(collectionView)
    }
    func configureLayout() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
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
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension ViewController {
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
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkDeviceLocationAuthorization()
        if let coordinate = locations.last?.coordinate {
            lat = coordinate.latitude
            lon = coordinate.longitude
            callWeather(lat: lat, lon: lon)
        }
        myLocalManager.stopUpdatingLocation()
    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
//        print(#function)
//    }
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print("iOS14+")
//    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell else { return WeatherCollectionViewCell() }
        
        
        return cell
    }
    
    
}
