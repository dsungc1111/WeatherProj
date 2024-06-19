//
//  ConfigueLabel.swift
//  WeatherProj
//
//  Created by 최대성 on 6/20/24.
//

import UIKit

class ConfigueLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel() {
        textColor = .white
        textAlignment = .center
    }
    
}
