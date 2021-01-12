//
//  WetherManager.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 05.01.2021.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather<T: Decodable>(_ weatherManager: WeatherManager, weather: T)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    // координаты - Красная Поляна
    private let kLat = 43.679700
    private let kLon = 40.204697
    
    private let url = "https://api.openweathermap.org/data"
    private let version = 2.5
    
    // указать сай ключ
    private let appid = "5a0b4edb4f90b78b42e05e325d141b33"
    var collection = WeatherCollectionQueryAPI.notset
    let units = Units.metric
    
    func get(_ temp: Double, in units: Units ) -> String {
        switch units {
        case .imperial:
            return "\(temp)℉"
        case .metric :
            if temp > 0 {
                return "+\(temp)℃"
            }
            return "\(temp)℃"
        case .standard :
            return "\(temp)K"
        }
    }
    
    private let exclude = [OnecallExclude.alerts.rawValue, OnecallExclude.current.rawValue, OnecallExclude.hourly.rawValue, OnecallExclude.minutely.rawValue]
    
    var curentWeatherAPIURL: String {
        "\(url)/\(version)/\(collection.rawValue)?appid=\(appid)&units=\(units.rawValue)"
    }
    var query = ""
    var delegate: WeatherManagerDelegate?
    
    enum WeatherCollectionQueryAPI: String {
        //для прогноза на 7 дней по заданным координатам
        case onecall = "onecall"
        //для запроса на текущий день по имени города
        case weather = "weather"
        //дифолтное значение
        case notset = "notset"
    }
    
    enum Units: String {
        case standard = "standard"
        case metric = "metric"
        case imperial = "imperial"
    }
    
    //параметры исключения результатов onecall запроса
    private enum OnecallExclude: String {
        case current = "current"
        case minutely = "minutely"
        case hourly = "hourly"
        case daily = "daily"
        case alerts = "alerts"
    }
    
    mutating func fetchWether(city name: String) {
        if name == "KP" {
            collection = .onecall
            query = "\(curentWeatherAPIURL)&lat=\(kLat)&lon=\(kLon)&exclude=\(exclude.joined(separator: ","))"
            performRequest(urlString: query)
        } else {
            collection = .weather
            query = "\(curentWeatherAPIURL)&q=\(name)"
            performRequest(urlString: query)
        }
    }
    
    func performRequest(urlString: String) {
        
        // создать URL
        
        if let url = URL(string: query) {
            
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
            delegate?.didFailWithError(error: error!)
            return
        }
        
        if let safeData = data {
            
            if collection == .weather {
                if let weather: CurrentWeatherData = parceJSON(wetherData: safeData) {
                    
                    delegate?.didUpdateWeather(self, weather: weather)
                    print(String(data: safeData, encoding: .utf8)!)
                }
            } else if collection == .onecall {
                print("Hendl ok: \(query)")
                if let weather: OneCallWeatherData = parceJSON(wetherData: safeData) {
                    
                    delegate?.didUpdateWeather(self, weather: weather)
                    print(String(data: safeData, encoding: .utf8)!)
                }
            }
            
        }
    }
    
    //    func parceJSON(wetherData: Data) -> CurrentWeatherModel?{
    //        let decoder = JSONDecoder()
    //        do {
    //
    //            let decodedData = try decoder.decode(CurrentWeatherData.self, from: wetherData)
    //            let id = decodedData.weather[0].id
    //            let temp = decodedData.main.temp
    //            let name = decodedData.name
    //            let lon = decodedData.coord.lon
    //            let lat = decodedData.coord.lat
    //            let clouds = decodedData.clouds.all
    //
    //
    //            let weather = CurrentWeatherModel(conditionID: id, cityName: name, temperature: temp, lon: lon, lat: lat, clouds: clouds)
    //
    //            print(weather.conditionName)
    //            print("Lon: \(lon) Lat:\(lat)")
    //            print(decodedData.name)
    //            print(weather.temperatureString)
    //            print(decodedData.weather[0].description)
    //
    //            return weather
    //        } catch {
    //            delegate?.didFailWithError(error: error)
    //            return nil
    //        }
    //    }
    
    
    func parceJSON<T: Decodable>(wetherData: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: wetherData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func decodeOneCall() {
        
    }
    
    func decodeCurrentWeather() {
        
    }
}


