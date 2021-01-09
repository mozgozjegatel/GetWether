//
//  WetherData.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 06.01.2021.
//

import Foundation

struct WetherData: Decodable  {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coordinates
    
}

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
}


