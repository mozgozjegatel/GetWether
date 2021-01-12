//
//  ViewController.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 04.01.2021.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherResultLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var cityTextField: UITextField!
    var wetherManager = WeatherManager(collection: WeatherManager.WeatherCollectionQueryAPI.notset)
    
    var pageCount: Int = 0
    var currentViewControllerIndex: Int = 0
    
    var weatherResult = ["condition": "", "weatherData": ""]
    
    //    @IBAction func citySearch(_ sender: UIButton) {
    //        wetherManager.fetchWether(city: cityTextFied.text!)
    //        //wetherManager.performRequest(urlString: wetherManager.query)
    //        cityTextFied.endEditing(true)
    //    }
    
    @IBAction func coordinatesSearch(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        wetherManager.delegate = self
        cityTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Ok")
        wetherManager.fetchWether(city: cityTextField.text!)
        //        //wetherManager.performRequest(urlString: wetherManager.query)
        cityTextField.endEditing(true)
        return true
    }
}

//MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension WeatherViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let dataViewController = viewController as? DataViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dataViewController = viewController as? DataViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        if currentIndex == pageCount {
            return nil
        }
        
        currentIndex += 1
        
        currentViewControllerIndex = currentIndex
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageCount
    }
    
}
//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather<T>(_ weatherManager: WeatherManager, weather: T) where T : Decodable {
        DispatchQueue.main.async {
            if weatherManager.collection == .weather {
                var results = ""
                let w = weather as! CurrentWeatherData
                self.cityLabel.text = w.name
                self.pageCount = 1
                self.currentViewControllerIndex = 0
                self.weatherResult.updateValue(w.weather[0].conditionName.description, forKey: "condition")
                
                print("Update condition: \(self.weatherResult["condition"])")
                self.weatherResult.updateValue(
                    """
Temperature: \(w.main.temp)
Humidity: \(w.main.humidity)
""",
                    forKey: "weatherData")
                self.conditionView.image = UIImage(systemName: w.weather[0].conditionName)
                self.tempLabel.text = weatherManager.get(w.main.temp, in: weatherManager.units)
                
                for result in w.weather {
                    results = result.description
                }
                self.weatherResultLabel.text = results
                self.humidityLabel.text = w.main.humidity.description

                                print("Weather is: \(w)")
            } else if weatherManager.collection == .onecall {
                let w = weather as! OneCallWeatherData
                self.cityLabel.text = w.daily!.count.description
                self.pageCount = w.daily!.count
                print("Dealy weather is: \(w)")
                self.currentViewControllerIndex = 0
            }
        }
    }
    
    //    func didUpdateWeather(_ weatherManager: WeatherManager, weather: CurrentWeatherData) {
    //        DispatchQueue.main.async {
    //            self.cityLabel.text = weather.name
    //            self.tempLabel.text = "\(weather.main.temp)"
    //            self.tempImage.image = UIImage(systemName: weather.weather[0].conditionName)
    //            self.clouds.text = "\(weather.clouds)"
    //        }
    //        print("Weather is: \(weather)")
    //    }
    
    
    
    func detailViewControllerAt(index: Int) -> DataViewController?{
        
        if index >= pageCount {
            return nil
        }
        
        guard let dataViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: DataViewController.self)) as? DataViewController else {
            return nil
        }
        
        dataViewController.index = index
        dataViewController.cityText = weatherResult["weatherData"]
        print(weatherResult["condition"]!)
        dataViewController.currentweatherCunditionImage = UIImage(systemName: weatherResult["condition"]!)
        return dataViewController
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.cityLabel.text = "\(error)"
        }
        
    }
}
