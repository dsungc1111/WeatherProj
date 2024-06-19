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
import Kingfisher
//1
import CoreLocation


class ViewController: UIViewController {

    let myLocalManager = CLLocationManager()
    
    let backgroundImage = {
        let image = UIImageView()
        image.image = UIImage(named: "라라랜드")
        image.contentMode = .scaleAspectFill
        return image
    }()
    let locationLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    let dateLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    lazy var temperatureLabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 50)
        label.textAlignment = .center
//        label.text = "\(Data.today?.main.temp ?? 0.0)℃"
        return label
    }()
    let otherFactors = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    let weatherImage = {
       let image = UIImageView()
        return image
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dataHandling()
        configureHierarchy()
        configureLayout()
        checkDeviceLocationAuthorization()
        callWeather(lat: Data.lat, lon: Data.lon)
        getLocation()
        locationLabel.text = Data.location
        dateLabel.text = getDate()
    }
    
    func getLocation() {
        let findLocation = CLLocation(latitude: Data.lat, longitude: Data.lon)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let name: String = address.last?.name { Data.location = name }
            }
        })
    }
    func dataHandling() {
        myLocalManager.delegate = self
    }
    func configureUI() { //   rgb(113,108,217)    rgb(97,97,161)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.backgroundColor = UIColor(red: 97/255, green: 97/255, blue: 161/255, alpha: 1)
        navigationItem.title = "날씨요정? IT'S ME."
    }
    func configureHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(locationLabel)
        view.addSubview(dateLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(otherFactors)
        view.addSubview(weatherImage)
    }
    func configureLayout() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        otherFactors.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(otherFactors.snp.bottom).offset(15)
            make.centerX.equalTo(view)
            make.size.equalTo(100)
        }
    }
    
    func getDate() -> String {
        let toString = Data.dateFormatter
        toString.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        let convertNowStr = toString.string(from: Date())
        return convertNowStr
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
                Data.today = value
                self.temperatureLabel.text = "\(Data.today?.main.temp ?? 0.0)℃"
                self.otherFactors.text = "습도 : \(Data.today?.main.humidity ?? 0)% | 풍속 : \(Data.today?.wind.speed ?? 0.0)m/s"
                
                let url = URL(string: "https://openweathermap.org/img/wn/\(Data.today?.weather[0].icon ?? "04d")@2x.png")
                self.weatherImage.kf.setImage(with: url)
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
            Data.lat = coordinate.latitude
            Data.lon = coordinate.longitude
            callWeather(lat: Data.lat, lon: Data.lon)
            
        }
        myLocalManager.stopUpdatingLocation()
    }
}

