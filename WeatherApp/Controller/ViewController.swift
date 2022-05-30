//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mac on 12/05/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

let weatherDataManager = WeatherManager()
let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchBoxText: UITextField!
    @IBOutlet weak var temprature: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        searchBoxText.delegate = self
        searchBoxText.placeholder = "Enter City Name"
        }
    
    
    func updateWheather(weather : WeatherModel)
    {
        self.temprature.text = weather.tempratureString
        self.subtitle.text = "Current temprature of \(weather.name)"
        self.weatherConditionImage.image = UIImage(systemName: weather.conditionName)
        
    }

    @IBAction func searchButton(_ sender: Any)
    {
        if searchBoxText.text != ""
        {
        weatherDataManager.getWeather(cityName: searchBoxText.text!) {  (weather) in
            print(weather)
            DispatchQueue.main.async {
                self.updateWheather(weather: weather)
            }
        }
        }
        else
        {
            searchBoxText.placeholder = "Enter City Name"
        }
        
    }
    
    @IBAction func currentLocationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            manager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherDataManager.fetchWeather(latitude: lat, longitude: lon) { (weather) in
                DispatchQueue.main.async {
                    self.updateWheather(weather: weather)
                }
                }
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    }

