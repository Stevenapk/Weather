//
//  ForecastWeather.swift
//  Weather
//
//  Created by Steven Sullivan on 7/2/22.
//

import Foundation
import UIKit

public struct ForecastWeather {
    
    let time1: String
    let time2: String
    let time3: String
    let time4: String
    let time5: String
    
    let hourlyTemp1: String
    let hourlyTemp2: String
    let hourlyTemp3: String
    let hourlyTemp4: String
    let hourlyTemp5: String
    
    let hourlyImg1: String
    let hourlyImg2: String
    let hourlyImg3: String
    let hourlyImg4: String
    let hourlyImg5: String
    
    let list: [ListItem]
    
    init(response: ForecastResponse) {
        list = response.list

        time1 = response.list[0].dt_txt
        time2 = response.list[1].dt_txt
        time3 = response.list[2].dt_txt
        time4 = response.list[3].dt_txt
        time5 = response.list[4].dt_txt
        
        hourlyTemp1 = "\(Int(response.list[0].main.temp))"
        hourlyTemp2 = "\(Int(response.list[1].main.temp))"
        hourlyTemp3 = "\(Int(response.list[2].main.temp))"
        hourlyTemp4 = "\(Int(response.list[3].main.temp))"
        hourlyTemp5 = "\(Int(response.list[4].main.temp))"
        
        hourlyImg1 = "\(response.list[0].weather[0].iconName)"
        hourlyImg2 = "\(response.list[1].weather[0].iconName)"
        hourlyImg3 = "\(response.list[2].weather[0].iconName)"
        hourlyImg4 = "\(response.list[3].weather[0].iconName)"
        hourlyImg5 = "\(response.list[4].weather[0].iconName)"
        
    }

    func stringToDate(dt_txt: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dt_txt)!
        return date
    }

    func convertToTime(date: String) -> String {
            let date = stringToDate(dt_txt: date)
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let time = timeFormatter.string(from: date)
            return time
        }
}
