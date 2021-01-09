//
//  ViewController.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 04.01.2021.
//

import UIKit

class ViewController: UIViewController,  UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextFied: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempImage: UIImageView!
    
    var wetherManager = WatherManager()
    
    
    @IBAction func citySearch(_ sender: UIButton) {
        wetherManager.fetchWether(city: cityTextFied.text!)
        wetherManager.performRequest(urlString: wetherManager.watherURL)
        cityTextFied.endEditing(true)
    }
    
    @IBAction func coordinatesSearch(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextFied.delegate = self
        wetherManager.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    func didUpdateWeather(weather: WeatherModel) {
        print("Weather is: \(weather)")
    }
    
}

