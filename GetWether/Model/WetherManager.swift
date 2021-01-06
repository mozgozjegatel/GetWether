//
//  WetherManager.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 05.01.2021.
//

import Foundation

struct WatherManager {
    let watherURL = "https://api.openweathermap.org/data/2.5/weather?q=Sochi&appid=35964dd0b23f28e45cbba148ac73f96d&units=metric"
    
    func fetchWether(city name: String) {
        let urlString = "\(watherURL)&q=\(name)"
        print(urlString)
    }
    func performRequest(urlString: String) {
        // создать URL
        
        if let url = URL(string: watherURL) {
            
            // создать URLSession
            
            let session = URLSession(configuration: .default)
            
            // назначить сессии задачу
            
            let task = session.dataTask(with:  url, completionHandler: hendle(data:response:error:))
            
            // выполнить задачу
            
            task.resume()
        }

        
    }
    
    func hendle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        }
        
    }
}
