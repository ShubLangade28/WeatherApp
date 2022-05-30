//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Mac on 12/05/22.
//https://api.openweathermap.org/data/2.5/weather?q=london,&appid=7e0d71aac401b3a1cd1687d3428edbe8&units=metric

import Foundation
import CoreLocation

class WeatherManager
{
    typealias WeatherDataPassingClosure = (WeatherModel)->()
    
    let urlString = "https://api.openweathermap.org/data/2.5/weather?&appid=7e0d71aac401b3a1cd1687d3428edbe8&units=metric"
    
    func getWeather(cityName : String, completionHandler : @escaping WeatherDataPassingClosure)
    {
        let weatherURL = "\(urlString)&q=\(cityName)"
        performRequest(with: weatherURL) { (weather) in
        completionHandler(weather)
        }
    }
    func fetchWeather(latitude : CLLocationDegrees, longitude : CLLocationDegrees, completionHandler : @escaping WeatherDataPassingClosure){
        let weatherURL = "\(urlString)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: weatherURL) { (weather) in
        completionHandler(weather)
        }
    }
    
    func performRequest(with urlString : String, completionHandler : @escaping WeatherDataPassingClosure)
    {
        guard let url = URL(string: urlString)else{
            print("URL ERROR")
            return
        }
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            if let serverError = error
            {
                print(serverError.localizedDescription)
            }
            
            guard let responseCode = response as? HTTPURLResponse else{return}
            print("Response Code :- \(responseCode.statusCode)")
            
            guard let serverData = data else{return}
            let weatherData = self.parseWeatherData(serverData: serverData)
            completionHandler(weatherData)
        }
        task.resume()
    }
    
    
    func parseWeatherData(serverData : Data) -> WeatherModel
    {
        var weatherInfo : WeatherModel?
        do
        {
            let decodeData = try JSONDecoder().decode(WeatherData.self, from: serverData)
            let name = decodeData.name
            let temp = decodeData.main.temp
            let cID = decodeData.weather[0].id

            
            weatherInfo = WeatherModel(name: name, temp: temp, conditionId: cID)
        }
        catch
        {
            print(error.localizedDescription)
        }
        return weatherInfo ?? WeatherModel(name: "test", temp: 0.0, conditionId: 0)
    }
}
