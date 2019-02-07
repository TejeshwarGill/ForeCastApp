//
//  ForecastByCityController.swift
//  ForecastApp
//
//  Created by  Developer on 07/02/2019.
//  Copyright © 2019 Developer Inc. All rights reserved.
//

import Foundation
import UIKit

class ForecastByCityController: UIViewController {
    
    var delegate: CanReceive?
    
    @IBOutlet weak var updateWeatherButton: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        updateWeatherButton.setCornerRadius(radius: 5)
        cityTextField.setCornerRadius(radius: 5)
        cityTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        cityTextField.leftViewMode = .always

        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateWeatherByCityTapped(_ sender: UIButton) {
        delegate?.receivedCityName(city: cityTextField.text ?? "")
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
}
