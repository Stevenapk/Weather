//
//  ForecastService.swift
//  Weather
//
//  Created by Steven Sullivan on 7/2/22.
//

import Foundation
import CoreLocation

public final class ForecastService: NSObject {
    public let locationManager = CLLocationManager()
    public let API_KEY = "33d8d14a00b06540ae4a7ff4c51204ff"
    private var completionHandler: ((ForecastWeather) -> Void)?
    var userCoordinates = CLLocationCoordinate2D()
   
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadForecastWeatherData(_ completionHandler: ((ForecastWeather) -> Void)?) {
        let previousCoordinates = userCoordinates
        self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //updates weather forecast in the case the user hasn't relocated
        if userCoordinates.latitude == previousCoordinates.latitude && userCoordinates.longitude == userCoordinates.longitude {
            makeDataRequest(forCoordinates: previousCoordinates)
        } else { return }
    }
    
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=\(WeatherService.instance.userMeasSystem.name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            if let response = try? JSONDecoder().decode(ForecastResponse.self, from: data) {
                self.completionHandler?(ForecastWeather(response: response))
            } else {
            }
        }.resume()
    }
}

extension ForecastService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userCoordinates = location.coordinate
        makeDataRequest(forCoordinates: location.coordinate)
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}
