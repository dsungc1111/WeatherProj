//
//  WeatherCollectionViewCell.swift
//  WeatherProj
//
//  Created by 최대성 on 6/19/24.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    let backgroundImage = {
        let image = UIImageView()
        image.image = UIImage(named: "라라랜드")
        image.contentMode = .scaleToFill
        return image
    }()
    let locationLabel = {
        let label = UILabel()
        label.text = "문래동"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    let dateLabel = {
        let label = UILabel()
        label.text = "2024/06/19"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    let temperatureLabel = {
       let label = UILabel()
        label.text = "33℃ "
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func layoutSubviews() {
//        backgroundImage.layer.cornerRadius = 10
//    }
    func configureHierarchy() {
        contentView.addSubview(backgroundImage)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(temperatureLabel)
    }
    func configureLayout() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    
    
    func configureCell(data: IndexPath) {
        
        temperatureLabel.text = "\(Data.today?.main.temp ?? 0.0)℃"
        
        dateLabel.text = getDate()
    }
    
    func getDate() -> String {
        let toString = Data.dateFormatter
        toString.dateFormat = "yyyy년MM월dd일"
        let convertNowStr = toString.string(from: Date())
        return convertNowStr
    }
}
