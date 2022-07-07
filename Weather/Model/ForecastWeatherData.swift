//
//  ForecastWeatherData.swift
//  Weather
//
//  Created by Steven Sullivan on 7/2/22.
//

import Foundation

struct ForecastResponse: Decodable {
    let list: [ListItem]
}

struct ListItem: Decodable {
    let dt_txt: String
    let main: MainForecastAPI
    let weather: [WeatherForecastAPI]
}

struct MainForecastAPI: Decodable {
    let temp: Double
}

struct WeatherForecastAPI: Decodable {
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case iconName = "main"
    }
}
