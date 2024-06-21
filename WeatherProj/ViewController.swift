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
        let label = ConfigueLabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        return label
    }()
    let dateLabel = {
        let label = ConfigueLabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    lazy var temperatureLabel = {
        let label = ConfigueLabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        return label
    }()
    let otherFactors = ConfigueLabel()
    let weatherImage = UIImageView()
    let weatherLabel = {
        let label = ConfigueLabel()
        label.numberOfLines = 2
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dataHandling()
        configureHierarchy()
        configureLayout()
        checkDeviceLocationAuthorization()
        GetWeatherInfo.shared.callWeather(lat: Data.lat, lon: Data.lon) { result in
            self.showWeather(data: result)
        }
        dateLabel.text = Data.getDate()
    }
    func dataHandling() {
        myLocalManager.delegate = self
    }
    func configureUI() { //   rgb(113,108,217)    rgb(97,97,161)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        view.backgroundColor = UIColor(red: 97/255, green: 97/255, blue: 161/255, alpha: 1)
    }
    func configureHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(locationLabel)
        view.addSubview(dateLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(otherFactors)
        view.addSubview(weatherImage)
        view.addSubview(weatherLabel)
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
        weatherLabel.snp.makeConstraints { make in
            make.centerY.equalTo(weatherImage.snp.centerY)
            make.leading.equalTo(weatherImage.snp.trailing)
        }
    }
    func showWeather(data: Weather?) {
        self.temperatureLabel.text = "\(data?.main.temp ?? 0.0)℃"
        self.otherFactors.text = "습도 : \(data?.main.humidity ?? 0)% | 풍속 : \(data?.wind.speed ?? 0.0)m/s"
        let url = URL(string: "https://openweathermap.org/img/wn/\(data?.weather[0].icon ?? "04d")@2x.png")
        self.weatherImage.kf.setImage(with: url)
        self.weatherLabel.text = "TODAY\n\(data?.weather[0].description ?? "날씨")"
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
    
    
    func locationSettingAlert() {
        let alert = UIAlertController(title: "권한 허용 거부됨!", message: "위치 권한 허용이 필요합니다", preferredStyle: .alert)
    
        let settingPage = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            }
        }
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(settingPage)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
    
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkDeviceLocationAuthorization()
        if let coordinate = locations.last?.coordinate {
            Data.lat = coordinate.latitude
            Data.lon = coordinate.longitude
            GetWeatherInfo.shared.callWeather(lat: Data.lat, lon: Data.lon) { result in
                self.showWeather(data: result)
            }
            getLocation(lat: Data.lat, lon: Data.lon)
        }
        myLocalManager.stopUpdatingLocation()
    }
    func getLocation(lat: Double, lon: Double) {
        let findLocation = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let name: String = address.last?.name { Data.location = name }
                self.locationLabel.text = Data.location
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .denied:
                locationSettingAlert()
            case .authorizedWhenInUse:
                myLocalManager.startUpdatingLocation()
            default:
                break
            }
        }
}

