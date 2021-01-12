//
//  OneCallWeatherData.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 11.01.2021.
//

import Foundation

struct OneCallWeatherData: Decodable {
    struct Daily: Decodable {
        struct Temp: Decodable {
            let morn: Double
            let day: Double
            let eve: Double
            let night: Double
        }
        
        struct Weather: Decodable {
            let main: String
            let description: String
        }
        let dt: Date
        let temp: Temp
        let pressure: Double
        let humidity: Int
        let dew_point: Double
        let wind_speed: Double
        let wind_deg: Int
        let weather: [Weather]
        let clouds: Int
        let pop: Double
        let uvi: Double
        let rain: Double?
        let snow: Double?
        
    }
    
    let daily: [Daily]?
    
}
