//
//  WeatherService.swift
//  Weather
//
//  Created by Steven Sullivan on 6/30/22.
//

import CoreLocation
import Foundation

public final class WeatherService: NSObject {
    private let locationManager = CLLocationManager()
    private let API_KEY = "33d8d14a00b06540ae4a7ff4c51204ff"
    private var completionHandler: ((Weather) -> Void)?
    
//    func initLocale() -> Unit {
//        let userLocale = Unit(name: userMeasurementSystem[0], suffix: userMeasurementSystem[1])
//        return userLocale
//    }
//
    var userMeasurementSystem: [String] {
        if Locale.current.usesMetricSystem {
            return ["metric", "°C"]
        } else {
            return ["imperial", "°F"]
        }
    }
   
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler: ((Weather) -> Void)?) {
        self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=\(userMeasurementSystem[0])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            print("pur")
            if let response = try? JSONDecoder().decode(Response.self, from: data) {
                print("purple")
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
    }
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}
