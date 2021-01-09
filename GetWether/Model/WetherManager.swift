//
//  WetherManager.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 05.01.2021.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

struct WatherManager {
    
    let watherAPIURL = "https://api.openweathermap.org/data/2.5/weather"
    let appid = "5a0b4edb4f90b78b42e05e325d141b33"
    var watherURL = ""
    
    var delegate: WeatherManagerDelegate?
    
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
            if let weather = parceJSON(wetherData: safeData) {
                delegate?.didUpdateWeather(weather: weather)
                print(String(data: safeData, encoding: .utf8))
            }
                
                
            
            
        }
            
    }
    
    func parceJSON(wetherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WetherData.self, from: wetherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let lon = decodedData.coord.lon
            let lat = decodedData.coord.lat
            
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp, lon: lon, lat: lat)
            
            print(weather.conditionName)
            print("Lon: \(lon) Lat:\(lat)")
            
            print(decodedData.name)
            print(weather.temperatureString)
            print(decodedData.weather[0].description)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}

