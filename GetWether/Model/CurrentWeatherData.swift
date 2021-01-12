//
//  WetherData.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 06.01.2021.
//

import Foundation

struct CurrentWeatherData: Decodable  {
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Double
        let humidity: Double
    }

    struct Coordinates: Decodable {
        let lon: Double
        let lat: Double
    }

    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
        
        var conditionName: String {
            get{
                switch id {
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
    }

    struct Clouds: Decodable {
        let all: Int
    }

    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coordinates
    let clouds: Clouds
    
}

