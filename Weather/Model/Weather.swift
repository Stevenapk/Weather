//
//  Weather.swift
//  Weather
//
//  Created by Steven Sullivan on 6/30/22.
//

import Foundation

public struct Weather {
    let city: String
    let temp: String
    let description: String
    let iconName: String
    
    init(response: Response) {
        city = response.name
        temp = "\(Int(response.main.temp))"
        description = response.weather.first?.iconName ?? ""
        iconName = response.weather.first?.iconName ?? ""
    }
}
