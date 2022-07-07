//
//  MainView.swift
//  Weather
//
//  Created by Steven Sullivan on 7/1/22.
//

import UIKit

class MainView: UIView {
    
    @IBOutlet weak var currentDateLbl: UILabel!
    
    @IBOutlet weak var currentLocationLbl: UILabel!
    @IBOutlet weak var currentWeatherConditionsLbl: UILabel!
    
    @IBOutlet weak var currentWeatherConditionsImageView: UIImageView!
    @IBOutlet weak var currentTempLbl: UILabel!
    
    @IBOutlet weak var todayBtn: UIButton!
    @IBOutlet weak var thisWeekBtn: UIButton!
    
    @IBAction func didTapTodayBtn(_ sender: Any) {
        isTodaySelected = true
    }
    @IBAction func didTapThisWeekBtn(_ sender: Any) {
        isTodaySelected = false
    }
    
    @IBOutlet weak var timeDateSlot1: UILabel!
    @IBOutlet weak var timeDateSlot2: UILabel!
    @IBOutlet weak var timeDateSlot3: UILabel!
    @IBOutlet weak var timeDateSlot4: UILabel!
    @IBOutlet weak var timeDateSlot5: UILabel!
    
    @IBOutlet weak var weatherImg1: UIImageView!
    @IBOutlet weak var weatherImg2: UIImageView!
    @IBOutlet weak var weatherImg3: UIImageView!
    @IBOutlet weak var weatherImg4: UIImageView!
    @IBOutlet weak var weatherImg5: UIImageView!
    
    @IBOutlet weak var temp1: UILabel!
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var temp3: UILabel!
    @IBOutlet weak var temp4: UILabel!
    @IBOutlet weak var temp5: UILabel!

    public let weatherService = WeatherService()
    public let forecastService = ForecastService()
    var userTempNotation: String = WeatherService.instance.userMeasSystem.tempSuffix
    
    var isTodaySelected = true {
        didSet {
            todayBtn.isSelected = isTodaySelected
            thisWeekBtn.isSelected = !isTodaySelected
            refreshForecast()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isTodaySelected = true
        refreshCurrentWeather()
        refreshForecast()
    }
  
    public func refreshCurrentWeather() {
        let format = DateFormatter()
        format.dateStyle = .long
        
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.currentDateLbl.text = format.string(from: Date())
                self.currentLocationLbl.text = weather.city
                self.currentTempLbl.text =
                " \(weather.temp)\(self.userTempNotation)"
                self.currentWeatherConditionsLbl.text = weather.description.capitalized
                self.currentWeatherConditionsImageView.image = UIImage(named: weather.iconName)
            }
        }
    }
    
    public func refreshForecast() {
        self.forecastService.loadForecastWeatherData { weather in
            DispatchQueue.main.async { [self] in
                
                let dailyForecastArray = self.createDailyForecasts(list: weather.list)
                
                if self.isTodaySelected == true {
                    self.timeDateSlot1.text = self.convertToTime(date: weather.time1)
                    self.timeDateSlot2.text = self.convertToTime(date: weather.time2)
                    self.timeDateSlot3.text = self.convertToTime(date: weather.time3)
                    self.timeDateSlot4.text = self.convertToTime(date: weather.time4)
                    self.timeDateSlot5.text = self.convertToTime(date: weather.time5)

                    self.temp1.text = "\(weather.hourlyTemp1)\(userTempNotation)"
                    self.temp2.text = "\(weather.hourlyTemp2)\(userTempNotation)"
                    self.temp3.text = "\(weather.hourlyTemp3)\(userTempNotation)"
                    self.temp4.text = "\(weather.hourlyTemp4)\(userTempNotation)"
                    self.temp5.text = "\(weather.hourlyTemp5)\(userTempNotation)"

                    self.weatherImg1.image = UIImage(named: weather.hourlyImg1)
                    self.weatherImg2.image = UIImage(named: weather.hourlyImg2)
                    self.weatherImg3.image = UIImage(named: weather.hourlyImg3)
                    self.weatherImg4.image = UIImage(named: weather.hourlyImg4)
                    self.weatherImg5.image = UIImage(named: weather.hourlyImg5)
                    
                } else if self.isTodaySelected == false {
                    
                    self.timeDateSlot1.text = self.convertToMonthDay(date: dailyForecastArray[0].dt_txt)
                    self.timeDateSlot2.text = self.convertToMonthDay(date: dailyForecastArray[1].dt_txt)
                    self.timeDateSlot3.text = self.convertToMonthDay(date: dailyForecastArray[2].dt_txt)
                    self.timeDateSlot4.text = self.convertToMonthDay(date: dailyForecastArray[3].dt_txt)
                    self.timeDateSlot5.text = self.convertToMonthDay(date: dailyForecastArray[4].dt_txt)

                    self.temp1.text = "\(Int(dailyForecastArray[0].main.temp))\(userTempNotation)"
                    self.temp2.text = "\(Int(dailyForecastArray[1].main.temp))\(userTempNotation)"
                    self.temp3.text = "\(Int(dailyForecastArray[2].main.temp))\(userTempNotation)"
                    self.temp4.text = "\(Int(dailyForecastArray[3].main.temp))\(userTempNotation)"
                    self.temp5.text = "\(Int(dailyForecastArray[4].main.temp))\(userTempNotation)"

                    self.weatherImg1.image = UIImage(named: dailyForecastArray[0].weather[0].iconName)
                    self.weatherImg2.image = UIImage(named: dailyForecastArray[1].weather[0].iconName)
                    self.weatherImg3.image = UIImage(named: dailyForecastArray[2].weather[0].iconName)
                    self.weatherImg4.image = UIImage(named: dailyForecastArray[3].weather[0].iconName)
                    self.weatherImg5.image = UIImage(named: dailyForecastArray[4].weather[0].iconName)
                }
            }
        }
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
    
    func convertToMonthDay(date: String) -> String {
            let date = stringToDate(dt_txt: date)
            let monthDayFormatter = DateFormatter()
            monthDayFormatter.dateFormat = "MM/dd"
            let monthDay = monthDayFormatter.string(from: date)
            return monthDay
        }
    func createDailyForecasts(list: [ListItem]) -> [ListItem] {
        var dailyForecastArray: [ListItem] = []
        for listItem in list {
            if self.convertToTime(date: listItem.dt_txt) == "18:00" {
                dailyForecastArray.append(listItem)
            }
        }
        if dailyForecastArray.count == 4 {
            dailyForecastArray.insert(list[0], at: 0)
        }
        return dailyForecastArray
    }
}
