//
//  LocationForecastScreen.swift
//  ForecastApp
//
//  Created by  Developer on 07/02/2019.
//  Copyright © 2019 Developer Inc. All rights reserved.
//

import UIKit
import CoreLocation

class LocationForecastScreen: UIViewController, CanReceive {
    
    let locationManager = CLLocationManager()
    let networkManager = NetworkManager()
    var weatherModel: WeatherStruct?
    var weatherManager = ForecastDataModel()
    let animationsManager = SimpleAnimator()
    lazy var tableVC: FiveDayTableViewController = {
        return self.children.lazy.compactMap( { $0 as? FiveDayTableViewController }).first!
    }()
    
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionIcon: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLocationManager()
        
    }
    
    @IBAction func nextScreenTapped(_ sender: UIButton) {
        DispatchQueue.main.async { [unowned self] in
            self.performSegue(withIdentifier: "goToWeatherByCity", sender: self)
        }
    }
    
    func receivedCityName(city: String) {
        print(city)
        networkManager.getWeatherDataByCity(city: city) { (result) in
            switch result {
            case .success(let weatherModel):
                self.weatherModel = weatherModel
                DispatchQueue.main.async {
                    self.updateWeatherInfo(info: weatherModel)
                }
                print(weatherModel)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.animationsManager.fadeInAndOutAnimation(view: self.wrongLabel)
                    
                }
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWeatherByCity" {
            guard let destinationVc = segue.destination as? ForecastByCityController else { return }
            destinationVc.delegate = self
        }
    }
    
    func setupViews() {
        wrongLabel.layer.opacity = 0
        conditionIcon.image = UIImage(named: "Cloud-Refresh")
        tempLabel.text = "--℃"
        cityLabel.text = "Updating..."
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func updateWeatherInfo(info: WeatherStruct) {
        let temp = String(format: "%.0f", (info.list?[0].main?.temp ?? 24.0) - 273.15)
        tempLabel.text = temp + "℃"
        cityLabel.text = (info.city?.name ?? "") +  "," + (info.city?.country ?? "")
        conditionIcon.image = UIImage(named: weatherManager.updateWeatherIcon(condition: info.list?[0].weather?[0].id ?? 1))
       tableVC.weatherModel = info
       tableVC.tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}

//MARK: CoreLocation delegate methods - TODO

extension LocationForecastScreen: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("long = \(location.coordinate.longitude)", "lat = \(location.coordinate.latitude)")
            let latitude = location.coordinate.latitude.description
            let longitude = location.coordinate.longitude.description
            
            networkManager.getWeatherData(lat: latitude, lon: longitude) { (result) in
                switch result {
                case .success(let weatherModel):
                    self.weatherModel = weatherModel
                    DispatchQueue.main.async {
                        self.updateWeatherInfo(info: weatherModel)
                    }
                    print(weatherModel)
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

