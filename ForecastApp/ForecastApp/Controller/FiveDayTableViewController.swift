//
//  FiveDayTableViewController.swift
//  ForecastApp
//
//  Created by  Developer on 07/02/2019.
//  Copyright © 2019 Developer Inc. All rights reserved.
//

import UIKit
class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var conditionIcon: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
}

class FiveDayTableViewController: UITableViewController {
    var weatherModel: WeatherStruct?
    var fiveDayAarr = [0,1,2,3,4]
    var weatherManager = ForecastDataModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard weatherModel != nil else {
            return
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDayAarr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
            as! WeatherTableViewCell
        guard let info = weatherModel else {
            return cell
        }
        if indexPath.row == 0 { //Current temperature
            let temp = String(format: "%.0f", (info.list?[0].main?.temp ?? 24.0) - 273.15)
            cell.tempLabel.text = temp + "℃"
        }else{ //Other day average temperature
            let temp = getDailyAverageTemp(fiveDayAarr[indexPath.row], info)
            cell.tempLabel.text = String(format: "%.0f",Double(temp) - 273.15) + "℃"
        }
        cell.cityTitleLabel.text = getDailyDate(fiveDayAarr[indexPath.row], info)

        let imageID = getDailyImage(fiveDayAarr[indexPath.row], info)
        cell.conditionIcon.image = UIImage(named: weatherManager.updateWeatherIcon(condition: imageID))
        return cell
    }
 


}
extension FiveDayTableViewController {
    private func getCurrentDate( _ d: Int)-> Date {
        var nowComponents = DateComponents()
        nowComponents.timeZone = NSTimeZone.local
        nowComponents.day = d
        let futureDate = Calendar.current.date(byAdding: nowComponents, to: Date())
        return futureDate!
    }
    
    func getDailyAverageTemp(_ d: Int, _ info: WeatherStruct) -> Int{
        var aveTemp: Float = 0;
        var count = 0;
        guard let arr = info.list else {
            return Int(aveTemp)
        }
        let date = getCurrentDate(d)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: date)
        for item in arr {
            if item.dtTxt?.hasPrefix(dateStr) ?? false {
                aveTemp = aveTemp + Float((item.main?.temp)!)
                count = count + 1
            }
        }
        if count != 0 {
            aveTemp = aveTemp/Float(count)
        }
        return Int(aveTemp)
    }
    
    func getDailyImage(_ d: Int, _ info: WeatherStruct) -> Int{
        guard let arr = info.list else {
            return 1
        }
        let date = getCurrentDate(d)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: date)
        for item in arr {
            if item.dtTxt?.hasPrefix(dateStr) ?? false {
                //info.list?[0].weather?[0].id ?? 1)
                return item.weather?[0].id ?? 1
            }
        }
       
        return 1
    }
    func getDailyDate(_ d: Int, _ info: WeatherStruct) -> String{
        guard info.list != nil else {
            return "Unknown"
        }
        let date = getCurrentDate(d)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: date)
        
        return dateStr
    }
}


