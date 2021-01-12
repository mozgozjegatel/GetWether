//
//  WeatherModel.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 06.01.2021.
//

import Foundation

struct CurrentWeatherModel: Decodable {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    let lon: Double
    let lat: Double
    let clouds: Int
    var temperatureString: String {
        get {
            return String.init(format: "%.1f", temperature)
        }
        set {
            
        }
    }
    
    var conditionName: String {
        get{
            switch conditionID {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 700...781: //Описывает техногенную обстановку
                return ""
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud"
                
            default:
                return "none"
            }
        }
    }
    
//    func getConditionName(weatherID: Int) -> String{
//
//
//    }
}
