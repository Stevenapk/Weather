//
//  CurrentWeatherData.swift
//  Weather
//
//  Created by Steven Sullivan on 6/30/22.
//

import Foundation

struct Response: Decodable {
    let name: String
    let main: MainAPI
    let weather: [WeatherAPI]
}

struct MainAPI: Decodable {
    let temp: Double
}

struct WeatherAPI: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
}
