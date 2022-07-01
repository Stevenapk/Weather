//
//  WeatherManager.swift
//  Weather
//
//  Created by Steven Sullivan on 7/1/22.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weather)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=33d8d14a00b06540ae4a7ff4c51204ff&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather() {
        let urlString = "\(weatherURL)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            print("why")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print("why \(error?.localizedDescription)")
                    return
                }
                if let safeData = data {
                    print("why that's funny")
                    if let weather = self.parseJSON(safeData) {
                        print("why that's even funnier")
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> Weather? {
        let decoder = JSONDecoder()
        
        do {
            print("marionberry1")
            let decodedData = try decoder.decode(Response.self, from: weatherData)
            print("marionberry2")
            let temp = decodedData.main.temp
            let weather = Weather(response: decodedData).temp
            print("marionberry")
            return Weather(response: decodedData)
        }
        catch {
            delegate?.didFailWithError(error: error)
            print("apples\(error)")
            return nil
        }
    }
}
