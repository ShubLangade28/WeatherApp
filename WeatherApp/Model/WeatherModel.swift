//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Mac on 12/05/22.
//

import Foundation
struct WeatherModel
{
    let name : String
    let temp : Double
    let conditionId : Int
    
    var conditionName : String {
        switch conditionId {
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        case 500...531:
            return "cloud.drizzle.fill"
        case 600...622:
            return "snow"
        case 701...781:
            return "tornado"
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        default:
            return "cloud"
        }
    }
    var tempratureString : String{
        return String(format : "%.1f", temp)
    }
}
