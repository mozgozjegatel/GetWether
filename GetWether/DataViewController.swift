//
//  DataViewController.swift
//  GetWether
//
//  Created by SERGEY KULABUHOV on 11.01.2021.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var weatherResult: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    
    var cityText: String?
    var index: Int?
    var currentweatherCunditionImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherResult.text = cityText
        weatherConditionImage.image = currentweatherCunditionImage
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
