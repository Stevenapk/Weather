//
//  WeatherService.swift
//  Weather
//
//  Created by Steven Sullivan on 6/30/22.
//

import CoreLocation
import UIKit
import Foundation

public final class WeatherService: NSObject {
    static let instance = WeatherService()
    public let locationManager = CLLocationManager()
    public let API_KEY = "33d8d14a00b06540ae4a7ff4c51204ff"
    private var completionHandler: ((Weather) -> Void)?
    
    var userMeasSystem: MeasurementSystem {
        if Locale.current.usesMetricSystem {
            return MeasurementSystem(name: "metric", tempSuffix: "°C")
        } else {
            return MeasurementSystem(name: "imperial", tempSuffix: "°F")
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
    
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=\(userMeasSystem.name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            if let response = try? JSONDecoder().decode(Response.self, from: data) {
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
