//
//  WetherManager.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 05.01.2021.
//

import Foundation

struct WatherManager {
    let watherURL = "http://api.openweathermap.org/data/2.5/weather?q=Sochi&appid=35964dd0b23f28e45cbba148ac73f96d&units=metric"
    
    func fetchWether(city name: String) {
        let urlString = "\(watherURL)&q=\(name)"
        print(urlString)
    }
    func erformRequest(urlString: String) {
        
    }
}
