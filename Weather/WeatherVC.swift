//
//  ViewController.swift
//  Weather
//
//  Created by Steven Sullivan on 6/29/22.
//

import UIKit

class WeatherVC: UIViewController{
    
//    func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weather) {
//        DispatchQueue.main.async {
//            self.currentTemp.text = "\(weather.temp)\(self.tempSuffix)"
//            self.currentLocationLbl.text = weather.city
//            self.currentWeatherConditionsLbl.text = weather.description
//        }
//    }
//
//    func didFailWithError(error: Error) {
//        print(error)
//    }
//    
//    var weatherManger = WeatherManager()
    
    lazy var colorSelection = blueGradient
    
    @IBOutlet weak var currentDateLbl: UILabel!
    
    @IBOutlet weak var currentLocationLbl: UILabel!
    @IBOutlet weak var currentWeatherConditionsLbl: UILabel!
    
    @IBOutlet weak var currentWeatherConditionsImageView: UIImageView!
    @IBOutlet weak var currentTemp: UILabel!
    
    @IBOutlet weak var todayLbl: UILabel!
    @IBOutlet weak var thisWeekLbl: UILabel!
    
    @IBOutlet weak var backgroundGradientView: UIView!

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
    
    
    
    @IBAction func colorBtnTapped(_ sender: Any) {
        switch colorSelection {
        case blueGradient:
            colorSelection = greenGradient
        case greenGradient:
            colorSelection = redGradient
        case redGradient:
            colorSelection = blueGradient
        default:
            colorSelection = redGradient
        }
        initGradient()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
               initGradient()
//        weatherManger.delegate = self
//        weatherManger.fetchWeather()
       refresh()
        
    }

    override var shouldAutorotate: Bool {
               return false
    }
    
    public let weatherService = WeatherService()
  
    public func refresh() {
        let format = DateFormatter()
        format.dateStyle = .long
        
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.currentDateLbl.text = format.string(from: Date())
                self.currentLocationLbl.text = weather.city
                self.currentTemp.text = "\(weather.temp)\(self.weatherService.userMeasurementSystem[1])"
                self.currentWeatherConditionsLbl.text = weather.description.capitalized
                self.currentWeatherConditionsImageView.image = UIImage(named: weather.iconName)
                
            }
            
        }
    }
}

extension WeatherVC {
    var redGradient: [CGColor] { [ #colorLiteral(red: 0.8952698708, green: 0.6801822782, blue: 0.4841313362, alpha: 1).cgColor, #colorLiteral(red: 0.7562651038, green: 0.3155059218, blue: 0.4367308319, alpha: 1).cgColor ] }
    var blueGradient: [CGColor] { [ #colorLiteral(red: 0.4388540089, green: 0.6567905545, blue: 0.7945474982, alpha: 1).cgColor, #colorLiteral(red: 0.2357676029, green: 0.2999535799, blue: 0.5365664363, alpha: 1).cgColor ] }
    var greenGradient: [CGColor] { [ #colorLiteral(red: 0.7759577632, green: 0.8280290365, blue: 0.504925549, alpha: 1).cgColor, #colorLiteral(red: 0.4166629314, green: 0.5409178138, blue: 0.2852984071, alpha: 1).cgColor ] }
    
    func initGradient() {
        let gradientLayer = CAGradientLayer()
    
        gradientLayer.startPoint = CGPoint(x: 0.30, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.70, y: 1)
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colorSelection
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
    }
}


