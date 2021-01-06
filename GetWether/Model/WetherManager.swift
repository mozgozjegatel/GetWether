//
//  WetherManager.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 05.01.2021.
//

import Foundation

struct WatherManager {
    
    let watherAPIURL = "https://api.openweathermap.org/data/2.5/weather"
    let appid = "35964dd0b23f28e45cbba148ac73f96d"
    var watherURL = ""
    
    enum Units: String {
        case standard = "standard"
        case metric = "metric"
        case imperial = "imperial"
    }
    
    
    
    
    mutating func fetchWether(city name: String) {
        watherURL = "\(watherAPIURL)?appid=\(appid)&q=\(name)"
    }
    
    func performRequest(urlString: String) {
        // создать URL
        
        if let url = URL(string: watherURL) {
            
            // создать URLSession
            
            let session = URLSession(configuration: .default)
            
            // назначить сессии задачу
            
            let task = session.dataTask(with:  url, completionHandler: hendle)
            
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
            print(String(data: safeData, encoding: .utf8))
            
            parceJSON(wetherData: safeData)
        }
            
    }
    
    func parceJSON(wetherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WetherData.self, from: wetherData)
            let id = decodedData.weather[0].id
            print(getConditionName(weatherID: id))
            
            print(decodedData.name)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
        }
    }
    
    func getConditionName(weatherID: Int) -> String{
        switch weatherID {
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
