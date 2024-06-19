//
//  WeatherCollectionViewCell.swift
//  WeatherProj
//
//  Created by 최대성 on 6/19/24.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
